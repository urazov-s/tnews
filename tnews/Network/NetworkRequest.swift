//
//  NetworkRequest.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation

class NetworkRequest {
    
    enum Result {
        case success([String: Any])
        case failure(statusCode: Int, message: String)
    }
    
    // MARK:- API
    
    private static let host = "api.tinkoff.ru"
    private static let version = "v1"
    class var endpoint: String {
        return ""
    }
    private var fullURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = type(of: self).host
        components.path = "/\(type(of: self).version)/\(type(of: self).endpoint)"
        components.queryItems = prepareParams()
        return components.url!
    }
    func prepareParams() -> [URLQueryItem]? {
        return nil
    }
    
    // MARK:- Session
    
    private var task: URLSessionTask?
    
    private static var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 30.0
        let session = URLSession(configuration: config)
        return session
    }()
    
    private var session: URLSession {
        return NetworkRequest.session
    }
    
    // MARK:- Logic
    
    func perform(completion: @escaping (Result)->()) {
        cancel()
    
        let request = URLRequest(url: fullURL)
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            var result: Result
            if let error = error {
                result = .failure(statusCode: error._code, message: error.localizedDescription)
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                let json = try? JSONSerialization.jsonObject(with: data),
                let dict = json as? [String: Any] {
                if 200..<300 ~= response.statusCode {
                    result = .success(dict)
                } else {
                    result = .failure(statusCode: response.statusCode, message: dict["resultCode"] as! String)
                }
            } else {
                result = .failure(statusCode: 0, message: "Strange response")
            }
            completion(result)
        })
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
}
