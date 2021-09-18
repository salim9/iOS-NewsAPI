//
//  NewsDetailVC.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 17.09.2021.
//

import UIKit
import Kingfisher

class NewsDetailVC: UIViewController {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var newsSource: UIButton!
    
    var article: Article! {
        didSet {
            viewModel.checkFavorite(title: article.title ?? "")
        }
    }
    var newsSourceURL: URL!
    var viewModel: NewsDetailsViewModelProtocol = NewsDetailsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
    }
    
    func setupUI() {
        newsSource.layer.borderColor = UIColor.gray.cgColor
        newsSource.layer.borderWidth = 1.0
        newsSource.layer.cornerRadius = 5
        newsSource.layer.masksToBounds = true
        titleLabel.text = article.title
        authorLabel.text = article.author
        dateLabel.text = Date.getFormattedDate(string: article?.publishedAt ?? "No Value", formatter: DateConstants.formatter)
        descriptionLabel.text = article.content
        newsSourceURL = article.url
        preparePosterImage(imageURL: article?.urlToImage ?? URL(fileURLWithPath: ""))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsToSource"{
            let destinationVC = segue.destination as! NewsSourceVC
            destinationVC.sourceURL = newsSourceURL
        }
    }
    
    func preparePosterImage(imageURL: URL) {
        posterImage.kf.setImage(with: imageURL) { result in
           switch result {
           case .success(let value):
               print("Image: \(value.image). Got from: \(value.cacheType)")
                break
           case .failure(let error):
               print("Error: \(error)")
           }
         }
    }

    @IBAction func shareTapped(_ sender: Any) {
        let text = "\(article.title ?? "") \n Author: \(article.author ?? "")  Source: \(article.source?.name ?? "") \n \(article.content ?? "") \n"
        let website = article.url
        let shareAll = [text, website ?? URL(fileURLWithPath: "")] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func favoriteTapped(_ sender: Any) {
        if (favoriteButton.currentImage == (UIImage(systemName: "heart.fill"))) {
            viewModel.remove(item: article)
        } else {
            if let article = article {
                viewModel.load(article: article)
            }
        }
    }
    @IBAction func newsSourceTapped(_ sender: Any) {
        performSegue(withIdentifier: "detailsToSource", sender: nil)
    }
}

extension NewsDetailVC: NewsDetailsViewModelDelegate {
    func fillFavorite(name: String) {
        favoriteButton.setImage(UIImage(systemName: name), for: .normal)
    }
    func reloadFavorite() {
        //favoriteButton.imageView?.image = UIImage(systemName: "heart.fill")
    }
}
