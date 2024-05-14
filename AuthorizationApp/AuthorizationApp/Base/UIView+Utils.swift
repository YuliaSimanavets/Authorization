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

extension UIView {
    class var name: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    class var reuseIdentifier: String { name }

    class func registerCell(in collectionView: UICollectionView, with reuseIdentifier: String? = nil) {
        collectionView.register(self, forCellWithReuseIdentifier: reuseIdentifier ?? Self.reuseIdentifier)
    }
}

extension UIView {
    func сonvertToImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
