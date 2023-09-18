//
//  DetailInteractor.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol DetailInteractorProtocol: AnyObject {
    var image: UIImage { get }
    var news: ObjectNewsData { get }
}

final class DetailInteractor: DetailInteractorProtocol {
    weak var presenter: DetailPresenterProtocol?
    let image: UIImage
    let news: ObjectNewsData
    
    init( image: UIImage, news: ObjectNewsData) {
        self.image = image
        self.news = news
    }
}
