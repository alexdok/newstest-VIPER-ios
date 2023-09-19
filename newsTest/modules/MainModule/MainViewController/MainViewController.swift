//
//  MainViewController.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func finishActivityIndicator()
    func showAlert(text: AlertModel)
    func viewIsReady(images: [UIImage], titles: [String])
}

final class MainViewController: UIViewController {
    
    // MARK: - prop
    var presenter: MainPresenterProtocol?
    let searchBar = UISearchBar()
    let tableNews = UITableView()
    private let refreshControler = UIRefreshControl()
    private let alertBuilder = AlertBuilderImpl()
    lazy var canGiveNewCells = false
    var bottomConstraint: NSLayoutConstraint?
    var cellsNewsForTable: [MainTableViewCellViewModel] = []
    var indicator = ActivityIndicator()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshController()
        configureVC()
        createTableNews()
        configureTableNews()
        
        presenter?.loadFirstsViews()
        indicator.showLoading(onView: view)
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
    
    @objc private func refresh(_ sender: AnyObject) {
        cellsNewsForTable.removeAll()
        presenter?.loadFirstsViews()
        tableNews.reloadData()
    }
    
    internal func finishActivityIndicator() {
        refreshControler.endRefreshing()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       view.endEditing(true)
       bottomConstraint?.constant = 0
        UIView.animate(withDuration: Constants.standartDurationAnimation) {
            self.view.layoutIfNeeded()
        }
   }
}

// MARK: - Private functions
private extension MainViewController {
    private func setupRefreshController() {
        refreshControler.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControler.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableNews.addSubview(refreshControler)
    }
    
    private func configureVC() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Loading....."
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        bottomConstraint?.constant = -keyboardHeight
        UIView.animate(withDuration: Constants.standartDurationAnimation) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = 0
        UIView.animate(withDuration: Constants.standartDurationAnimation) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    
    internal func showAlert(text: AlertModel) {
       let alert = alertBuilder.createAlert(with: text)
        present(alert, animated: true)
    }
    
    func viewIsReady(images: [UIImage], titles: [String]) {
       guard let presenter = presenter else { return }
       let cellsModelsForTable = presenter.createCellModels(images: images, titles: titles)
        cellsNewsForTable += cellsModelsForTable
        self.navigationItem.title = "Table News"
        self.indicator.hideLoading()
        self.tableNews.reloadData()
    }
}
