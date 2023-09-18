//
//  MainModuleBuilder.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

final class MainModuleBuilder {
    
    static func build() -> MainViewController {
        let interactor = MainInteractor(network: NetworkManagerImpl(mapper: MapNewsToObjectImpl(), requestBilder: RequestBuilderImpl()))
        let router = MainRouter()
        let presenter = MainPresenter(interactor: interactor, router: router)
        let viewController = MainViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
