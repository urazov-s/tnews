//
//  GetNewsRequest.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation

final class GetNewsRequest: NetworkRequest {
    
    override class var endpoint: String {
        return "news"
    }
    
}
