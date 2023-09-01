//
//  WebModuleBuilder.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 31.08.2023
//

import UIKit

class WebModuleBuilder {
    static func build(url: String, title: String) -> WebViewController {
        let interactor = WebInteractor(titleNews: title, urlNews: url)
        let router = WebRouter()
        let presenter = WebPresenter(interactor: interactor, router: router)
        let viewController = WebViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
