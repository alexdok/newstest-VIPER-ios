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
        let key = "bd4291cebed94b898dd76406d634bac2"
        request.httpBody = Data(key.utf8)
        return request
    }
}

