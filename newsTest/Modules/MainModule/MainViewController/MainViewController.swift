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
    func viewIsReady(cellsModelArray: [MainTableViewCellModel])
    func showFirstRow()
}

final class MainViewController: UIViewController {
    // MARK: - prop
    var presenter: MainPresenterProtocol?
    let searchBar = UISearchBar()
    let tableNews = UITableView()
    private let refreshControler = UIRefreshControl()
    private let alertBuilder = AlertBuilderImpl()
    private var previousContentOffset: CGFloat = 0
    lazy var canGiveNewCells = false
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
    }
    
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > previousContentOffset && previousContentOffset >= 0 {
            searchBar.isHidden = true
        } else if scrollView.contentOffset.y < previousContentOffset {
            searchBar.isHidden = false
        }
        previousContentOffset = scrollView.contentOffset.y
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
        searchBar.frame = CGRect(x:0, y:0, width: tableNews.frame.size.width, height: 33)
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
   
    func showFirstRow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableNews.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func finishActivityIndicator() {
        refreshControler.endRefreshing()
    }
    
    func showAlert(text: AlertModel) {
        let alert = alertBuilder.createAlert(with: text)
        present(alert, animated: true)
    }
    
    func viewIsReady(cellsModelArray: [MainTableViewCellModel]) {
        cellsNewsForTable += cellsModelArray
        navigationItem.title = "Table News"
        indicator.hideLoading()
        tableNews.reloadData()
    }
}
