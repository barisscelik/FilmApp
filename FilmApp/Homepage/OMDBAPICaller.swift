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
    
    func fetchFilms(key name: String, year: String, completion: @escaping (Result<FilmModel, Error>) -> Void) {
        
        let reqUrl = baseUrl + "&t=" + name + "&y=\(year)" + "&plot=full"

        if let url = URL(string: reqUrl) {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, error == nil {
                    do {
                        let model = try JSONDecoder().decode(FilmModel.self, from: data)
                        completion(.success(model))
                    } catch {
                        completion(.failure(FilmError.notFound))
                    }
                }
            }
            task.resume()
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
