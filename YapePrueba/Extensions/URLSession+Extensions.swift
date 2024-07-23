//
//  URLSession+Extensions.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import Foundation


extension URLSession {
    static func configuration(timeOut: Int = 60,
                              requestCachePolicy: URLRequest.CachePolicy = .reloadRevalidatingCacheData) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = requestCachePolicy
        configuration.timeoutIntervalForRequest = TimeInterval(timeOut)
        return configuration
    }
}
