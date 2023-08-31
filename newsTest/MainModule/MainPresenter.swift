//
//  MainPresenter.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func getValuesForView(images: [UIImage], titles:[String])
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
    func getValuesForView(images: [UIImage], titles: [String]) {
        view?.viewIsReady(images: images, titles: titles)
    }
    
    func viewDidLoaded() {
        interactor.getNews()
    }
}
