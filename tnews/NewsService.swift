//
//  NewsService.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import CoreData

final class NewsService: NetworkService, CoreDataService {
    
    private var curGetListRequest: GetNewsRequest?
    private var curGetContentRequest: GetNewsContentRequest?
    
    private lazy var titleMapper = NewsTitleMapper()
    private lazy var contentMapper = NewsMapper()
    
    // MARK:- List
    
    func requestNews(completion: @escaping ([NewsTitle]?, ServiceError?)->()) {
        curGetListRequest?.cancel()
        
        let request = GetNewsRequest()
        curGetListRequest = request
        request.perform { [weak self] result in
            guard let sself = self else { return }
            sself.curGetListRequest = nil
            switch result {
            case .success(let dict):
                sself.handleSuccess(completion: completion) {
                    var news: [NewsTitle] = []
                    let payload: [[String: Any]] = try cast(dict["payload"])
                    
                    for dict in payload {
                        news.append(try sself.titleMapper.map(dictionary: dict))
                    }
                    
                    let context = sself.context
                    sself.usingContext(context: context, withCompletion: completion, do: {
                        for dict in payload {
                            try sself.titleMapper.parse(dictionary: dict, inContext: context)
                        }
                        try context.save()
                    })
                    return news
                }
            case .failure(let statusCode, let message):
                sself.handleFailure(code: statusCode, message: message, completion: completion)
            }
        }
    }
    
    func obtainNews() -> [NewsTitle] {
        var news: [NewsTitle] = []
        let context = self.context
        context.performAndWait {
            let request: NSFetchRequest<MNewsTitle> = MNewsTitle.fetchRequest()
            let key = #selector(getter: MNewsTitle.publicationDate).description
            request.sortDescriptors = [
                NSSortDescriptor(key: key, ascending: false)
            ]
            if let mnews = try? request.execute() {
                news = mnews.map({ self.titleMapper.map(managedObject: $0) })
            }
        }
        return news
    }
    
    // MARK:- Single
    
    func requestNews(withID id: Int64, completion: @escaping ((News?, ServiceError?)->())) {
        curGetContentRequest?.cancel()
        
        let request = GetNewsContentRequest(id: id)
        curGetContentRequest = request
        
        request.perform { [weak self] result in
            guard let sself = self else { return }
            sself.curGetContentRequest = nil
            switch result {
            case .success(let dict):
                sself.handleSuccess(completion: completion, body: { () -> (News) in
                    let payload: [String: Any] = try cast(dict["payload"])
                    
                    let context = sself.context
                    sself.usingContext(context: context, withCompletion: completion, do: {
                        try sself.contentMapper.parse(dictionary: payload, inContext: context)
                        try context.save()
                    })
                    
                    return try sself.contentMapper.map(dictionary: payload)
                })
            case .failure(let statusCode, let message):
                sself.handleFailure(code: statusCode, message: message, completion: completion)
            }
        }
    }
    
    func obtainNewsContent(id: Int64) -> News? {
        var news: News?
        let context = self.context
        context.performAndWait {
            if let request: NSFetchRequest<MNews> = MNews.pkRequest(withValue: id) {
                if let result = try? request.execute(),
                    let existing = result.first {
                    news = self.contentMapper.map(managedObject: existing)
                }
            }
        }
        return news
    }
    
}
