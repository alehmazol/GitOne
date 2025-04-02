//
//  CardLabelView.swift
//  GitOne
//
//  Created by Aleh Mazol on 31/03/2025.
//

import SwiftUI

struct CardLabelView: View {
    let countNumber: Int
    let imageName: String
    let imageColor: Color
    let fontWeight: Font.Weight
    let symbolVariant: SymbolVariants
    let alignment: Alignment
    
    var body: some View {
        Label {
            Text(Int(countNumber), format: .number)
                .foregroundStyle(Color.secondary)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .minimumScaleFactor(0.75)
                .lineLimit(1)
        } icon: {
            Image(systemName: imageName)
                .foregroundStyle(imageColor.gradient.shadow(.drop(radius: 1, x: 0.5, y: 1)))
                .fontWeight(fontWeight)
                .symbolVariant(symbolVariant)
        }
        .frame(maxWidth: .infinity, alignment: alignment)
    }
}

#Preview {
    CardLabelView(countNumber: 4,
                  imageName: "tuningfork",
                  imageColor: .mint,
                  fontWeight: .semibold,
                  symbolVariant: .none,
                  alignment: .trailing)
}
