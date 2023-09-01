//
//  WebPresenter.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 31.08.2023
//

protocol WebPresenterProtocol: AnyObject {
    func viewDidLoaded()
}

class WebPresenter {
    weak var view: WebViewProtocol?
    var router: WebRouterProtocol
    var interactor: WebInteractorProtocol

    init(interactor: WebInteractorProtocol, router: WebRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func createViewModel() -> ViewModelForWebView {
        return ViewModelForWebView(titel: interactor.titleNews, url: interactor.urlNews)
    }
    
}

extension WebPresenter: WebPresenterProtocol {
    func viewDidLoaded() {
        view?.showViewWithViewModel(viewModel: createViewModel())
    }
}
