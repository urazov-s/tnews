//
//  ErrorHandler.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandler {
    
    func prepareAlertForError(error: ServiceError) -> UIAlertController {
        let title: String
        let text: String
        
        switch error {
        case .network(let message):
            title = "Network Error"
            text = message
        case .serviceSpecific(let message):
            title = "Server Error"
            text = message
        case .undefined:
            title = "Undefined Error"
            text = "Something went wrong"
        case .unexpectedResponse:
            title = "Unexpected Response"
            text = "Server has returned unexpected data"
        }
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
}
