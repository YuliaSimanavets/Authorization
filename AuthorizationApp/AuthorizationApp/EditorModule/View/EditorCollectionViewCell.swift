//
//  EditorCollectionViewCell.swift
//  AuthorizationApp
//
//  Created by Yuliya on 14/05/2024.
//

import UIKit
import SnapKit

struct EditorCollectionViewModel {
    let filterName: String
}

final class EditorCollectionViewCell: UICollectionViewCell {
    private let filterLabel = UILabel.new {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textAlignment = .center
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupView() {
        contentView.addSubviews(filterLabel)
        contentView.backgroundColor = .clear
        setupConstraints()
    }

    func setup(with data: EditorCollectionViewModel) {
        filterLabel.text = data.filterName
    }
    
    private func setupConstraints() {
        filterLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
        }
    }
    
    static func size(for data: EditorCollectionViewModel, containerSize: CGSize) -> CGSize {
        CGSize(width: containerSize.width / 4, height: containerSize.height)
    }
}
