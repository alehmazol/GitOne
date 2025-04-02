//
//  NetworkMonitor.swift
//  GitOne
//
//  Created by Aleh Mazol on 31/03/2025.
//

import Network
import SwiftUI

@MainActor
@Observable final class NetworkMonitor {
    private(set) var isConnected = true
    private(set) var isCellular = false
    
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
}

//: MARK: - FUNCTIONS
extension NetworkMonitor {
    func start() {
        networkMonitor.start(queue: workerQueue)
        networkMonitor.pathUpdateHandler = { path in
            Task {
                await MainActor.run {
                    self.isConnected = path.status == .satisfied
                    self.isCellular = path.usesInterfaceType(.cellular)
                }
            }
        }
    }
    
    func stop() {
        networkMonitor.cancel()
    }
}
