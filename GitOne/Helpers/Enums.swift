//
//  Enums.swift
//  GitOne
//
//  Created by Aleh Mazol on 29/03/2025.
//

import Foundation

enum SelectedTab: Int, CaseIterable, Identifiable {
    case home = 1, search
    
    var id: Int { rawValue }
    
    var localizedName: String {
        switch self {
            case .home:
                return String(localized: "Home",
                              defaultValue: "Home")
            case .search:
                return String(localized: "Search",
                              defaultValue: "Search")
        }
    }
    
    var iconName: String {
        switch self {
            case .home:
                return "house"
            case .search:
                return "magnifyingglass"
        }
    }
}

enum ActiveHomeSheet: Int, Hashable, CaseIterable, Identifiable {
    case settingsSheet
    case onboardingSheet
    
    var id: Int { rawValue }
    
    var localizedName: String {
        switch self {
        case .settingsSheet:
            return String(localized: "Settings",
                          defaultValue: "Settings")
        case .onboardingSheet:
            return String(localized: "Onboarding",
                          defaultValue: "Onboarding")
        }
    }
}

enum ColorTheme: Int, Hashable, CaseIterable, Identifiable {
    case systemTheme
    case darkTheme
    case lightTheme
    
    var id: Int { rawValue }

    var name: String {
        switch self {
            case .systemTheme:
                return String(localized: "System",
                              defaultValue: "System")
            case .darkTheme:
                return String(localized: "Dark",
                              defaultValue: "Dark")
            case .lightTheme:
                return String(localized: "Light",
                              defaultValue: "Light")
        }
    }
}
