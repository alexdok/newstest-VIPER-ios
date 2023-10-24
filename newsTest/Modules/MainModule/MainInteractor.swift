//
//  MainInteractor.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol MainInteractorProtocol: AnyObject {
    func getNews(theme: String, page: Int)
    func clearAll()
    func checkInternetConnection() -> Bool
    var storage: StorageNews { get }
}

final class MainInteractor: MainInteractorProtocol {
    weak var presenter: MainPresenterProtocol?
    private let network: NetworkService
    private let networStatuskMonitor = NetworkMonitor.shared
    private lazy var arrayNewsForView: [NewsForView] = []
    var storage: StorageNews
    
    init(presenter: MainPresenterProtocol? = nil, network: NetworkService, storage: StorageNews) {
        self.presenter = presenter
        self.network = network
        self.storage = storage
    }
    
    func checkInternetConnection() -> Bool{
        return networStatuskMonitor.isReachable
    }
    
     func getNews(theme: String, page: Int) {
        arrayNewsForView.removeAll()
        network.loadNews(theme: theme, page: page) { [weak self] objectNews in
            self?.storage.news.append(contentsOf: objectNews)
            objectNews.forEach { news in
                guard let newsTitle = news?.title, let newsImage = news?.urlToImage else { return }
                let newsForView = NewsForView(title: newsTitle, urlImage: newsImage)
                self?.arrayNewsForView.append(newsForView)
            }
            self?.getImagesAndTitles()
        }
    }
    
    func clearAll() {
        clearImagesAndTitles()
        arrayNewsForView.removeAll()
        storage.news.removeAll()
    }
    
   private func clearImagesAndTitles() {
       storage.arrayImages.removeAll()
       storage.arrayTitles.removeAll()
    }
    
   private func getImagesAndTitles() {
        clearImagesAndTitles()
        let dispatchGroup = DispatchGroup()
       
        arrayNewsForView.forEach { news in
            dispatchGroup.enter()
            network.loadImage(urlForImage: news.urlImage) { image in
                self.storage.arrayTitles.append(news.title)
                self.storage.arrayImages.append(image)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.arrayNewsForView.removeAll()
            self.handleLoadedImages(self.storage.arrayImages)
        }
    }

    func handleLoadedImages(_ images: [UIImage]) {
        presenter?.getValuesForView(images: images, titles: storage.arrayTitles)
    }
}

struct NewsForView {
    var title: String
    var urlImage: String
}
