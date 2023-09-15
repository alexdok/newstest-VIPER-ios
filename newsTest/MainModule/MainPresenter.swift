//
//  MainPresenter.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol MainPresenterProtocol: AnyObject {
    func loadFirstsViews()
    func needMoreCells() 
    func getValuesForView(images: [UIImage], titles:[String])
    func didNewsTapt(title: String, image: UIImage)
    var theme: String { get set }
    var page: Int { get set }
    var canNewLoad: Bool { get set }
}

final class MainPresenter {
    weak var view: MainViewProtocol?
    let router: MainRouterProtocol
    let interactor: MainInteractorProtocol
    var canNewLoad = true
    var theme = "nhl"
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
    
    internal func getValuesForView(images: [UIImage], titles: [String]) {
        view?.viewIsReady(images: images, titles: titles)
        view?.finishActivityIndicator()
    }
    
    private func testConnect() {
        if !interactor.checkInternetConnection() {
            let alertModel = AlertModel(title: "Wrong internet connection", message: "please check yourinternet connection and repeat your request")
            view?.showAlert(text: alertModel)
        } else { return }
    }
    
    internal func needMoreCells() {
        testConnect()
        page += 1
    print(page)
        interactor.getNews(theme: theme, page: page)
    }
    
    internal func loadFirstsViews() {
        testConnect()
        page = 1
        print(page)
        interactor.reload()
        interactor.getNews(theme: theme, page: page)
    }
}
