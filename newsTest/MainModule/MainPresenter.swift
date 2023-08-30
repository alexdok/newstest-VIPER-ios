//
//  MainPresenter.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

protocol MainPresenterProtocol: AnyObject {
}

class MainPresenter {
    weak var view: MainViewProtocol?
    var router: MainRouterProtocol
    var interactor: MainInteractorProtocol

    init(interactor: MainInteractorProtocol, router: MainRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension MainPresenter: MainPresenterProtocol {
}
