//
//  Endpoints.swift
//  newsTest
//
//  Created by алексей ганзицкий on 24.10.2023.
//


import Foundation

protocol Endpoint {
    var baseURLResolver: BaseURLResolver { get }
    var path: String { get }
    var method: Method { get }
    var urlParameters: [String: String] { get }
}

extension Endpoint {
    var urlParameters: [String: String] { [:] }

    var request: URLRequest {
        let baseURL = baseURLResolver.resolve()
        guard
            let url = URL(string: path, relativeTo: baseURL),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            fatalError("Unable to create URL from \(path) and \(baseURL)")
        }

        let queryItems = urlParameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = queryItems

        guard let urlWithQuery = urlComponents.url else {
            fatalError("Unable to create URL from \(path), \(baseURL) and \(urlComponents)")
        }

        var request = URLRequest(url: urlWithQuery)
        request.httpMethod = method.rawValue
        return request
    }
}
