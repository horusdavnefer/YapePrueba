//
//  NetworkService.swift
//  YapePrueba
//
//  Created by iMac on 16/07/24.
//

import Combine
import Foundation

public class NetworkService {
    var baseURL: URL?
    var urlSession: URLSession
    
   
    init(url: String,
         urlSession: URLSession) {
        self.baseURL = URL(string: url)
        self.urlSession = urlSession
    }
    
    private func getRequestHeaders<Response>(_ request: NetworkRequest<Response>) -> [String: String] {
        var headers: [String: String] = [:]
        headers = [
            DataConstants.APIClient.contentType: DataConstants.InnerConstants.applicationJson,
            //DataConstants.APIClient.xApiKey: apiKey
        ]
        return headers
    }
    
    private func getBaseUrl(path: String, parameters: [String: Any] = [:]) -> URL? {
        guard let baseUrl = baseURL?.absoluteString.appending(path) else { return nil }
        
        var url = URL(string: baseUrl)
        var urlComponents = URLComponents(url: url!, resolvingAgainstBaseURL: true)!
        
        if !parameters.isEmpty {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0, value: String(describing: $1))
            }
        }
        return urlComponents.url
    }
    
    private func getUrlRequest<Response>(_ endPoint: NetworkRequest<Response>) -> URLRequest? {
        var url: URL?
        var httpBody: Data?
        if let parameters = endPoint.parameters {
            if endPoint.method != .GET {
                let body = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                httpBody = body
                url = getBaseUrl(path: endPoint.relativePath)
            } else {
                url = getBaseUrl(path: endPoint.relativePath, parameters: parameters)
            }
        } else {
            url = getBaseUrl(path: endPoint.relativePath)
        }
        guard let requestUrl: URL = url else { return nil }
        let headers = getRequestHeaders(endPoint)
        var request = URLRequest(url: requestUrl)
        request.httpBody = httpBody
        request.allHTTPHeaderFields = headers
        request.httpMethod = endPoint.method.rawValue
        return request
    }
}

extension NetworkService: NetworkServiceType {
    func setBaseUrl(_ baseUrl: String) {
        baseURL = URL(string: baseUrl)
    }
    
    func request<Response>(_ endpoint: NetworkRequest<Response>,
                           queue: DispatchQueue = .main) -> AnyPublisher<Response, Error> where Response: Decodable {
        guard let request = getUrlRequest(endpoint) else {
            return Fail<Response, Error>(error: NetworkError.invalidUrl)
                .eraseToAnyPublisher()
        }
        let decoder = JSONDecoder()
        
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.serverError
                }
                
                if !(200 ..< 300 ~= httpResponse.statusCode) {
                    throw NetworkError.apiError(
                        code: httpResponse.statusCode,
                        error: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    )
                }
                return data
            }
            .decode(type: Response.self, decoder: decoder)
            .receive(on: queue)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
