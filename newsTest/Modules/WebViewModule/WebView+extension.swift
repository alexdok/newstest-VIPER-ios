//
//  WebView+extension.swift
//  newsTest
//
//  Created by алексей ганзицкий on 31.08.2023.
//
import WebKit

extension WebViewController: WKNavigationDelegate {
    
    internal func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressView()
    }
    
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressView()
    }
    
    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressView()
    }
}

extension WebViewController: WebViewProtocol {
    func showViewWithViewModel(viewModel: WebViewModel) {
        selectedNews = viewModel.title
        newsURL = viewModel.url
    }
}
