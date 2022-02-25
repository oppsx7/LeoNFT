//
//  UIView+HasLoadingState.swift
//  LeoNFT
//
//  Created by Edis Hasanov on 24/02/2022.
//

import UIKit

protocol HasLoadingState: AnyObject {
    func startLoadingIndicator()
    func stopLoadingIndicator()
}

extension UIView: HasLoadingState {
    private enum Constants {
        static let spinnerTag = -1
    }

    func startLoadingIndicator() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.tag = Constants.spinnerTag
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        spinner.startAnimating()
    }

    func stopLoadingIndicator() {
        if let spinner = viewWithTag(Constants.spinnerTag) {
            spinner.removeFromSuperview()
        }
    }
}

extension UIViewController: HasLoadingState {
    func startLoadingIndicator() {
        view.startLoadingIndicator()
    }

    func stopLoadingIndicator() {
        view.stopLoadingIndicator()
        Utils.hideProgress()
    }
}
