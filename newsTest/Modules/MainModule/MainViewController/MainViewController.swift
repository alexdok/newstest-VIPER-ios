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
    var cellsNewsForTable: [MainTableViewCellModel] = []
    var indicator = ActivityIndicator()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshController()
        setupVC()
        addTableViewNewsToView()
        setupTableViewNews()
        setupSearchBar()
        
        presenter?.loadFirstView()
        indicator.showLoading(onView: view)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        cellsNewsForTable.removeAll()
        presenter?.loadFirstView()
        tableNews.reloadData()
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
    
    private func setupVC() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Loading....."
    }
    
    private func setupSearchBar() {
        searchBar.frame = CGRect(x:0, y:0, width: tableNews.frame.size.width, height:33)
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.white
        searchBar.placeholder = "search"
    }
    
    private func setupTableViewNews() {
        tableNews.rowHeight = CGFloat(Constants.tableNewsRowHeight)
        tableNews.estimatedRowHeight = UITableView.automaticDimension
        tableNews.dataSource = self
        tableNews.delegate = self
        tableNews.register(MainTableViewCell.self)
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    
    func finishActivityIndicator() {
        refreshControler.endRefreshing()
    }
    
    func showAlert(text: AlertModel) {
        let alert = alertBuilder.createAlert(with: text)
        present(alert, animated: true)
    }
    
    func viewIsReady(images: [UIImage], titles: [String]) {
        guard let presenter = presenter else { return }
        let cellsModelsForTable = presenter.createCellModels(images: images, titles: titles)
        cellsNewsForTable += cellsModelsForTable
        navigationItem.title = "Table News"
        indicator.hideLoading()
        tableNews.reloadData()
    }
}
