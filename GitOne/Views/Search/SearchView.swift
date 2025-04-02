//
//  SearchView.swift
//  GitOne
//
//  Created by Aleh Mazol on 29/03/2025.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.navigationCoordinator) private var navigationCoordinator
    
    @FetchRequest<Item>(sortDescriptors: [SortDescriptor(\Item.timestamp,
                                                          order: .reverse),
                                          SortDescriptor(\Item.stars,
                                                          order: .reverse)],
                        animation: .easeInOut.speed(0.75)) private var gitProjects
    
    @State private var viewModel = SearchViewModel()
    
    var body: some View {
        @Bindable var navigationCoordinator = navigationCoordinator
        
        NavigationStack(path: $navigationCoordinator.navigationSearch) {
            VStack { gridContent }
            .animation(.easeInOut, value: viewModel.dataPreloaded)
            .searchVStackStyling()
            .searchable(text: $viewModel.searchedName,
                        isPresented: $viewModel.searchInitialized,
                        placement: horizontalSizeClass == .compact
                        ? .navigationBarDrawer(displayMode: .always)
                        : .toolbar,
                        prompt: Text(String(localized: "Search by Name",
                                            defaultValue: "Search by Name"))) 
            .toolbar { toolbarContent }
            .overlay { overlayContent }
            .background { backgroundContent }
            .navigationDestination(for: Item.self) { project in
                DetailView(project: project)
            }
            .task {
                try? await Task.sleep(for: .milliseconds(350))
                viewModel.dataPreloaded = true
            }
            .onChange(of: viewModel.searchedName) { _, newValue in
                withAnimation {
                    viewModel.hideOverlay = false
                }
                filterSearch(newValue)
            }
            .onTapGesture {
                withAnimation {
                    viewModel.hideOverlay = true
                }
            }
        }
    }
}

#Preview {
    SearchView()
}

//: MARK: - EXTENSION COMPONENTS
private extension SearchView {
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
                            Section {
                                ForEach(gitProjects) {gitProject in
                                    NavigationLink(value: gitProject) {
                                        CardView(colorScheme: colorScheme, gitProject: gitProject)
                                    }
                                }
                            } header: {
                                if gitProjects.count > 0 {
                                    GridHeaderView(title: !viewModel.searchInitialized || viewModel.searchedName.isEmpty
                                                   ? String(localized: "All Projects",
                                                            defaultValue: "All Projects")
                                                   : String(localized: "Search Results",
                                                            defaultValue: "Search Results"),
                                                   projectsCount: gitProjects.count)
                                    .contentTransition(.opacity)
                                    .animation(.easeInOut, value: !viewModel.searchInitialized || viewModel.searchedName.isEmpty)
                                }
                            }
                        }
                        .searchVGridStyling(sizeClass: horizontalSizeClass)
                    }
                    .searchScrollStyling()
                }
            }
        } else {
            ProgressView()
        }
    }
    
    @ViewBuilder
    var overlayContent: some View {
        if viewModel.isSearching && !viewModel.hideOverlay {
            Color.black
                .opacity(0.15)
                .blur(radius: 2)
                .ignoresSafeArea(.all)
        }
    }
    
    @ViewBuilder
    var backgroundContent: some View {
        if viewModel.dataPreloaded, gitProjects.isEmpty {
            if viewModel.isSearching {
                CustomUnavailableView(horizontalSizeClass: horizontalSizeClass,
                                      symbolName: "rectangle.and.text.magnifyingglass",
                                      title: String(localized: "No Results", defaultValue: "No Results"),
                                      description: String(localized: "No projects found. Try adjusting your search.",
                                                          defaultValue: "No projects found. Try adjusting your search."),
                                      projectsEmpty: gitProjects.isEmpty)
            } else {
                CustomUnavailableView(horizontalSizeClass: horizontalSizeClass,
                                      symbolName: "document.on.clipboard",
                                      title: String(localized: "No Projects",
                                                    defaultValue: "No Projects"),
                                      description: String(localized: "Trending projects are not available yet.",
                                                          defaultValue: "Trending projects are not available yet."),
                                      projectsEmpty: gitProjects.isEmpty)
            }
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Text(String(localized: "Search", defaultValue: "Search"))
                .font(horizontalSizeClass == .compact
                      ? .system(.title3, weight: .bold)
                      : .system(.largeTitle, weight: .heavy))
        }
    }
}

//: MARK: - EXTENSION HELPER FUNCTIONS
private extension SearchView {
    func filterSearch(_ newValue: String) {
        viewModel.debounceTask?.cancel()
        viewModel.debounceTask = Task {
            guard !Task.isCancelled else { return }
            
            let config = gitProjects
            
            if newValue.isEmpty {
                config.nsPredicate = nil
            } else {
                try? await Task.sleep(for: .milliseconds(350))
                config.nsPredicate = NSPredicate(format: "projectName CONTAINS[cd] %@", newValue)
            }
        }
    }
}




