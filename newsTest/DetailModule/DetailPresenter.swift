//
//  DetailPresenter.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

protocol DetailPresenterProtocol: AnyObject {
}

class DetailPresenter {
    weak var view: DetailViewProtocol?
    var router: DetailRouterProtocol
    var interactor: DetailInteractorProtocol

    init(interactor: DetailInteractorProtocol, router: DetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension DetailPresenter: DetailPresenterProtocol {
}
