//
//  DetailView.swift
//  GitOne
//
//  Created by Aleh Mazol on 30/03/2025.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let project: Item
    
    @State private var showDetailComponents = Array(repeating: false, count: 5)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                detailContent
                
                Spacer()
            }
            .detailStyling(sizeClass: horizontalSizeClass)
        }
        .contentMargins(16, for: .scrollContent)
        .task {
            try? await Task.sleep(for: .milliseconds(350))
            animateSeuqentially()
        }
    }
}

#Preview {
    DetailView(project: Item())
}

//: MARK: - EXTENSION COMPONENTS
private extension DetailView {
    @ViewBuilder
    var detailContent: some View {
        let layout =
        if horizontalSizeClass == .compact {
            AnyLayout(VStackLayout(alignment: .leading, spacing: 16))
        } else {
            AnyLayout(HStackLayout(alignment: .top))
        }
        
        layout {
            if showDetailComponents[0] == true {
                getComponentForIndex(index: 0)
            }
            
            if showDetailComponents[1] == true {
                getComponentForIndex(index: 1)
            }
        }
        
        layout {
            if showDetailComponents[2] == true {
                getComponentForIndex(index: 2)
            }
            
            if showDetailComponents[3] == true {
                getComponentForIndex(index: 3)
            }
        }
        
        layout {
            if showDetailComponents[4] == true {
                getComponentForIndex(index: 4)
            }
        }
    }
    
    var detailTitle: some View {
        DetailLabelView(horizontalSizeClass: horizontalSizeClass,
                        labelName: String(localized: "Project Name" , defaultValue: "Project Name"),
                        labelSymbol: "character.cursor.ibeam",
                        labelText: project.projectName,
                        imageColor: Color.primary)
    }
    
    var detailLanguage: some View {
        DetailLabelView(horizontalSizeClass: horizontalSizeClass,
                        labelName: String(localized: "Project Language" , defaultValue: "Project Language"),
                        labelSymbol: "gear",
                        labelText: project.projectLanguage,
                        imageColor: .indigo,
                        symbolVariant: .fill)
    }
    
    var detailStars: some View {
        DetailLabelView(horizontalSizeClass: horizontalSizeClass,
                        labelName: String(localized: "Project Stars" , defaultValue: "Project Stars"),
                        labelSymbol: "star",
                        labelText: String(localized: "\(project.stars) stars"),
                        imageColor: .yellow,
                        symbolVariant: .fill)
    }
    
    var detailForks: some View {
        DetailLabelView(horizontalSizeClass: horizontalSizeClass,
                        labelName: String(localized: "Project Forks" , defaultValue: "Project Forks"),
                        labelSymbol: "tuningfork",
                        labelText: String(localized: "\(project.forks) forks"),
                        imageColor: .mint,
                        fontWeight: .heavy,
                        symbolVariant: .none)
    }
    
    var detailDate: some View {
        DetailLabelView(horizontalSizeClass: horizontalSizeClass,
                        labelName: String(localized: "Sync Date" , defaultValue: "Sync Date"),
                        labelSymbol: "calendar",
                        labelText: project.timestamp_str,
                        imageColor: .cyan,
                        symbolVariant: .fill)
    }
}

//: MARK: - EXTENSION HELPER FUNCTIONS
private extension DetailView {
    @ViewBuilder
    func getComponentForIndex(index: Int) -> some View {
        switch index {
            case 0:
                detailTitle
            case 1:
                detailLanguage
            case 2:
                detailStars
            case 3:
                detailForks
            case 4:
                detailDate
            default:
                EmptyView()
        }
    }
    
    func animateSeuqentially() {
        let delayInterval = 1.75 / Double(showDetailComponents.count)
        for index in showDetailComponents.startIndex..<showDetailComponents.endIndex {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(index) * delayInterval)) {
                withAnimation(.smooth) {
                    showDetailComponents[index] = true
                }
            }
        }
    }
}
