//
//  WebInteractor.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 31.08.2023
//

protocol WebInteractorProtocol: AnyObject {
    var titleNews: String { get }
    var urlNews: String { get }
}

class WebInteractor: WebInteractorProtocol {
    weak var presenter: WebPresenterProtocol?
    let titleNews: String
    let urlNews: String
    
    init(titleNews: String, urlNews: String) {
        self.titleNews = titleNews
        self.urlNews = urlNews
    }
}
