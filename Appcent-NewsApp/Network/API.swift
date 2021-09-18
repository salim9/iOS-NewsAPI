//
//  API.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 17.09.2021.
//

import Foundation
import Moya


enum API {
    case search(query: String, page: Int)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "\(newsAPI.baseURL)apiKey=\(newsAPI.APIKey)")!
    }
    var path: String {
        switch self {
        case .search:
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .search(query: let query, page: let page):
            return .requestParameters(parameters: ["q": query, "page": page], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
