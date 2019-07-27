//
//  FiltersViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 30/06/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


class FiltersViewController: UIViewController {

    private struct Image {
        var mini: UIImage
        var original: UIImage
    }

    var targetImageIndex: Int? {
        didSet {
            setupTargetImage()
        }
    }

    private var targetImage: Image?
    private var isCanceled = false
    private var mainImageView: UIImageView?
    private var filteredImages = [UIImage]()
    private let collectionCellIdentifier = String(describing: FilterCollectionViewCell.self)
    private let filters = ["CISpotLight", "CIPhotoEffectInstant", "CIPhotoEffectMono",
                           "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal",
                           "CIPhotoEffectTransfer", "CIPinchDistortion", "CIPinLightBlendMode",
                           "CIPixellate", "CIPointillize","CIScreenBlendMode", "CISepiaTone",
                           "CISoftLightBlendMode", "CISpotColor", "CIStraightenFilter"]

    lazy var filtersCollection: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let point = CGPoint(x: 0, y: view.frame.height - bottomBarHeight - 120)
        let frame = CGRect(origin: point, size: CGSize(width: view.frame.width, height: 120))
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        return collection
    }()
    
    private func setupTargetImage() {
        guard
            DataProviders.shared.photoProvider.thumbnailPhotos().count > 0,
            DataProviders.shared.photoProvider.photos().count > 0
            else { return }
        
        targetImage = Image(
            mini: DataProviders.shared.photoProvider.thumbnailPhotos()[targetImageIndex ?? 0],
            original: DataProviders.shared.photoProvider.photos()[targetImageIndex ?? 0])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainImage()
        setupCollectionView()
        setupNextButton()
        view.backgroundColor = .white
        loagingProvider.stop()
    }
    
    func setupMainImage() {
        let point = CGPoint(x: 0, y: topBarHeight)
        let frame = CGRect(origin: point, size: CGSize(width: view.frame.width, height: view.frame.width))
        let mainImgView = UIImageView(frame: frame)
        mainImgView.image = targetImage?.original
        mainImgView.contentMode = .scaleAspectFit
        self.mainImageView = mainImgView
        
        view.addSubview(mainImgView)
    }

    private func setupFilters() {
        for index in 0...filters.count-1 {
            guard let image = applyFilter(at: index, for: targetImage?.mini) else { return }
            filteredImages.append(image)

            DispatchQueue.main.async { [weak self] in
                self?.filtersCollection.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isCanceled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isCanceled = false
        DispatchQueue.global().async { [weak self] in
            self?.setupFilters()
        }
    }

    private func applyFilter(at item: Int, for image: UIImage?) -> UIImage? {
        guard
            !isCanceled,
            let image = image else { return nil }

        print("Set \(item)"+filters[item])
        let filter = CIFilter(name: filters[item])

        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")

        let ciContext = CIContext()
        guard let ciOutput = filter?.outputImage else { return nil }

        let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent)
        return UIImage(cgImage: cgImage!)
    }

    private func setupCollectionView() {
        let cell = UINib(nibName: collectionCellIdentifier, bundle: nil)
        filtersCollection.register(cell, forCellWithReuseIdentifier: collectionCellIdentifier)
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        filtersCollection.backgroundColor = .white
        view.addSubview(filtersCollection)
    }

    private func setupNextButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goNext))
    }

    @objc func goNext() {
        let vc = DescriptionViewController()
        vc.image = mainImageView?.image
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FiltersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filtersCollection.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier,
                                                         for: indexPath as IndexPath) as! FilterCollectionViewCell
        
        let image = filteredImages.count > indexPath.row ? filteredImages[indexPath.row] : targetImage?.mini
        cell.imageView.image = image
        cell.filterNameLabel.text = filters[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loagingProvider.start()
        DispatchQueue.global().async { [weak self] in
            guard let image = self?.applyFilter(at: indexPath.item, for: self?.targetImage?.original) else { return }
            DispatchQueue.main.async {
                self?.mainImageView?.image = image
                loagingProvider.stop()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
