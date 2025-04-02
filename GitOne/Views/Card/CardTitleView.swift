//
//  CardTitleView.swift
//  GitOne
//
//  Created by Aleh Mazol on 31/03/2025.
//

import SwiftUI

struct CardTitleView: View {
    let title: String?
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title ?? String(localized: "Unknown",
                                 defaultValue: "Unknown"))
                .font(.headline.leading(.loose))
                .fontWeight(.semibold)
                .foregroundStyle(Color.primary)
                .multilineTextAlignment(.leading)
                .lineSpacing(5)
                .kerning(0.2)
                .lineLimit(2, reservesSpace: true)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(Color.secondary)
                .fontWeight(.medium)
                .imageScale(.medium)
        }
    }
}

#Preview {
    CardTitleView(title: "Project Name")
}
