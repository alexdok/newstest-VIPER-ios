//
//  MainSerchBar.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//

import UIKit

extension MainViewController: UISearchBarDelegate {
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        cellsNewsForTable.removeAll()
        presenter?.theme = searchBar.searchTextField.text ?? "main"
        presenter?.loadFirstsViews()
        indicator.showLoading(onView: view)
        searchBar.searchTextField.text = nil
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        bottomConstraint?.constant = -keyboardHeight
        UIView.animate(withDuration: Constants.standartDurationAnimation) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = 0
        UIView.animate(withDuration: Constants.standartDurationAnimation) {
            self.view.layoutIfNeeded()
        }
    }
    
     func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
        bottomConstraint?.constant = 0
        UIView.animate(withDuration: Constants.standartDurationAnimation) {
            self.view.layoutIfNeeded()
        }
    }
}
