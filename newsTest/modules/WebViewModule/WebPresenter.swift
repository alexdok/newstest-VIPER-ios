//
//  WebPresenter.swift
//  newsTest
//
//  Created by алексей ганзицкий on 31.08.2023
//

protocol WebPresenterProtocol: AnyObject {
    func viewDidLoaded()
}

final class WebPresenter {
    weak var view: WebViewProtocol?
    let router: WebRouterProtocol
    let interactor: WebInteractorProtocol

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
