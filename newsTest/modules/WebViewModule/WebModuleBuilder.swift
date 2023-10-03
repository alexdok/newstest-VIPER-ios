//
//  WebModuleBuilder.swift
//  newsTest
//
//  Created by алексей ганзицкий on 31.08.2023
//

import UIKit

final class WebModuleBuilder {
    static func build(url: String, title: String) -> WebViewController {
        let interactor = WebInteractor(titleNews: title, urlNews: url)
        let presenter = WebPresenter(interactor: interactor)
        let viewController = WebViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        return viewController
    }
}
