//
//  MainInteractor.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol MainInteractorProtocol: AnyObject {
    func  getNews(theme: String, page: Int)
    func reload()
    var arrayTitles: [String] { get }
    var arrayImages: [UIImage] { get }
    var news: [ObjectNewsData?] { get }
}

class MainInteractor: MainInteractorProtocol {
    weak var presenter: MainPresenterProtocol?
    
    let network: NetworkManager
    var news = [ObjectNewsData?]()
    var arrayNewsForView: [NewsForView] = []
    var arrayTitles = [String]()
    var arrayImages = [UIImage]()
    
    init(presenter: MainPresenterProtocol? = nil, network: NetworkManager) {
        self.presenter = presenter
        self.network = network
    }
    
    
    func getNews(theme: String, page: Int) {
        network.sendRequestForNews(theme: theme, page: page) { [weak self] objectNews in
            self?.news = objectNews
            self?.news.forEach { news in
                guard let newsTitle = news?.title, let newsImage = news?.urlToImage else { return }
                let newsForView = NewsForView(title: newsTitle, urlImage: newsImage)
                self?.arrayNewsForView.append(newsForView)
            }
            self?.getImgesAndTitles()
        }
    }
    
    func reload() {
        arrayImages.removeAll()
        arrayTitles.removeAll()
        arrayNewsForView.removeAll()
        news.removeAll()
    }
    
    
    func getImgesAndTitles() {
        let dispatchGroup = DispatchGroup()
        arrayNewsForView.forEach { news in
            dispatchGroup.enter()
            network.loadImage(urlForImage: news.urlImage) { image in
                defer { dispatchGroup.leave() }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.arrayTitles.append(news.title)
                    self.arrayImages.append(image)
                     }
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
