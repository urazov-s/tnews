//
//  Casting.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation

enum CastingError: Error {
    case invalidCasting
}

func cast<T>(_ obj: Any?) throws -> T! {
    if let obj = obj as? T {
        return obj
    } else {
        throw CastingError.invalidCasting
    }
}

func cast<T>(_ obj: Any?, defaultResult: T) -> T! {
    if let obj = obj as? T {
        return obj
    } else {
        return defaultResult
    }
}
