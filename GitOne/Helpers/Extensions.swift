//
//  Extensions.swift
//  GitOne
//
//  Created by Aleh Mazol on 29/03/2025.
//

import SwiftUI

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension View {
    func homeVGridStyling(sizeClass: UserInterfaceSizeClass?) -> some View {
        self.modifier(HomeVGridSettings(horizontalSizeClass: sizeClass))
    }
    
    func homeScrollStyling() -> some View {
        self.modifier(HomeScrollSettings())
    }
    
    func homeVStackStyling() -> some View {
        self.modifier(HomeVStackSettings())
    }
    
    func cardStyling(colorScheme: ColorScheme) -> some View {
        self.modifier(CardSettings(colorScheme: colorScheme))
    }
    
    func searchVGridStyling(sizeClass: UserInterfaceSizeClass?) -> some View {
        self.modifier(SearchVGridSettings(horizontalSizeClass: sizeClass))
    }
    
    func searchScrollStyling() -> some View {
        self.modifier(SearchScrollSettings())
    }
    
    func searchVStackStyling() -> some View {
        self.modifier(SearchVStackSettings())
    }
    
    func detailStyling(sizeClass: UserInterfaceSizeClass?) -> some View {
        self.modifier(DetailSettings(horizontalSizeClass: sizeClass))
    }
    
    func settingsStyling() -> some View {
        self.modifier(SettingsStyle())
    }
    
    func descriptionStyling() -> some View {
        self.modifier(DescriptionSettings())
    }
    
    func detailLabelStyling() -> some View {
        self.modifier(DetailLabelSettings())
    }
    
    func onboardingVStackStyling() -> some View {
        self.modifier(OnboardingVStackSettings())
    }
}
