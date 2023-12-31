//
//  MainPresenter.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol MainPresenterProtocol: AnyObject {
    func loadFirstView()
    func needMoreNews() 
    func getValuesForView(images: [UIImage], titles:[String])
    func didTapNews(title: String, image: UIImage)
    func createCellModels(images: [UIImage], titles: [String]) -> [MainTableViewCellModel]
    var theme: String { get set }
    var page: Int { get set }
    var searchStatus: Bool { get set }
}

final class MainPresenter {
    weak var view: MainViewProtocol?
    let router: MainRouterProtocol
    let interactor: MainInteractorProtocol
    var theme = "sport"
    var page = 1
    var searchStatus = false
    
    init(interactor: MainInteractorProtocol, router: MainRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension MainPresenter: MainPresenterProtocol {
    
    func didTapNews(title: String, image: UIImage) {
        let news = interactor.storage.news.first { objectNews in
           objectNews?.title == title
        }
        guard let news = news else { return }
        router.openDetailController(image: image, news: news ?? ObjectNewsData())
    }
    
     func createCellModels(images: [UIImage], titles: [String]) -> [MainTableViewCellModel] {
        var arrayModelsForCells:[MainTableViewCellModel] = []
        onMain {
            var imageCount = 0
            for title in titles {
                var image = UIImage(named: "noImage")!
                if imageCount < images.count {
                    image = images[imageCount]
                }
                let cellModel = self.createTableViewModel(image: image, title: title)
                imageCount += 1
                arrayModelsForCells.append(cellModel)
            }
        }
        return arrayModelsForCells
    }
    
    private func createTableViewModel(image: UIImage, title: String) -> MainTableViewCellModel {
        let model = MainTableViewCellModel(title: title, image: image, count: LocalStorageManager.shared.loadCount(title))
        return model
    }
    
    func getValuesForView(images: [UIImage], titles: [String]) {
        let cellsModelArray = createCellModels(images: images, titles: titles)
        view?.viewIsReady(cellsModelArray: cellsModelArray)
        view?.finishActivityIndicator()
        if searchStatus && !cellsModelArray.isEmpty {
                view?.showFirstRow()
                searchStatus.toggle()
        }
    }
    
    private func testConnect() {
        if !interactor.checkInternetConnection() {
            let alertModel = AlertModel(title: "Wrong internet connection", message: "please check yourinternet connection and repeat your request")
            view?.showAlert(text: alertModel)
        } else { return }
    }
    
    func needMoreNews() {
        testConnect()
        page += 1
        interactor.getNews(theme: theme, page: page)
    }
    
    func loadFirstView() {
        testConnect()
        interactor.clearAll()
        interactor.getNews(theme: theme, page: page)
    }
}
