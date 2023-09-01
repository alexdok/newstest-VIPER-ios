//
//  DetailRouter.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

protocol DetailRouterProtocol {
    func openFullNewsObWebViewController(title: String, url: String)
}

class DetailRouter: DetailRouterProtocol {
    weak var viewController: DetailViewController?
    func openFullNewsObWebViewController(title: String, url: String) {
        let vc = WebModuleBuilder.build(url: url, title: title)
        
        viewController?.present(vc, animated: true)
    }
}
