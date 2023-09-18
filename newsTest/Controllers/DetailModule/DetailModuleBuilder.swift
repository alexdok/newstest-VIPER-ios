//
//  DetailModuleBuilder.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

final class DetailModuleBuilder {
    static func build(image: UIImage, news: ObjectNewsData) -> DetailViewController {
        let interactor = DetailInteractor(image: image, news: news)
        let router = DetailRouter()
        let presenter = DetailPresenter(interactor: interactor, router: router)
        let viewController =  DetailViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
