//
//  AddPhotoViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 22/06/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

protocol AddPhotoDelegate {
    func didSelectPhoto(_ img: UIImage)
}

class AddPhotoViewController: UIViewController {

    var delegate: AddPhotoDelegate?
    private let collectionCellIdentifier = String(describing: ProfileCollectionViewCell.self)
    var photos: [UIImage] = []

    lazy var galeryCollectionView: UICollectionView = {
        return UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let cell = UINib(nibName: collectionCellIdentifier, bundle: nil)
        galeryCollectionView.register(cell, forCellWithReuseIdentifier: collectionCellIdentifier)
        
        galeryCollectionView.delegate = self
        galeryCollectionView.dataSource = self
        galeryCollectionView.backgroundColor = .white
        view.addSubview(galeryCollectionView)

        photos = DataProviders.shared.photoProvider.photos()
    }
}

extension AddPhotoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier,
                                                      for: indexPath as IndexPath) as! ProfileCollectionViewCell
        cell.image.image = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loagingProvider.start()
        delegate?.didSelectPhoto(photos[indexPath.item])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: Int(width/3), height: Int(width/3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return -1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -1
    }
}
