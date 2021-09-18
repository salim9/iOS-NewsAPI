//
//  NewsFavoriteVC.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 18.09.2021.
//

import UIKit

class NewsFavoriteVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: NewsFavoriteViewModelProtocol = NewsFavoriteViewModel()
    var selectedArticle: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.isHidden = true
        viewModel.load()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesToDetailsVC"{
            let destinationVC = segue.destination as! NewsDetailVC
            destinationVC.article = selectedArticle
        }
    }
}

extension NewsFavoriteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellConstants.reuseIdentifier, for: indexPath as IndexPath) as? NewsCell else { return UITableViewCell() }
        if let news = viewModel.article(indexPath.item) {
            let posterImage = news.urlToImage
            cell.configure(image: (posterImage ?? URL(string: "https://nebosan.com.tr/wp-content/uploads/2018/06/no-image.jpg"))!, title: news.title ?? "No Title", description: news.description ?? "No Description", date: news.publishedAt ?? "No Date", source: news.source?.name ?? "No Source")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticle = viewModel.article(indexPath.item)
            performSegue(withIdentifier: "favoritesToDetailsVC", sender: nil)
    }
}

extension NewsFavoriteVC: NewsFavoriteViewModelDelegate {
    func prepareTableView() {
        tableView.register(UINib(nibName: String(describing: NewsCell.self), bundle: nil), forCellReuseIdentifier: CellConstants.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        startLoading()
    }
    
    func reloadFavorite() {
        tableView.isHidden = false
        tableView.reloadData()
        stopLoading()
    }
    
    func displayAlert(title: String, message: String) {
        stopLoading()
        showAlert(title: title, message: message)
    }
}
