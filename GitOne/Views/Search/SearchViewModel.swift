//
//  SearchViewModel.swift
//  GitOne
//
//  Created by Aleh Mazol on 30/03/2025.
//

import SwiftUI

@MainActor
@Observable final class SearchViewModel {
    var dataPreloaded = false
    var debounceTask: Task<Void, Never>? = nil
    var searchInitialized = false
    var searchedName = ""
    var hideOverlay = true
    
    var isSearching: Bool {
        searchInitialized || !searchedName.isEmpty
    }
}
