//
//  HomeViewModel.swift
//  GitOne
//
//  Created by Aleh Mazol on 30/03/2025.
//

import SwiftUI

@MainActor
@Observable final class HomeViewModel {
    var activeHomeSheet: ActiveHomeSheet?
    var dataPreloaded = false
    
    var alertMessage = ""
    var isDisplayingError = false
}
