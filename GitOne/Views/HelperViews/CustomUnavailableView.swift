//
//  CustomUnavailableView.swift
//  GitOne
//
//  Created by Aleh Mazol on 30/03/2025.
//

import SwiftUI

struct CustomUnavailableView: View {
    let horizontalSizeClass: UserInterfaceSizeClass?
    let symbolName: String
    let title: String
    let description: String
    let projectsEmpty: Bool
    
    var body: some View {
        ContentUnavailableView {
            VStack {
                if #available(iOS 18.0, *) {
                    Image(systemName: symbolName)
                        .unavailableImageStyling(sizeClass: horizontalSizeClass)
                        .symbolEffect(.bounce.up.byLayer, options: .nonRepeating)
                } else {
                    Image(systemName: symbolName)
                        .unavailableImageStyling(sizeClass: horizontalSizeClass)
                        .animation(.bouncy, value: projectsEmpty)
                }
                
                Text(title)
                    .font(horizontalSizeClass == .compact ? .title : .largeTitle)
                    .fontWeight(.heavy)
            }
        } description: {
            Text(description)
                .font(horizontalSizeClass == .compact ? .title3 : .title)
        }
        .animation(.smooth, value: projectsEmpty)
        .transition(.opacity.combined(with: .scale))
    }
}

#Preview {
    CustomUnavailableView(horizontalSizeClass: .regular,
                          symbolName: "document.on.clipboard",
                          title: "No Projects",
                          description: "Trending projects are not available yet.",
                          projectsEmpty: true)
}

extension View {
    fileprivate func unavailableImageStyling(sizeClass: UserInterfaceSizeClass?) -> some View {
        self.modifier(UnavailableImageSettings(horizontalSizeClass: sizeClass))
    }
}
struct UnavailableImageSettings: ViewModifier {
    let horizontalSizeClass: UserInterfaceSizeClass?
    
    public func body(content: Content) -> some View {
        content
            .imageScale(.large)
            .scaleEffect(horizontalSizeClass == .compact
                         ? 1.5
                         : 2.0, anchor: .bottom)
            .fontWeight(.bold)
            .symbolRenderingMode(.hierarchical)
            .symbolVariant(.fill)
    }
}
