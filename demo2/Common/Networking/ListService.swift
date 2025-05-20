//
//  ListService.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//

import Foundation

enum DataError: Error {
    case badURL, decodingFailed
}

class ListService {
    
    static func apiCall<T: Decodable>(completion: @escaping(Result<[T], DataError>) -> Void) async {
        guard let url = URL(string: StringConstants.apiUrl) else {
            completion(.failure(.badURL))
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            let decodedData = try JSONDecoder().decode([T].self, from: data)
            completion(.success(decodedData))
            return
        } catch {
            completion(.failure(.decodingFailed))
            return
        }
    }
    
}
