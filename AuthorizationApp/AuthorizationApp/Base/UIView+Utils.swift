//
//  UIView+Utils.swift
//  AuthorizationApp
//
//  Created by Yuliya on 13/05/2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        addSubviews(views)
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
