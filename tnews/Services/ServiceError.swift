//
//  ServiceError.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation

enum ServiceError {
    case undefined
    case unexpectedResponse
    case serviceSpecific(message: String)
    case network(message: String)
    
}
