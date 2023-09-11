//
//  AlertBuilder.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//
import UIKit

struct AlertModel {
    var title: String
    var message: String
}

protocol AlertBuilder {
    func createAlert(with model: AlertModel) -> UIAlertController
}

final class AlertBuilderImpl: AlertBuilder {
    func createAlert(with model: AlertModel) -> UIAlertController {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)

        alert.addAction(ok)

        return alert
    }
}
