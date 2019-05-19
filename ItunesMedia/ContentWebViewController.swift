//
//  ContentWebViewController.swift
//  ItunesMedia
//
//  Created by Leonardo Reis on 19/05/19.
//  Copyright © 2019 Leonardo Reis. All rights reserved.
//

import UIKit
import WebKit

class ContentWebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = true
//        webView.navigationDelegate = self
        
        let url = URL(string: urlString)
        webView.load(URLRequest(url: url!))
        webView.scrollView.backgroundColor = UIColor.clear
        webView.allowsBackForwardNavigationGestures = true
    }
}
