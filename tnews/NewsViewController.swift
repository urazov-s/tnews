//
//  NewsViewController.swift
//  tnews
//
//  Created by Sergey Urazov on 11/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    private let errorHandler = ErrorHandler()
    private let newsService = NewsService()
    
    let newsID: Int64
    
    init(newsID: Int64) {
        self.newsID = newsID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cached = newsService.obtainNewsContent(id: newsID) {
            displayHTML(content: cached.content ?? "")
        }
        
        newsService.requestNews(withID: newsID) { [weak self] (news, error) in
            guard let sself = self else { return }
            
            if let error = error {
                let alert = sself.errorHandler.prepareAlertForError(error: error)
                DispatchQueue.main.async {
                    sself.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                sself.displayHTML(content: news?.content ?? "")
            }
        }
    }
    
    // MARK:- Content
    
    private func displayHTML(content: String) {
        let fullContent = "<html><head><title></title></head><body style=\"background:transparent;\">" +
            content +
        "</body></html>"
        
        webView.loadHTMLString(fullContent, baseURL: nil)
    }
    
}
