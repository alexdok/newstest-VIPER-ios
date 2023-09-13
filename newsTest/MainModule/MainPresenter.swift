//
//  MainPresenter.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol MainPresenterProtocol: AnyObject {
    func loadFirstsViews()
    func loadNewCells() 
    func getValuesForView(images: [UIImage], titles:[String])
    func didNewsTapt(title: String, image: UIImage)
    var theme: String { get set }
    var page: Int { get set }
}

final class MainPresenter {
    weak var view: MainViewProtocol?
    let router: MainRouterProtocol
    let interactor: MainInteractorProtocol
    var theme = "football"
    var page = 1
    
    init(interactor: MainInteractorProtocol, router: MainRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension MainPresenter: MainPresenterProtocol {
    
    func didNewsTapt(title: String, image: UIImage) {
       let news = interactor.news.first { objectNews in
           objectNews?.title == title
        }
        guard let news = news else { return }
        router.openDetailController(image: image, news: news ?? ObjectNewsData())
    }
    
    func getValuesForView(images: [UIImage], titles: [String]) {
        view?.viewIsReady(images: images, titles: titles)
        view?.finishActivityIndicator()
    }
    
    func loadNewCells() {
            page += 1
            interactor.getNews(theme: theme, page: page)
    }
    
    func loadFirstsViews() {
        page = 1
        interactor.reload()
        interactor.getNews(theme: theme, page: page)
    }
}
