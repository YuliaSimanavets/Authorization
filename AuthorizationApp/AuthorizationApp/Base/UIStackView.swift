//
//  UIStackView.swift
//  AuthorizationApp
//
//  Created by Yuliya on 13/05/2024.
//

import UIKit

extension UIStackView {
    public func addArrangedSubviews(_ subviews: UIView...) {
        addArrangedSubviews(subviews)
    }

    public func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }
}
