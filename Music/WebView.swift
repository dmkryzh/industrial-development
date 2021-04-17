//
//  WebView.swift
//  Navigation
//
//  Created by Dmitrii KRY on 16.04.2021.
//

import UIKit
import WebKit
class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    var someUrl: URL?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = someUrl else { return }
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
    
}
