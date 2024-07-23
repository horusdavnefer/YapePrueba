//
//  Request.swift
//  YapePrueba
//
//  Created by iMac on 16/07/24.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum NetworkError: Error, Equatable {
    case badURL(_ error: String)
    case apiError(code: Int, error: String)
    case invalidJSON(_ error: String)
    case unauthorized(code: Int, error: String)
    case badRequest(code: Int, error: String)
    case noResponse(_ error: String)
    case unableToParseData(_ error: String)
    case unknown(code: Int, error: String)
    case invalidUrl
    case serverError
    case emptyJson
}

class NetworkRequest<Response> {
    let method: HTTPMethod
    let relativePath: String
    let headers: [String: String]?
    let parameters: [String: Any]?
    let decode: (Data) throws -> Response

    init(method: HTTPMethod = .GET,
         relativePath: String,
         headers: [String: String]? = nil,
         parameters: [String: Any]?,
         decode: @escaping (Data) throws -> Response) {
        self.method = method
        self.relativePath = relativePath
        self.headers = headers
        self.parameters = parameters
        self.decode = decode
    }
}

extension NetworkRequest where Response: Decodable {
    convenience init(method: HTTPMethod = .GET,
                     relativePath: String,
                     headers: [String: String]? = nil,
                     parameters: [String: Any]? = nil) {
        self.init(
            method: method,
            relativePath: relativePath,
            headers: headers,
            parameters: parameters) {
                let decoder = JSONDecoder()
                return try decoder.decode(Response.self, from: $0)
            }
    }
}

