//
//  NetworkClient.swift
//  newsTest
//
//  Created by алексей ганзицкий on 24.10.2023.
//

import Foundation

enum NetworkError: Error {
    case badResponse(data: Data, statusCode: Int)
    case error(Error)
    case unknown
}

typealias NetworkResult = Result<Data, NetworkError>

protocol NetworkClient {
    func load(from request: URLRequest, completion: @escaping (NetworkResult) -> Void)
}

final class NetworkClientImpl: NetworkClient {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    struct UnknownNetworkError: Error { }

    func load(from request: URLRequest, completion: @escaping (NetworkResult) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.process(
                    data: data,
                    response: response as? HTTPURLResponse,
                    error: error,
                    with: completion
                )
            }
        }
        task.resume()
    }

    private func process(data: Data?, response: HTTPURLResponse?, error: Error?, with completion: @escaping (NetworkResult) -> Void) {
        guard let data = data, let response = response else {
            if let error = error {
                completion(.failure(.error(error)))
            } else {
                completion(.failure(.unknown))
            }

            return
        }

        if response.statusCode == 200 {
            completion(.success(data))
        } else {
            completion(.failure(.badResponse(data: data, statusCode: response.statusCode)))
        }
    }
}

