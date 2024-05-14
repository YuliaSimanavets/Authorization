//
//  EditorViewModel.swift
//  AuthorizationApp
//
//  Created by Yuliya on 14/05/2024.
//

import UIKit
import Combine
import Photos
import Social

final class EditorViewModel {
    @Published
    private(set) var filterOptions: [EditorCollectionViewModel] = [
        EditorCollectionViewModel(filterName: EditorViewController.CellType.crop.name),
        EditorCollectionViewModel(filterName: EditorViewController.CellType.text.name),
        EditorCollectionViewModel(filterName: EditorViewController.CellType.draw.name),
        EditorCollectionViewModel(filterName: EditorViewController.CellType.filters.name)
    ]
    
    func numberOfItemsInSection() -> Int {
        filterOptions.count
    }
}
