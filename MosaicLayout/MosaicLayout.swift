//
//  MosaicLayout.swift
//  MosaicLayout
//
//  Created by Granheim Brustad , Henrik on 07/08/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

class MosaicLayout: UICollectionViewLayout {
    
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    var dataSource: DataSource
    var spacing: CGFloat = 1
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
        
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: cv.bounds.size)
        createAttributes()
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter({ (attribute) -> Bool in
            rect.intersects(attribute.frame)
        })
    }
    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cv = collectionView else { return false }
        return !newBounds.size.equalTo(cv.bounds.size)
    }
    
    private func createAttributes() {

        let itemsPerRow = 9
        let rows = dataSource.count / itemsPerRow
        
        cachedAttributes.reserveCapacity(rows * itemsPerRow)

        for r in 0 ..< rows {
            let row = Row(index: r, contentSize: contentBounds.size)
            var i = r * itemsPerRow
            while let frame = row.nextFrame() {
                let attribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
                attribute.frame = frame
                cachedAttributes.append(attribute)
                contentBounds = contentBounds.union(attribute.frame)
                i += 1
            }
        }
    }
}
