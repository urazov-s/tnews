//
//  NewsListViewController.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import UIKit

class NewsListViewController: UIViewController {
    
    private let errorHandler = ErrorHandler()
    private let newsService = NewsService()
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var news: [NewsTitle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handlePTR), for: .valueChanged)
        tableView.refreshControl = refresh
    }
    
    private lazy var firstAppearActions: (()->())? = { [unowned self] in
        self.requestNewsFromCache()
        self.requestNewsFromNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        firstAppearActions?()
        firstAppearActions = nil
    }
    
    // MARK:- Actions
    
    func handlePTR() {
        requestNewsFromNetwork()
    }
    
    // MARK:- Get News
    
    func requestNewsFromNetwork() {
        newsService.requestNews { [weak self] (news, error) in
            guard let sself = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                sself.tableView.refreshControl?.endRefreshing()
            })
            if let error = error {
                let alert = sself.errorHandler.prepareAlertForError(error: error)
                DispatchQueue.main.async {
                    sself.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            guard let news = news else {
                return
            }
            
            sself.news = news
            DispatchQueue.main.async {
                sself.tableView.reloadData()
            }
        }

    }
    
    func requestNewsFromCache() {
        news = newsService.obtainNews()
        tableView.reloadData()
    }
}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    private var cellIdentifier: String {
        return "cell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
            return UITableViewCell()
        }
        
        let model = news[indexPath.row]
        
        cell.textLabel?.attributedText = model.text.asHTMLText()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = news[indexPath.row]
        
        let dst = NewsViewController(newsID: model.id)
        show(dst, sender: self)
    }
    
}
