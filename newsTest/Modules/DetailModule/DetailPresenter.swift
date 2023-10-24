//
//  DetailPresenter.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didTapButtonToFullNews()
}

final class DetailPresenter {
    weak var view: DetailViewProtocol?
    let router: DetailRouterProtocol
    let interactor: DetailInteractorProtocol

    init(interactor: DetailInteractorProtocol, router: DetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func formatDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //        "2023-02-05T12:00:00Z"
        guard let convertDate = formatter.date(from: date) else { return ""}
        formatter.dateFormat = "dd.MMMM.yyyy"
        let newString = formatter.string(from: convertDate)
        return newString
    }
    
    func mapper(newsObject: ObjectNewsData) -> ViewModelForDetailView {
        let image = interactor.image
       
        let model = ViewModelForDetailView(author: newsObject.author ?? "",
                                           title: newsObject.title ?? "",
                                           description: newsObject.description ?? "",
                                           url: newsObject.url ?? "",
                                           image: image,
                                           publishedAt: formatDate(date: newsObject.publishedAt ?? ""),
                                           content: newsObject.content ?? "")
        return model
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func didTapButtonToFullNews() {
        let title = interactor.news.title ?? ""
        let url = interactor.news.url ?? ""
        router.openFullNewsObWebViewController(title: title, url: url)
     
    }
    
    func viewDidLoaded() {
        view?.setValuesToViewController(viewModel: mapper(newsObject: interactor.news))
    }
}

