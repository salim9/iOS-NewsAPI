//
//  NewsSourceVC.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 17.09.2021.
//

import UIKit
import WebKit

class NewsSourceVC: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var sourceURL: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        stopLoading()
        webView.load(URLRequest(url: sourceURL))
    }

}
