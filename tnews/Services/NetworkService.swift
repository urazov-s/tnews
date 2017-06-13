//
//  NetworkService.swift
//  tnews
//
//  Created by Sergey Urazov on 11/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation

protocol NetworkService {
    
    func handleFailure<T>(code: Int, message: String, completion: (T?, ServiceError?)->())
    func handleSuccess<T>(completion:(T?, ServiceError?)->(), body: () throws ->(T))
    
}

extension NetworkService {
    
    func handleFailure<T>(code: Int, message: String, completion: (T?, ServiceError?)->()) {
        switch code {
        case let x where x < 0:
            completion(nil, .network(message: message))
        case 0:
            completion(nil, .undefined)
        default:
            completion(nil, .serviceSpecific(message: message))
        }
    }
    
    func handleSuccess<T>(completion:(T?, ServiceError?)->(), body: () throws ->(T)) {
        do {
            let result = try body()
            completion(result, nil)
        } catch CastingError.invalidCasting {
            completion(nil, .unexpectedResponse)
        } catch {
            completion(nil, .undefined)
        }
    }
    
}


