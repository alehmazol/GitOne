//
//  GitOneApp.swift
//  GitOne
//
//  Created by Aleh Mazol on 29/03/2025.
//

import SwiftUI

@main
struct GitOneApp: App {
    @State private var navigationCoordinator = NavigationCoordinator.shared
    @State private var activeTab = SelectedTab.home
    
    var body: some Scene {
        WindowGroup {
            Group {
                if #available(iOS 18.0, *) {
                    TabView(selection: $activeTab) {
                        Tab(value: SelectedTab.home, role: .none) {
                            HomeView()
                        } label: {
                            Label(SelectedTab.home.localizedName,
                                  systemImage: SelectedTab.home.iconName)
                        }
                        
                        Tab(value: SelectedTab.search, role: .search) {
                            SearchView()
                        } label: {
                            Label(SelectedTab.search.localizedName,
                                  systemImage: SelectedTab.search.iconName)
                        }
                    }
                    .tabViewStyle(.tabBarOnly)
                } else {
                    TabView(selection: $activeTab) {
                        HomeView()
                            .tabItem {
                                Label(SelectedTab.home.localizedName,
                                      systemImage: SelectedTab.home.iconName)
                            }
                            .tag(SelectedTab.home)
                        
                        SearchView()
                            .tabItem {
                                Label(SelectedTab.search.localizedName,
                                      systemImage: SelectedTab.search.iconName)
                            }
                            .tag(SelectedTab.search)
                    }
                }
            }
            .persistentSystemOverlays(.hidden)
            .environment(\.navigationCoordinator, navigationCoordinator)
            .environment(\.managedObjectContext,
                          PersistenceController.shared.container.viewContext)
            .onAppear {
                let applicationColorScheme = UserDefaults.standard.integer(forKey: "systemColorScheme")
                
                let scenes = UIApplication.shared.connectedScenes
                guard let scene = scenes.first as? UIWindowScene else { return }
                scene.keyWindow?.overrideUserInterfaceStyle =
                    applicationColorScheme == ColorTheme.darkTheme.id
                        ? .dark
                        : applicationColorScheme == ColorTheme.lightTheme.id
                            ? .light
                            : .unspecified
            }
        }
    }
}
