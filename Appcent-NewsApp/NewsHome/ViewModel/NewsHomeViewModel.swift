//
//  NewsHomeViewModel.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 17.09.2021.
//

import Foundation

protocol NewsHomeViewModelProtocol {
    var delegate: NewsHomeViewModelDelegate? { get set }
    func load(query: String, page: Int)
    func news(_ index: Int) -> Article?
    func numberOfItems() -> Int?
    func loadNewNews(query: String, page: Int)
}

protocol NewsHomeViewModelDelegate: AnyObject {
    func reloadNews()
    func prepareTableView()
    func displayAlert(title: String, message: String)
}

class NewsHomeViewModel {
    private var networkManager = NetworkManager()
    weak var delegate: NewsHomeViewModelDelegate?
    private var news: News?
    
    private func fetchNews(query: String, page: Int) {
        networkManager.fetchNews(query: query, page: page, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.news = response
                self?.delegate?.reloadNews()
                break
            case .failure(let error):
                self?.delegate?.displayAlert(title: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
                break
            }
        })
    }
    
    private func appendNewNews(query: String, page: Int) {
        networkManager.fetchNews(query: query, page: page, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.news?.articles.append(contentsOf: response.articles)
                self?.delegate?.reloadNews()
                break
            case .failure(let error):
                self?.delegate?.displayAlert(title: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
                break
            }
        })
    }
    
}

extension NewsHomeViewModel: NewsHomeViewModelProtocol {
    func numberOfItems() -> Int? {
        return news?.articles.count
    }
    
    func load(query: String, page: Int) {
        delegate?.prepareTableView()
        fetchNews(query: query, page: page)
    }
    
    func loadNewNews(query: String, page: Int) {
        delegate?.prepareTableView()
        appendNewNews(query: query, page: page)
    }
    
    func news(_ index: Int) -> Article? {
        return news?.articles[index]
    }
}
