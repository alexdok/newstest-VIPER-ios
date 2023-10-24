//
//  Activityindicator.swift
//  newsTest
//
//  Created by алексей ганзицкий on 08.09.2023.
//

import UIKit

final class ActivityIndicator: UIView {
    
    var spinner: UIView?
    
    func showLoading(onView: UIView) {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = .gray
        spinnerView.backgroundColor = spinnerView.backgroundColor?.withAlphaComponent(0.1)
        let ai = UIActivityIndicatorView(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        onMain {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
            spinnerView.center = onView.center
        }
        spinner = spinnerView
    }
    
    func hideLoading() {
       onMain {
            self.spinner?.removeFromSuperview()
            self.spinner = nil
        }
    }
}
