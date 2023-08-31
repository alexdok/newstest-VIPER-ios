//
//  WebInteractor.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 31.08.2023
//

protocol WebInteractorProtocol: AnyObject {
}

class WebInteractor: WebInteractorProtocol {
    weak var presenter: WebPresenterProtocol?
}
