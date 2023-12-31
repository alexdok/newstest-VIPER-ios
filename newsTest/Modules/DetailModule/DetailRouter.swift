//
//  DetailRouter.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023
//

protocol DetailRouterProtocol {
    func openFullNewsObWebViewController(title: String, url: String)
}

final class DetailRouter: DetailRouterProtocol {
    weak var viewController: DetailViewController?
    func openFullNewsObWebViewController(title: String, url: String) {
        let vc = WebModuleBuilder.build(url: url, title: title)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
