//
//  NetworkService.swift
//  Navigation
//
//  Created by Dmitrii KRY on 05.05.2021.
//

import Foundation

enum AppConfiguration {
    case optionOne(URL)
    case optionTwo(URL)
    case optionThree(URL)
    
    func returnUrl() -> URL {
        switch self {
        case .optionOne(let url):
            return url
        case .optionTwo(let url):
            return url
        case .optionThree(let url):
            return url
        }
    }
    
    
}

struct NetworkService {
    
    static var appConf: URL?
    
    private static let sharedSession = URLSession.shared
    
    private static var someSession: URLSession {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        return URLSession(configuration: config)
    }
    
    private static var defaultSession: URLSession {
        return URLSession(configuration: .default, delegate: SessionDelegate(), delegateQueue: OperationQueue.main)
    }
    
    static func dataTask( url: URL,
                          completionData: @escaping (Data?) -> Void,
                          completionResponse: @escaping ([String:Any]?, Int) -> Void,
                          completionError: @escaping (String?) -> Void) {

        let task = sharedSession.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completionError(error.debugDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return }
            completionResponse(httpResponse.allHeaderFields as? [String:Any], httpResponse.statusCode)
            
            if let data = data {
                completionData(data)
            }
            
        }
        task.resume()
    }
    
    
    static func toObject(json: Data) throws -> Dictionary<String, Any>? {
        return try JSONSerialization.jsonObject(
            with: json,
            options: .mutableContainers
        ) as? [String: Any]
    }
    
    static func toData(dictionary: Dictionary<String, Any>) throws -> Data {
        return try JSONSerialization.data(
            withJSONObject: dictionary,
            options: .fragmentsAllowed
        )
    }
    
    
}




class SessionDelegate: NSObject, URLSessionDelegate {
}
