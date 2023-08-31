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
    func didCellTapt(title: String, image: UIImage)
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
    func didCellTapt(title: String, image: UIImage) {
       var newsArray = interactor.news
       let news = newsArray.first { objectNews in
           objectNews?.title == title
        }
        guard let news = news else { return }
        router.openDetailController(image: image, news: news ?? ObjectNewsData())
    }
    
    func getValuesForView(images: [UIImage], titles: [String]) {
        view?.viewIsReady(images: images, titles: titles)
    }
    
    func viewDidLoaded() {
        interactor.getNews()
    }
}
