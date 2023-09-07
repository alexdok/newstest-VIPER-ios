//
//  MainRouter.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//
import UIKit

protocol MainRouterProtocol {
    func openDetailController(image: UIImage, news: ObjectNewsData)
}

class MainRouter: MainRouterProtocol {
    weak var viewController: MainViewController?
    func openDetailController(image: UIImage, news: ObjectNewsData) {
        let vc = DetailModuleBuilder.build(image: image, news: news)
      
        viewController?.navigationController?.pushViewController(vc, animated: true)
        
    }
}
