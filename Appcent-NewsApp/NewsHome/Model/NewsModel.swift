//
//  NewsModel.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 17.09.2021.
//

import Foundation

// MARK: - News
struct News: Codable {
    let status: String?
    let totalResults: Int?
    var articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title, description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title, description
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
