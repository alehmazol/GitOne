//
//  ItemExtension.swift
//  GitOne
//
//  Created by Aleh Mazol on 29/03/2025.
//

import CoreData

extension Item {
    @objc var timestamp_str: String {
        if let timestamp {
            return "\(timestamp.formatted(.dateTime.weekday(.abbreviated))) \u{2219} \(timestamp.formatted(date: .long, time: .omitted))"
        } else {
            return ""
        }
    }
    
    @MainActor static func fetchTrendingProjects(completion: @Sendable @MainActor @escaping (Result<Data, Error>) -> Void) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        guard let currentDate = calendar.date(from: components),
           let sevenDaysBefore = calendar.date(byAdding: .day, value: -7, to: currentDate) else {
            return
        }
        
        guard let url = URL(string: "https://api.github.com/search/repositories?q=created:>\(sevenDaysBefore.toString())+stars:>10&sort=stars&order=desc&page=1&per_page=100") else {
            let error = NSError(domain: "InvalidURL",
                                code: 1001,
                                userInfo: [NSLocalizedDescriptionKey: "Failed to create URL."])
            completion(.failure(error))
            
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            Task { @MainActor in
                guard error == nil else {
                    if let error = error as NSError? {
                        completion(.failure(error))
                    }

                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let data else {
                    let error = NSError(domain: "NetworkError",
                                        code: (response as? HTTPURLResponse)?.statusCode ?? 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Invalid response or data."])
                    completion(.failure(error))
                    
                    return
                }
                
                completion(.success(data))
            }
        }
        
        dataTask.resume()
    }
    
    static func saveItem(using viewContext: NSManagedObjectContext,
                         repo: [String : Any]) -> String? {
        guard let projectID = repo["id"] as? Int,
           let projectName = repo["full_name"] as? String,
           let projectLanguage = repo["language"] as? String,
           let projectStars = repo["stargazers_count"] as? Int,
              let projectForks = repo["forks"] as? Int else {
            return nil
        }
        
        let item = Item(context: viewContext)
        item.id = UUID()
        item.projectID = Int32(projectID)
        item.projectName = projectName
        item.projectLanguage = projectLanguage
        item.stars = Int32(projectStars)
        item.forks = Int32(projectForks)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        if let timestamp = calendar.date(from: components) {
            item.timestamp = timestamp
        }
        
        do {
            try viewContext.performAndWait {
                try viewContext.save()
                viewContext.refreshAllObjects()
            }
            
            return nil
        } catch {
            return error.localizedDescription
        }
    }
}
