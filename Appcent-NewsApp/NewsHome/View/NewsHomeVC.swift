//
//  NewsHomeVC.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 17.09.2021.
//

import UIKit

class NewsHomeVC: UIViewController {
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var newsTableView: UITableView!
    var viewModel: NewsHomeViewModelProtocol = NewsHomeViewModel()
    var selectedArticle: Article?
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        newsTableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToDetailsVC"{
            let destinationVC = segue.destination as! NewsDetailVC
            destinationVC.article = selectedArticle
        }
    }
}

extension NewsHomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            startLoading()
            viewModel.load(query: query, page: 1)
        }
    }
}

extension NewsHomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: CellConstants.reuseIdentifier, for: indexPath as IndexPath) as? NewsCell else { return UITableViewCell() }
        if let news = viewModel.news(indexPath.item) {
            let posterImage = news.urlToImage
            cell.configure(image: (posterImage ?? URL(string: "https://nebosan.com.tr/wp-content/uploads/2018/06/no-image.jpg"))!, title: news.title ?? "No Title", description: news.description ?? "No Description", date: news.publishedAt ?? "No Date", source: news.source?.name ?? "No Source")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == viewModel.numberOfItems()) {
            startLoading()
            page = page + 1
            viewModel.loadNewNews(query: searchBar.text ?? "", page: page)
        }
        stopLoading()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedArticle = viewModel.news(indexPath.item) 
            performSegue(withIdentifier: "homeToDetailsVC", sender: nil)
    }
    
}

extension NewsHomeVC: NewsHomeViewModelDelegate {
    func displayAlert(title: String, message: String) {
        showAlert(title: title, message: message)
        stopLoading()
        infoView.isHidden = false
    }
    
    func prepareTableView() {
        stopLoading()
        infoView.isHidden = true
        newsTableView.register(UINib(nibName: String(describing: NewsCell.self), bundle: nil), forCellReuseIdentifier: CellConstants.reuseIdentifier)
        newsTableView.delegate = self
        newsTableView.dataSource = self
    }
    
    func reloadNews() {
        infoView.isHidden = true
        newsTableView.reloadData()
        newsTableView.isHidden = false
    }
}
