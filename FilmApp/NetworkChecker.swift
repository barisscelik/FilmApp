//
//  NetworkChecker.swift
//  FilmApp
//
//  Created by barış çelik on 15.04.2022.
//

import Foundation
import Network

final class NetworkChecker {
    
    static let shared = NetworkChecker()
    
    private let queue = DispatchQueue.global()
    
    private let monitor: NWPathMonitor
    
    private init() {
        monitor = NWPathMonitor()
        
    }
    
    public func getConnetctionStatus(completion: @escaping (Bool) -> Void) {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            completion(path.status == .satisfied)
            self?.monitor.cancel()
        }
    }
    
    
}
