//
//  MainViewController.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol MainViewProtocol: AnyObject {

}

class MainViewController: UIViewController {

    // MARK: - Public
    var presenter: MainPresenterProtocol?
    let tableNews = UITableView()
    let refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    var bottomConstraint: NSLayoutConstraint?
    let alertBuilder = AlertBuilderImpl()
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshController()
        configureVC()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupRefreshController() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableNews.addSubview(refreshControl)
    }
    
    func configureVC() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        createTableNews()
        configureTableNews()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.endRefreshing()
    }
}

// MARK: - Private functions
private extension MainViewController {
    func initialize() {
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
}

