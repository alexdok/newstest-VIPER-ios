//
//  MainInteractor.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

protocol MainInteractorProtocol: AnyObject {
}

class MainInteractor: MainInteractorProtocol {
    weak var presenter: MainPresenterProtocol?
}
