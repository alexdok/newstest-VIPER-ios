//
//  DetailInteractor.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

protocol DetailInteractorProtocol: AnyObject {
}

class DetailInteractor: DetailInteractorProtocol {
    weak var presenter: DetailPresenterProtocol?
}
