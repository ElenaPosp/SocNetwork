//
//  FiltersViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 30/06/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

protocol FiltersDelegate {
    
}
class FiltersViewController: UIViewController {

    var delegate: FiltersDelegate?
    var targetImage: UIImage?
    private let collectionCellIdentifier = String(describing: FilterCollectionViewCell.self)
    let filters = ["CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CIPinchDistortion", "CIPinLightBlendMode", "CIPixellate", "CIPointillize","CIScreenBlendMode", "CISepiaTone", "CISoftLightBlendMode", "CISpotColor", "CISpotLight", "CIStraightenFilter"]

    lazy var filtersCollection: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let point = CGPoint(x: 0, y: view.center.y)
        let frame = CGRect(origin: point, size: CGSize(width: view.frame.width, height: view.frame.height/2))
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
//        setupFilters() 
    }

    private func setupCollectionView() {
        let cell = UINib(nibName: collectionCellIdentifier, bundle: nil)
        filtersCollection.register(cell, forCellWithReuseIdentifier: collectionCellIdentifier)
        view.addSubview(filtersCollection)
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        filtersCollection.backgroundColor = .green
    }
    
    private func applyFilter(_ image: UIImage?, at item: Int) -> UIImage? {
        guard let image = image else { return nil }
        print("\(item)"+filters[item])
        let filter = CIFilter(name: filters[item])
        
        // convert UIImage to CIImage and set as input
        
        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")
        
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        
        let ciContext = CIContext()
        guard let ciOutput = filter?.outputImage else { print("ddd"); return nil }

        let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent)
        
        return UIImage(cgImage: cgImage!)
    }
}

extension FiltersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filtersCollection.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier,
                                                         for: indexPath as IndexPath) as! FilterCollectionViewCell
        cell.imageView.image = applyFilter(targetImage, at: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
