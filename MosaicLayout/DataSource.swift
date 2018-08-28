//
//  DataSource.swift
//  MosaicLayout
//
//  Created by Granheim Brustad , Henrik on 07/08/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

class DataSource: NSObject, UICollectionViewDataSource {
    
    var data: [Int]
    var count: Int {
        return data.count
    }
    
    init(data: [Int]) {
        self.data = data
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(hue: CGFloat(arc4random()) / 0xFFFFFFFF, saturation: 0.6, brightness: 0.75, alpha: 1.0)
        return cell
    }
    
}
