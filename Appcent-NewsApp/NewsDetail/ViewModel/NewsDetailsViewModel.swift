//
//  NewsDetailsViewModel.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 17.09.2021.
//

import Foundation
import FirebaseDatabase

protocol NewsDetailsViewModelProtocol {
    var delegate: NewsDetailsViewModelDelegate? { get set }
    func load(article: Article)
    func isFavorite(title: String)
    func checkFavorite(title: String)
    func remove(item: Article)
}

protocol NewsDetailsViewModelDelegate: AnyObject {
    func fillFavorite(name: String)
    func reloadFavorite()
}

class NewsDetailsViewModel {
    weak var delegate: NewsDetailsViewModelDelegate?
    private var ref : DatabaseReference!
    var articles = [Article]()
    
    private func saveFavorite(article: Article) {
        let ref = Database.database(url: "https://appcent-newsapp-b7bec-default-rtdb.europe-west1.firebasedatabase.app")
        let noValue = "No Value"
        let reference = ref.reference(withPath: "article")
        if let imagePath = article.urlToImage {
            reference.child(article.title ?? "No Title").setValue(["title" : article.title, "description" : article.description ?? " ", "date" : article.publishedAt ?? noValue, "author" : article.author ?? " ", "sourceURL" : article.url?.absoluteString, "source" : article.source?.name, "content": article.content ?? " ", "imageURL": String(describing: imagePath)])
        }
    }
    
    func fetchFavorite(searchedTitle: String) {
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
            }
            self.isFavorite(title: searchedTitle)
        }
    }
    
    func removeItem(item: Article){
        let ref2 = Database.database(url: "https://appcent-newsapp-b7bec-default-rtdb.europe-west1.firebasedatabase.app")
        ref = ref2.reference(withPath: "article")
        ref.child(item.title ?? "").removeValue()
        delegate?.fillFavorite(name: "heart")
    }

}

extension NewsDetailsViewModel: NewsDetailsViewModelProtocol {
    func isFavorite(title: String) {
        for i in 0..<articles.count {
            if articles[i].title == title {
                self.delegate?.fillFavorite(name: "heart.fill")
                break
            } else {
                self.delegate?.fillFavorite(name: "heart")
            }
        }
    }
    
    func load(article: Article) {
        saveFavorite(article: article)
    }
    
    func checkFavorite(title: String){
        fetchFavorite(searchedTitle: title)
    }
    
    func remove(item: Article) {
        removeItem(item: item)
    }

}
