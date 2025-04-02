//
//  DescriptionView.swift
//  GitOne
//
//  Created by Aleh Mazol on 31/03/2025.
//

import SwiftUI

struct DescriptionView: View {
    var body: some View {
        Form {
            Text("The Git One app retrieves trending GitHub projects from the past seven days, ranked by the number of stars they’ve received.")
                .multilineTextAlignment(.leading)
        }
        .descriptionStyling()
    }
}

#Preview {
    DescriptionView()
}
