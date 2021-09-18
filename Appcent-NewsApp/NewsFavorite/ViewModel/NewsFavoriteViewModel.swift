//
//  NewsFavoriteViewModel.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 18.09.2021.
//

import Foundation
import FirebaseDatabase

protocol NewsFavoriteViewModelProtocol {
    var delegate: NewsFavoriteViewModelDelegate? { get set }
    func load()
    func numberOfItems() -> Int
    func article(_ index: Int) -> Article?
}

protocol NewsFavoriteViewModelDelegate: AnyObject {
    func reloadFavorite()
    func prepareTableView()
    func displayAlert(title: String, message: String)
}

class NewsFavoriteViewModel {
    var delegate: NewsFavoriteViewModelDelegate?
    private var ref : DatabaseReference!
    private var articles = [Article]()
    private func fetchFavorite() {
        let ref2 = Database.database(url: "https://appcent-newsapp-b7bec-default-rtdb.europe-west1.firebasedatabase.app")
        ref = ref2.reference(withPath: "article")
        ref.observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.articles.removeAll()
                for articles in snapshot.children.allObjects as! [DataSnapshot] {
                    if let articleObject = articles.value as? [String:Any],
                        let title = articleObject["title"] as? String,
                        let date = articleObject["date"] as? String,
                        let source = articleObject["source"] as? String,
                        let author = articleObject["author"] as? String,
                        let sourceURL = articleObject["sourceURL"] as? String,
                        let content = articleObject["content"] as? String,
                        let imageURL = articleObject["imageURL"] as? String,
                        let description = articleObject["description"] as? String {
                        let article = Article(source: Source(id: "", name: source), author: author, title: title, description: description, url: URL(string: sourceURL), urlToImage: URL(string: imageURL), publishedAt: date, content: content)
                        self.articles.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.delegate?.reloadFavorite()
                }
            } else {
                self.delegate?.displayAlert(title: "Error", message: "Could not found any Favorited Article")
            }
        }
    }
}

extension NewsFavoriteViewModel: NewsFavoriteViewModelProtocol {
    func load() {
        delegate?.prepareTableView()
        fetchFavorite()
    }
    
    func numberOfItems() -> Int {
        return articles.count
    }
    
    func article(_ index: Int) -> Article? {
        return articles[index]
    }
}
