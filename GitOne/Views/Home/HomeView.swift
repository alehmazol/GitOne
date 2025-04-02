//
//  HomeView.swift
//  GitOne
//
//  Created by Aleh Mazol on 29/03/2025.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @AppStorage(wrappedValue: false, "isPresentedOnboarding") var isPresentedOnboarding
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.navigationCoordinator) private var navigationCoordinator
    @State private var networkMonitor = NetworkMonitor()
    
    @State private var viewModel = HomeViewModel()
            
    @SectionedFetchRequest<String, Item>(sectionIdentifier: \Item.timestamp_str,
                                         sortDescriptors: [SortDescriptor(\Item.timestamp,
                                                                           order: .reverse),
                                                           SortDescriptor(\Item.stars,
                                                                           order: .reverse)],
                                         animation: .easeInOut) private var gitProjectsBySection

    var body: some View {
        @Bindable var navigationCoordinator = navigationCoordinator
        
        NavigationStack(path: $navigationCoordinator.navigationHome) {
            VStack {
                gridContent
            }
            .animation(.easeInOut, value: viewModel.dataPreloaded)
            .animation(.easeInOut, value: gitProjectsBySection.count)
            .homeVStackStyling()
            .toolbar { toolbarContent }
            .refreshable {
                Task { await refreshData() }
            }
            .background { backgroundContent }
            .navigationDestination(for: Item.self) { project in
                DetailView(project: project)
            }
            .sheet(item: $viewModel.activeHomeSheet) { sheet in
                switch sheet {
                    case .settingsSheet:
                        SettingsView()
                    case .onboardingSheet:
                        OnboardingView(horizontalSizeClass: horizontalSizeClass)
                        .presentationCompactAdaptation(horizontalSizeClass == .compact
                                                       ? .fullScreenCover
                                                       : .sheet)
                }
            }
            .alert(String(localized: "Error", defaultValue: "Error"),
                   isPresented: $viewModel.isDisplayingError) {
                Button(String(localized: "Close", defaultValue: "Close"), role: .cancel) {
                    viewModel.alertMessage = ""
                    viewModel.isDisplayingError = false
                }
            } message: {
                Text(viewModel.alertMessage)
            }
            .onAppear { networkMonitor.start() }
            .task { await preloadData() }
            .onDisappear { networkMonitor.stop() }
        }
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext,
                      PersistenceController.preview.container.viewContext)
}

//: MARK: - EXTENSION COMPONENTS
private extension HomeView {
    @ViewBuilder
    var gridContent: some View {
        if viewModel.dataPreloaded {
            GeometryReader { geometry in
                let columns = [GridItem(.adaptive(minimum: horizontalSizeClass == .compact && verticalSizeClass == .regular
                                                  ? geometry.size.width
                                                  : horizontalSizeClass == .compact && verticalSizeClass == .compact
                                                  ? (geometry.size.width / 2) - 24
                                                  : (geometry.size.width / 3) - 32),
                                        spacing: horizontalSizeClass == .compact ? 8 : 16,
                                        alignment: .topLeading)]
                
                ScrollViewReader { scrollView in
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns,
                                  alignment: .leading,
                                  spacing: horizontalSizeClass == .compact ? 12 : 16) {
                            ForEach(gitProjectsBySection) {section in
                                Section {
                                    ForEach(section) {gitProject in
                                        NavigationLink(value: gitProject) {
                                            CardView(colorScheme: colorScheme, gitProject: gitProject)
                                        }
                                    }
                                } header: {
                                    if !gitProjectsBySection.isEmpty {
                                        GridHeaderView(title: section.id, projectsCount: section.count)
                                    }
                                }
                            }
                        }
                        .homeVGridStyling(sizeClass: horizontalSizeClass)
                    }
                    .homeScrollStyling()
                }
            }
        } else {
            ProgressView()
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Text(String(localized: "Trending",
                        defaultValue: "Trending"))
                .font(horizontalSizeClass == .compact
                      ? .system(.title3, weight: .bold)
                      : .system(.largeTitle, weight: .heavy))
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.activeHomeSheet = .settingsSheet
            } label: {
                Image(systemName: "gearshape")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.blue, .gray.quinary)
                    .symbolVariant(.circle.fill)
                    .scaleEffect(horizontalSizeClass == .compact ? 1.25 : 1.5,
                                 anchor: .trailing)
            }
        }
    }
    
    @ViewBuilder
    var backgroundContent: some View {
        if viewModel.dataPreloaded,
           gitProjectsBySection.isEmpty {
            CustomUnavailableView(horizontalSizeClass: horizontalSizeClass,
                                  symbolName: "document.on.clipboard",
                                  title: String(localized: "No Projects",
                                                defaultValue: "No Projects"),
                                  description: String(localized: "Trending projects are not available yet.",
                                                      defaultValue: "Trending projects are not available yet."),
                                  projectsEmpty: gitProjectsBySection.isEmpty)
        }
    }
}

//: MARK: - EXTENSION HELPER FUNCTIONS
private extension HomeView {
    func preloadData() async {
        if !isPresentedOnboarding {
            viewModel.activeHomeSheet = .onboardingSheet
        }

        try? await Task.sleep(for: .milliseconds(350))
        viewModel.dataPreloaded = true
                
        getData()
    }
    
    func refreshData() async {
        getData()
    }
    
    func getData() {
        checkInternetConnection()
        
        let sectionFirst = gitProjectsBySection.first
        let sectionTimestamp = sectionFirst?.first?.timestamp
        
        if gitProjectsBySection.isEmpty {
            getTrendingProjects()
        } else if let sectionFirst,
           let sectionTimestamp,
           Calendar.current.isDate(sectionTimestamp, inSameDayAs: Date()) == true,
           sectionFirst.count == 0 {
            getTrendingProjects()
        } else if let sectionTimestamp,
                  Calendar.current.isDate(sectionTimestamp, inSameDayAs: Date()) == false {
            getTrendingProjects()
        }
    }
    
    func getTrendingProjects() {
        Item.fetchTrendingProjects { result in
            switch result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let items = json["items"] as? [[String: Any]] {
                            for repo in items {
                                if let errorMessage = Item.saveItem(using: viewContext,
                                                                    repo: repo) {
                                    viewModel.alertMessage = errorMessage
                                    viewModel.isDisplayingError = true
                                }
                            }
                        }
                    } catch let error {
                        viewModel.alertMessage = error.localizedDescription
                        viewModel.isDisplayingError = true
                    }
                    
                case .failure(let error):
                    viewModel.alertMessage = error.localizedDescription
                    viewModel.isDisplayingError = true
            }
        }
    }
    
    func checkInternetConnection() {
        guard networkMonitor.isConnected else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                viewModel.alertMessage = String(localized: "Network connection unavailable. Please verify your internet settings and retry.",
                                                defaultValue: "Network connection unavailable. Please verify your internet settings and retry.")
                viewModel.isDisplayingError = true
            }
            return
        }
    }
}


