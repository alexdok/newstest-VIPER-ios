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
    let interactor: WebInteractorProtocol

    init(interactor: WebInteractorProtocol) {
        self.interactor = interactor
      
    }
    
    func createViewModel() -> WebViewModel {
        return WebViewModel(title: interactor.titleNews, url: interactor.urlNews)
    }
}

extension WebPresenter: WebPresenterProtocol {
    func viewDidLoaded() {
        view?.showViewWithViewModel(viewModel: createViewModel())
    }
}
