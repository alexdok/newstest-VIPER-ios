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
    var arrayTitles: [String] { get }
    var arrayImages: [UIImage] { get }
    var news: [ObjectNewsData?] { get }
}

final class MainInteractor: MainInteractorProtocol {
    weak var presenter: MainPresenterProtocol?
    private let network: NetworkManager
    private let networStatuskMonitor = NetworkMonitor.shared
    private var arrayNewsForView: [NewsForView] = []
    var news:[ObjectNewsData?] = [] 
    lazy var arrayTitles = [String]()
    lazy var arrayImages = [UIImage]()
    
    init(presenter: MainPresenterProtocol? = nil, network: NetworkManager) {
        self.presenter = presenter
        self.network = network
    }
    
   internal func checkInternetConnection() -> Bool{
        return networStatuskMonitor.isReachable
    }
    
    internal func getNews(theme: String, page: Int) {
        arrayNewsForView.removeAll()
        network.sendRequestForNews(theme: theme, page: page) { [weak self] objectNews in
            self?.news.append(contentsOf: objectNews) 
            objectNews.forEach { news in
                guard let newsTitle = news?.title, let newsImage = news?.urlToImage else { return }
                let newsForView = NewsForView(title: newsTitle, urlImage: newsImage)
                self?.arrayNewsForView.append(newsForView)
            }
            self?.getImgesAndTitles()
        }
    }
    
   internal func clearAll() {
        clearImagesAndTitles()
        arrayNewsForView.removeAll()
        news.removeAll()
    }
    
   private func clearImagesAndTitles() {
        arrayImages.removeAll()
        arrayTitles.removeAll()
    }
    
   private func getImgesAndTitles() {
        clearImagesAndTitles()
        let dispatchGroup = DispatchGroup()
        arrayNewsForView.forEach { news in
            dispatchGroup.enter()
            network.loadImage(urlForImage: news.urlImage) { image in
                self.arrayTitles.append(news.title)
                self.arrayImages.append(image)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.handleLoadedImages(self.arrayImages)
        }
    }

    func handleLoadedImages(_ images: [UIImage]) {
        presenter?.getValuesForView(images: images, titles: arrayTitles)
    }
}

struct NewsForView {
    var title: String
    var urlImage: String
}