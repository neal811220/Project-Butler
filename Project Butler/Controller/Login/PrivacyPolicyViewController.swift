//
//  PrivacyPolicyViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/3/11.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let privacyPolicyUrl = URL(string: "https://github.com/neal811220/Privacy-Policy") else {
            return
        }
        
        webView.navigationDelegate = self
        
        webView.load(URLRequest(url: privacyPolicyUrl))
    }
}
