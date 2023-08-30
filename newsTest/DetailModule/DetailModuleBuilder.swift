//
//  DetailModuleBuilder.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

class DetailModuleBuilder {
    static func build() -> DetailViewController {
        let interactor = DetailInteractor()
        let router = DetailRouter()
        let presenter = DetailPresenter(interactor: interactor, router: router)
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
