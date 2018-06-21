//
//  taskManager.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 30.05.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation

class TaskManager {
    static let shared = TaskManager()
    
    let session = URLSession(configuration: .default)
    
    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void
    
    var tasks = [URL: [completionHandler]]()
    
    func dataTask(with url: URL, completion: @escaping completionHandler) {
        if tasks.keys.contains(url) {
            tasks[url]?.append(completion)
        } else {
            tasks[url] = [completion]
            let _ = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    
                    print("Finished network task")
                    
                    guard let completionHandlers = self?.tasks[url] else { return }
                    for handler in completionHandlers {
                        
                        print("Executing completion block")
                        
                        handler(data, response, error)
                    }
                }
            }).resume()
        }
    }
}
