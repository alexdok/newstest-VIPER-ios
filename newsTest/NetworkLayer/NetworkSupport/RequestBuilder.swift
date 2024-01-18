//
//  RequestBuilder.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//

import Foundation

protocol RequestBuilder {
    func createRequestFrom(url: String, params: [String: String], httpMethod: String) -> URLRequest?
}

final class RequestBuilderImpl: RequestBuilder {
    func createRequestFrom(url: String, params: [String: String], httpMethod: String) -> URLRequest? {

        guard var url = URL(string: url) else { return nil }
        url = url.appendingQueryParameters(params)
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
        request.httpMethod = httpMethod
        return request
    }
}

