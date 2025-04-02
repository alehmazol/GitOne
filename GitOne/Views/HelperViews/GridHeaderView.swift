//
//  GridHeaderView.swift
//  GitOne
//
//  Created by Aleh Mazol on 30/03/2025.
//

import SwiftUI

struct GridHeaderView: View {
    let title: String
    let projectsCount: Int
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 17, weight: .heavy, design: .default))
                .foregroundStyle(.cyan.gradient)
            
            Spacer()
            
            Text(String(localized: "\(projectsCount) projects"))
                .textCase(.lowercase)
                .font(.system(size: 16, weight: .medium, design: .rounded).uppercaseSmallCaps().monospacedDigit())
                .foregroundStyle(Color.secondary)
                .allowsTightening(true)
                .fixedSize()
                .contentTransition(.numericText(value: Double(projectsCount)))
        }
        .padding(.horizontal, 8)
        .offset(y: 8)
    }
}

#Preview {
    GridHeaderView(title: "All Projects", projectsCount: 10)
}
