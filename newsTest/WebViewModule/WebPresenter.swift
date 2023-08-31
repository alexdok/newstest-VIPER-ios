//
//  WebPresenter.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 31.08.2023
//

protocol WebPresenterProtocol: AnyObject {
}

class WebPresenter {
    weak var view: WebViewProtocol?
    var router: WebRouterProtocol
    var interactor: WebInteractorProtocol

    init(interactor: WebInteractorProtocol, router: WebRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension WebPresenter: WebPresenterProtocol {
}
