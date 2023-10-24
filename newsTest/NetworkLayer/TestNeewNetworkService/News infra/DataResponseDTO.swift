//
//  DataResponseDTO.swift
//  newsTest
//
//  Created by алексей ганзицкий on 24.10.2023.
//

import Foundation
struct DataResponseDTO<T: Decodable>: Decodable {
    var data: T
}
