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

    // Filter method:
    // Max = 0.975ms
    // Min = 0.385ms

    // Binary search:

    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("Layout fort")
        let tick = CACurrentMediaTime()
//        let frames = cachedAttributes.filter({ (attribute) -> Bool in
//            rect.intersects(attribute.frame)
//        })

        let count = cachedAttributes.count

        var previousIndex = 0
        var currentIndex = count / 2
        var minIndex = Int.max
        var maxIndex = 0

        while true {
            let frame = cachedAttributes[currentIndex].frame

            if currentIndex == previousIndex {
                minIndex = currentIndex
                break
            }

            if frame.maxY < rect.minY {
                let next = (currentIndex - previousIndex) / 2
                previousIndex = currentIndex
                currentIndex += abs(next)
            } else {
                let next = (currentIndex - previousIndex) / 2
                previousIndex = currentIndex
                currentIndex -= abs(next)
            }
        }

        previousIndex = 0
        currentIndex = count / 2

        while true {

            let frame = cachedAttributes[currentIndex].frame
            if currentIndex == previousIndex {
                maxIndex = currentIndex
                break
            }

            if frame.minY > rect.maxY {
                let next = (currentIndex - previousIndex) / 2
                previousIndex = currentIndex
                currentIndex -= abs(next)
            } else {
                let next = (currentIndex - previousIndex) / 2
                previousIndex = currentIndex
                currentIndex += abs(next)
            }
        }

        print("Layout in rect:", CACurrentMediaTime() - tick)
        return Array(cachedAttributes[minIndex ..< maxIndex])
//        return frames
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
