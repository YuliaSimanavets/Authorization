//
//  EditorViewController.swift
//  AuthorizationApp
//
//  Created by Yuliya on 14/05/2024.
//

import Combine
import CoreImage
import CropViewController
import UIKit
import SnapKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private var viewModel: EditorViewModel
    private var cancellables = [AnyCancellable]()
    
    enum CellType: Int {
        case crop
        case text
        case draw
        case filters
        
        var name: String {
            switch self {
            case .crop: "CROP"
            case .text: "TEXT"
            case .draw: "DRAW"
            case .filters: "FILTERS"
            }
        }
    }

    private let addPhotoButton = UIButton.new {
        $0.layer.cornerRadius = 40
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemYellow.cgColor
        $0.tintColor = .black
    }
    
    private let downloadButton = UIButton.new {
        $0.tintColor = .black
    }
    
    private let resetButton = UIButton.new {
        $0.tintColor = .black
    }
    
    private var photoImageView = UIImageView.new {
        $0.contentMode = .scaleAspectFit
    }
    
    private var selectedImage: UIImage?
    private var newImage: UIImage?
    
    private let editorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemYellow
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var filterOptions: [EditorCollectionViewModel] = []
    
    // MARK: - Lifecycle

    init(viewModel: EditorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)

        downloadButton.addTarget(self, action: #selector(downloadPhotoTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetPhotoTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: downloadButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: resetButton)
        downloadButton.isHidden = true
        resetButton.isHidden = true
        
        viewModel.$filterOptions
            .sink { [weak self] items in
                guard let self = self else { return }
                self.filterOptions = items
                self.editorCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubviews(addPhotoButton,
                         photoImageView,
                         editorCollectionView,
                         downloadButton)
        setupConstraints()
        
        addPhotoButton.setImage(UIImage(systemName: "plus"), for: .normal)
        downloadButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        resetButton.setImage(UIImage(systemName: "arrowshape.turn.up.backward"), for: .normal)
    }
    
    private func setupCollectionView() {
        editorCollectionView.delegate = self
        editorCollectionView.dataSource = self
        EditorCollectionViewCell.registerCell(in: editorCollectionView)
    }
    
    private func setupConstraints() {
        addPhotoButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        photoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-150)
        }
        
        editorCollectionView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        downloadButton.snp.makeConstraints {
            $0.size.equalTo(50)
        }
    }
    
//    MARK: - Actions
    
    @objc
    private func addPhotoButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alertController = UIAlertController(title: "Add Photo", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let galleryAction = UIAlertAction(title: "Choose from Gallery", style: .default) { _ in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func downloadPhotoTapped() {
        guard let image = newImage else { return }
        let shareableImage = ShareableImage(image: image,
                                            title: "Photo editor")
        let activityViewController = UIActivityViewController(activityItems: [shareableImage], applicationActivities: [])
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true)
        
    }
    
    @objc
    private func resetPhotoTapped() {
        newImage = selectedImage
    }
        
    private func getCellType(at indexPath: IndexPath) -> CellType? {
        CellType(rawValue: indexPath.item)
    }
    
    private func showCrop(for image: UIImage) {
        let cropViewController = CropViewController(croppingStyle: .default, image: image)
        cropViewController.aspectRatioPreset = .presetOriginal
        cropViewController.aspectRatioLockEnabled = false
        cropViewController.toolbarPosition = .top
        cropViewController.doneButtonTitle = "Done"
        cropViewController.doneButtonColor = .systemRed
        cropViewController.cancelButtonTitle = "Back"
        cropViewController.cancelButtonColor = .systemRed
        cropViewController.delegate = self
        
        present(cropViewController, animated: true)
    }
    
    func applyFilter(filterName: String) {
        guard let originalImage = newImage else { return }
        
        if filterName == "Original" {
            photoImageView.image = originalImage
            return
        }
        
        let ciImage = CIImage(image: originalImage)
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if filterName == "CISepiaTone" {
            filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        } else if filterName == "CIColorMonochrome" {
            filter?.setValue(CIColor(color: .gray), forKey: kCIInputColorKey)
            filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        } else if filterName == "CIVignette" {
            filter?.setValue(2.0, forKey: kCIInputIntensityKey)
            filter?.setValue(30.0, forKey: kCIInputRadiusKey)
        }
        
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                let filteredImage = UIImage(cgImage: cgImage)
                newImage = filteredImage
                photoImageView.image = newImage
            }
        }
    }
    
    private func chooseFilter() {
        guard newImage != nil else { return }
        let alert = UIAlertController(title: "Choose a filter", message: nil, preferredStyle: .actionSheet)
        let filters = [
            ("Original", "Original"),
            ("Sepia", "CISepiaTone"),
            ("Monochrome", "CIColorMonochrome"),
            ("Vignette", "CIVignette"),
            ("Chrome", "CIPhotoEffectChrome"),
            ("Noir", "CIPhotoEffectNoir")
        ]

        for filter in filters {
            let action = UIAlertAction(title: filter.0, style: .default) { _ in
                self.applyFilter(filterName: filter.1)
            }
            alert.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension EditorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let cellType = getCellType(at: indexPath),
            let image = newImage
        else { return }
        switch cellType {
        case .crop:
            showCrop(for: image)
        case .text:
            print("text")
        case .draw:
            print("draw")
        case .filters:
            chooseFilter()
        }
    }
}

extension EditorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorCollectionViewCell.name, for: indexPath) as? EditorCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.setup(with: filterOptions[indexPath.item])
        return cell
    }
}

extension EditorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = collectionView.frame
        return EditorCollectionViewCell.size(for: filterOptions[indexPath.item], containerSize: frame.size)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditorViewController {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            photoImageView.image = image
            newImage = image
            
            addPhotoButton.isHidden = true
            downloadButton.isHidden = false
            resetButton.isHidden = false
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditorViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        newImage = image
        photoImageView.image = newImage
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
