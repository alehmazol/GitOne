//
//  CardTextView.swift
//  GitOne
//
//  Created by Aleh Mazol on 31/03/2025.
//

import SwiftUI

struct CardTextView: View {
    let text: String?
    
    var body: some View {
        Label {
            ViewThatFits(in: .horizontal) {
                Text(text ?? String(localized: "None", defaultValue: "None"))
                if let firstChar = text?.first {
                    Text(String(firstChar))
                }
            }
            .foregroundStyle(Color.secondary)
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .lineLimit(1)
        } icon: {
            Image(systemName: "gear")
                .foregroundStyle(.indigo.gradient.shadow(.drop(radius: 1, x: 0.5, y: 1)))
                .fontWeight(.bold)
                .symbolVariant(.fill)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CardTextView(text: "Language")
}
