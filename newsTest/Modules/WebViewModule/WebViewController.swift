//
//  WebViewController.swift
//  newsTest
//
//  Created by алексей ганзицкий on 31.08.2023.
//
import UIKit
import WebKit

protocol WebViewProtocol: AnyObject {
    func showViewWithViewModel(viewModel: WebViewModel)
}

final class WebViewController: UIViewController {
    
    var presenter: WebPresenterProtocol?
    var selectedNews: String?
    var newsURL = ""
    
    var progressView = UIProgressView()
    var webView = WKWebView(frame: CGRect(origin: .zero, size: .zero))
    private var observation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        setupUI()
        addStartValuesForWebView()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func showProgressView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 1
        }, completion: nil)
    }
    
    func hideProgressView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0
        }, completion: nil)
    }
}

extension WebViewController {
    private func addStartValuesForWebView() {
        self.progressView.progress = 0
        title = selectedNews
        
        guard let url = URL(string: newsURL) else { return }
        
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        
        let observation = webView.observe(\.estimatedProgress) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
        webView.load(URLRequest(url: url))
        self.observation = observation
    }
    
    private func setupUI() {
        webView.frame.size.width = view.frame.width
        webView.frame.size.height = view.frame.height
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 5),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 5),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: -5)
        ])
    }
    
}
