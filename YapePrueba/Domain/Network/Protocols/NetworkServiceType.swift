//
//  NetworkServiceType.swift
//  YapePrueba
//
//  Created by iMac on 16/07/24.
//

import Foundation
import Combine

protocol NetworkServiceType {
    func setBaseUrl(_ baseUrl: String)
        
    func request<Response>(
        _ endpoint: NetworkRequest<Response>,
        queue: DispatchQueue) -> AnyPublisher<Response, Error> where Response: Decodable
}
