//
//  NavigationCoordinator.swift
//  GitOne
//
//  Created by Aleh Mazol on 30/03/2025.
//

import SwiftUI

@Observable final class NavigationCoordinator {
    var navigationHome = NavigationPath()
    var navigationSearch = NavigationPath()
    
    @MainActor static let shared = NavigationCoordinator()
}

extension EnvironmentValues {
    var navigationCoordinator: NavigationCoordinator {
        get { self[NavigationCoordinatorKey.self] }
        set { self[NavigationCoordinatorKey.self] = newValue }
    }
}

private struct NavigationCoordinatorKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: NavigationCoordinator = NavigationCoordinator()
}
