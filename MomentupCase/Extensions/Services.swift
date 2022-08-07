//
//  Services.swift
//  MomentupCase
//
//  Created by Hasan Onur Can on 8/6/22.
//


import Foundation
struct Service{
    let urlString: String
    
    func performRequest(completion: @escaping (Result<Welcome,ServiceError>) ->Void ){
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                      completion(.failure(.invalidResponseStatus))
                      return }
            guard error == nil else {
                completion(.failure(.dataTaskError))
                return }
            guard let data = data else {
                completion(.failure(.corruptData))
                return }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(Welcome.self, from: data)
                completion(.success(decodedData) )
            }catch {
                print("error")
            }
        }
        .resume()
    }
    
}

enum ServiceError: Error{
    case invalidURL
    case invalidResponseStatus
    case dataTaskError
    case corruptData
    case decodingError
}

