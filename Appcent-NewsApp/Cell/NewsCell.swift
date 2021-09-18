//
//  NewsCell.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 17.09.2021.
//

import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    func configure(image: URL, title: String, description: String, date: String, source: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        sourceLabel.text = source
        dateLabel.text = Date.getFormattedDate(string: date, formatter: DateConstants.formatter)
        preparePosterImage(imageURL: image)
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
    
}

