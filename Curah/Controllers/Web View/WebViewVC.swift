//
//  WebViewVC.swift
//  Curah Provider
//
//  Created by Netset on 25/10/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit

class WebViewVC: BaseClass,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var  url = String()
    var navTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarWithBackBtnAndTitle(title: navTitle)
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        let urlLink = URL (string: url)
        let request = URLRequest(url: urlLink!)
        self.webView.loadRequest(request)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        APIManager().showHud()
        print("WEB VIEW Start Loading...")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        APIManager().hideHud()
    }
    
}
