//
//  FiltersViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 30/06/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol FiltersDelegate {
    
}
class FiltersViewController: UIViewController {

    var delegate: FiltersDelegate?
    var targetImage: UIImage?

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
        let point = CGPoint(x: 0, y: 2*view.frame.height/3)
        let frame = CGRect(origin: point, size: CGSize(width: view.frame.width, height: 120))
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainImage()

        setupCollectionView()
        setupNextButton()
        loagingProvider.stop()
    }
    
    func setupMainImage() {

        let point = CGPoint(x: 0, y: 0)
        let frame = CGRect(origin: point, size: CGSize(width: view.frame.width, height: 2*view.frame.height/3))
        let mainImgView = UIImageView(frame: frame)
        mainImgView.image = targetImage
        mainImgView.contentMode = .scaleAspectFit
        self.mainImageView = mainImgView
        
        view.addSubview(mainImgView)
    }

    private func setupFilters() {
        for index in 0...filters.count-1 { applyFilter(at: index) }
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

    private func applyFilter(at item: Int) {
        
        guard
            !isCanceled,
            let image = targetImage else { return }

        print("Set \(item)"+filters[item])
        let filter = CIFilter(name: filters[item])

        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")

        let ciContext = CIContext()
        guard let ciOutput = filter?.outputImage else { return }

        let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent)
        filteredImages.append(UIImage(cgImage: cgImage!))
        DispatchQueue.main.async { [weak self] in
            self?.filtersCollection.reloadItems(at: [IndexPath(row: item, section: 0)])
        }
    }

    private func setupCollectionView() {
        let cell = UINib(nibName: collectionCellIdentifier, bundle: nil)
        filtersCollection.register(cell, forCellWithReuseIdentifier: collectionCellIdentifier)
        view.addSubview(filtersCollection)
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        filtersCollection.backgroundColor = .green
    }

    private func setupNextButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goNext))
    }

    @objc func goNext() {
        let vc = DescriptionViewController()
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
        let image = filteredImages.count > indexPath.row ? filteredImages[indexPath.row] : targetImage
        cell.imageView.image = image
        cell.filterNameLabel.text = filters[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainImageView?.image = filteredImages[indexPath.row]
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
