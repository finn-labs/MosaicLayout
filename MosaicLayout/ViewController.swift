//
//  ViewController.swift
//  MosaicLayout
//
//  Created by Granheim Brustad , Henrik on 07/08/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let dataSource = DataSource(data: Array<Int>(repeating: 0, count: 360))

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = MosaicLayout(dataSource: dataSource)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.dataSource = dataSource
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }


}
