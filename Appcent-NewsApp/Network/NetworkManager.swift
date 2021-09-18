//
//  NetworkManager.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 17.09.2021.
//

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<API> { get }

    func fetchNews(query: String, page: Int, completion: @escaping (Swift.Result<News, Error>) -> ())
}

class NetworkManager: Networkable {
    var provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    func fetchNews(query: String, page: Int, completion: @escaping (Swift.Result<News, Error>) -> ()) {
        request(target: API.search(query: query, page: page), completion: completion)
    }
}

private extension NetworkManager {
    private func request<T: Decodable>(target: API, completion: @escaping (Swift.Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    print(String(describing: error))
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
