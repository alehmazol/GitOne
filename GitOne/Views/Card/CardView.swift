//
//  CardView.swift
//  GitOne
//
//  Created by Aleh Mazol on 30/03/2025.
//

import SwiftUI

struct CardView: View {
    let colorScheme: ColorScheme
    let gitProject: Item
    
    var body: some View {
        VStack(spacing: 8) {
            CardTitleView(title: gitProject.projectName)
            projectInfo
        }
        .cardStyling(colorScheme: colorScheme)
    }
}

#Preview {
    CardView(colorScheme: .dark, gitProject: Item())
}

//: MARK: - EXTENSION COMPONENTS
private extension CardView {
    var projectInfo: some View {
        HStack(alignment: .bottom) {
            CardTextView(text: gitProject.projectLanguage)
            
            CardLabelView(countNumber: Int(gitProject.stars),
                          imageName: "star",
                          imageColor: .yellow,
                          fontWeight: .bold,
                          symbolVariant: .fill,
                          alignment: .center)
            
            CardLabelView(countNumber: Int(gitProject.forks),
                          imageName: "tuningfork",
                          imageColor: .mint,
                          fontWeight: .heavy,
                          symbolVariant: .none,
                          alignment: .trailing)
        }
    }
}
