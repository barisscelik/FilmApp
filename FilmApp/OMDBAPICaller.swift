//
//  OMDBAPICaller.swift
//  FilmApp
//
//  Created by barış çelik on 16.04.2022.
//

import UIKit

enum FilmError: Error {
    case notFound
}

final class OMDBAPICalller {
    
    static let shared = OMDBAPICalller()
    
    private init () {}
    
    private static let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
    
    private let baseUrl = "https://www.omdbapi.com/?apikey=" + apiKey
    
    func fetchFilms(key name: String, completion: @escaping (Result<[FilmModel], Error>) -> Void) {
        var filmModels = [FilmModel]()
        
        let group = DispatchGroup()
        let urlWithName = baseUrl + "&t=" + name
        
        for year in 1970..<2023 {
            let reqUrl = urlWithName + "&y=\(String(year))" + "&plot=full"
            
            if let url = URL(string: reqUrl) {
                let task = URLSession.shared.dataTask(with: url) { data, _, error in
                    group.enter()
                    if let data = data, error == nil {
                        do {
                            let model = try JSONDecoder().decode(FilmModel.self, from: data)
                            filmModels.append(model)
                            group.leave()
                        } catch {
                            group.leave()
                        }
                    }
                }
                task.resume()
            }
        }
        
        group.notify(queue: .main) {
            if filmModels.count > 0 {
                completion(.success(filmModels))
            } else {
                completion(.failure(FilmError.notFound))
            }
        }
    }
    
    func getImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: data))
        }
        
        task.resume()
    }
}
