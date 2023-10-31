//
//  BaseUrlResolver.swift
//  newsTest
//
//  Created by алексей ганзицкий on 24.10.2023.
//

import Foundation

enum BaseURLResolver {
    case news

    func resolve() -> URL {
        let baseURLString: String

        switch self {
        case .news:
            baseURLString = "https://newsapi.org/v2/everything"
        }

        guard let baseURL = URL(string: baseURLString) else {
            fatalError("Unable to create URL from \(baseURLString)")
        }

        return baseURL
    }
}
