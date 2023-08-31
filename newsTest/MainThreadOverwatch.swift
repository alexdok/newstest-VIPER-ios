//
//  MainOwervatch.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//
import Foundation

public func onMain(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}
