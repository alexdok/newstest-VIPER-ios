//
//  DetailPresenter.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

protocol DetailPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didTapButtonToFullNews()
}

class DetailPresenter {
    weak var view: DetailViewProtocol?
    let router: DetailRouterProtocol
    let interactor: DetailInteractorProtocol

    init(interactor: DetailInteractorProtocol, router: DetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func mapper(newsObject: ObjectNewsData) -> ViewModelForDetailView {
        let image = interactor.image
        let model = ViewModelForDetailView(author: newsObject.author ?? "",
                                           title: newsObject.title ?? "",
                                           description: newsObject.description ?? "",
                                           url: newsObject.url ?? "",
                                           image: image,
                                           publishedAt: newsObject.publishedAt ?? "",
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

