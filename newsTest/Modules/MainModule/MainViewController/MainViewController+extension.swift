//
//  MainTableView.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//
import UIKit

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsNewsForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as MainTableViewCell
        cell.setupValuesCell(values: cellsNewsForTable[indexPath.row])
        needMoreCells(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cellsNewsForTable[indexPath.row].count += 1
        let count = cellsNewsForTable[indexPath.row].count
        LocalStorageManager.shared.save(cellsNewsForTable[indexPath.row].title, count: count)
        presenter?.didTapNews(title: cellsNewsForTable[indexPath.row].title, image: cellsNewsForTable[indexPath.row].image)
        tableNews.reloadData()
    }
    
    private func needMoreCells(indexPath: IndexPath) {
        switch indexPath.row {
        case cellsNewsForTable.count - 10:
            canGiveNewCells = true
        case let row where row > cellsNewsForTable.count - 2 && canGiveNewCells == true :
            canGiveNewCells.toggle()
            presenter?.needMoreNews()
        default: break
        }
    }
}

extension MainViewController: UISearchBarDelegate {
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        cellsNewsForTable.removeAll()
        presenter?.theme = searchBar.searchTextField.text ?? "main"
        presenter?.loadFirstView()
        indicator.showLoading(onView: view)
        searchBar.searchTextField.text = nil
    }
}

extension MainViewController {
    // setup constraints
    func addTableViewNewsToView() {
        view.addSubview(tableNews)
        tableNews.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableNews.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableNews.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.tableViewBottomPadding),
            tableNews.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableNews.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
}

