//
//  ViewModifiers.swift
//  GitOne
//
//  Created by Aleh Mazol on 31/03/2025.
//

import SwiftUI

struct HomeVGridSettings: ViewModifier {
    let horizontalSizeClass: UserInterfaceSizeClass?
    
    public func body(content: Content) -> some View {
        content
            .safeAreaPadding(.bottom)
            .safeAreaPadding(.horizontal, horizontalSizeClass == .compact ? 16 : 24)
    }
}

struct HomeScrollSettings: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .scrollIndicators(.automatic, axes: .vertical)
            .scrollIndicatorsFlash(onAppear: true)
            .scrollClipDisabled(true)
    }
}

struct HomeVStackSettings: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .persistentSystemOverlays(.hidden)
    }
}

struct SearchVGridSettings: ViewModifier {
    let horizontalSizeClass: UserInterfaceSizeClass?
    
    public func body(content: Content) -> some View {
        content
            .safeAreaPadding(.bottom)
            .safeAreaPadding(.horizontal, horizontalSizeClass == .compact ? 16 : 24)
            .transition(.opacity)
    }
}

struct SearchScrollSettings: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .scrollIndicators(.automatic, axes: .vertical)
            .scrollIndicatorsFlash(onAppear: true)
            .scrollClipDisabled(true)
    }
}

struct SearchVStackSettings: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .persistentSystemOverlays(.hidden)
    }
}

struct CardSettings: ViewModifier {
    var colorScheme: ColorScheme
    
    public func body(content: Content) -> some View {
        content
            .padding()
            .background {
                Color(uiColor: colorScheme == .light ? .systemBackground : .secondarySystemBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: .black.opacity(0.15), radius: 16)
            }
            .transition(.scale(scale: 0.85, anchor: .center).combined(with: .push(from: .top).combined(with: .opacity)))
    }
}

struct DetailSettings: ViewModifier {
    let horizontalSizeClass: UserInterfaceSizeClass?
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, horizontalSizeClass == .compact ? 8 : 16)
            .navigationTitle(String(localized: "Project Details",
                                    defaultValue: "Project Details"))
            .persistentSystemOverlays(.hidden)
    }
}

struct SettingsStyle: ViewModifier {    
    public func body(content: Content) -> some View {
        content
            .navigationTitle(String(localized: "Settings",
                                    defaultValue: "Settings"))
            .navigationBarTitleDisplayMode(.inline)
            .persistentSystemOverlays(.hidden)
    }
}

struct DescriptionSettings: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .navigationTitle(String(localized: "Description",
                                    defaultValue: "Description"))
            .navigationBarTitleDisplayMode(.inline)
            .persistentSystemOverlays(.hidden)
    }
}

struct DetailLabelSettings: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .transition(.opacity.combined(with: .push(from: .top)))
    }
}

struct OnboardingVStackSettings: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaPadding()
            .interactiveDismissDisabled()
            .presentationCornerRadius(20)
            .persistentSystemOverlays(.hidden)
            //.background(Color(.launchScreen))
    }
}
