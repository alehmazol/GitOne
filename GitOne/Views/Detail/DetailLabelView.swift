//
//  DetailLabelView.swift
//  GitOne
//
//  Created by Aleh Mazol on 31/03/2025.
//

import SwiftUI

struct DetailLabelView: View {
    let horizontalSizeClass: UserInterfaceSizeClass?
    let labelName: String
    let labelSymbol: String
    let labelText: String?
    var imageColor: Color = .gray
    var fontWeight: Font.Weight = .bold
    var symbolVariant: SymbolVariants = .none
    @State private var animate = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label {
                Text(labelName)
                    .font(.system(horizontalSizeClass == .compact
                                  ? .subheadline
                                  : .headline, design: .rounded).weight(.semibold))
                    .textCase(.uppercase)
                    .foregroundStyle(Color.secondary)
            } icon: {
                Image(systemName: labelSymbol)
                    .font(.system(horizontalSizeClass == .compact
                                  ? .headline
                                  : .title3,
                                  design: .rounded,
                                  weight: .bold))
                    .foregroundStyle(imageColor.gradient.shadow(.drop(radius: 1, x: 0.5, y: 1)))
                    .fontWeight(fontWeight)
                    .symbolVariant(symbolVariant)
                    .symbolEffect(.bounce, options: .speed(0.5), value: animate)
            }
            
            Text(labelText ?? String(localized: "Unknown",
                                     defaultValue: "Unknown"))
                .font(horizontalSizeClass == .compact
                      ? .headline
                      : .title3)
                .foregroundStyle(Color.primary)
                .fontWeight(.medium)
                .kerning(0.2)
                .fontDesign(.rounded)
                .allowsTightening(true)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .detailLabelStyling()
        .task {
            animate = true
        }
    }
}

#Preview {
    DetailLabelView(horizontalSizeClass: .regular,
                    labelName: String(localized: "Project Name", defaultValue: "Project Name"),
                    labelSymbol: "character.cursor.ibeam",
                    labelText: String(localized: "Unknown", defaultValue: "Unknown"))
}
