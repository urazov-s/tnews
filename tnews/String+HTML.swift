//
//  String+HTML.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func asHTMLText() -> NSAttributedString {
        guard let textData = self.data(using: .unicode) else {
            return NSAttributedString(string: self)
        }
        do {
            let attrText = try NSMutableAttributedString(data: textData, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            attrText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)], range: NSMakeRange(0, attrText.length))
            
            return attrText
        } catch {
            return NSAttributedString(string: self)
        }
    }
    
}
