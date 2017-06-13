//
//  GetNewsContentRequest.swift
//  tnews
//
//  Created by Sergey Urazov on 12/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation

final class GetNewsContentRequest: NetworkRequest {
    
    let newsID: Int64
    
    init(id: Int64) {
        newsID = id
    }
    
    override func prepareParams() -> [URLQueryItem]? {
        return [
            URLQueryItem(name: "id", value: "\(newsID)")
        ]
    }
    
    override class var endpoint: String {
        return "news_content"
    }
    
}
