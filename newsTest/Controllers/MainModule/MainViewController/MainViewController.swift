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
    var canGiveNewCells = false
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
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    
    internal func showAlert(text: AlertModel) {
       let alert = alertBuilder.createAlert(with: text)
        present(alert, animated: true)
    }
    
   internal func viewIsReady(images: [UIImage], titles: [String]) {
        let cellsModelsForTable = createCellModels(images: images, titles: titles)
        cellsNewsForTable += cellsModelsForTable
        self.navigationItem.title = "Table News"
        self.indicator.hideLoading()
        self.tableNews.reloadData()
    }
    
    private func createCellModels(images: [UIImage], titles: [String]) -> [MainTableViewCellViewModel] {
        var arrayModelsForCells:[MainTableViewCellViewModel] = []
        onMain {
            var imageCount = 0
            for title in titles {
                var image = UIImage(named: "noImage")!
                if imageCount < images.count {
                    image = images[imageCount]
                }
                let cellModel = self.createTableViewModel(image: image, title: title)
                imageCount += 1
                arrayModelsForCells.append(cellModel)
            }
        }
        return arrayModelsForCells
    }
    
    private func createTableViewModel(image: UIImage, title: String) -> MainTableViewCellViewModel {
        let model = MainTableViewCellViewModel(title: title, image: image, count: SaveManagerImpl.shared.loadCount(title))
        return model
    }
}
