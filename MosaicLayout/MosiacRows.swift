//
//  MosiacRows.swift
//  MosaicLayout
//
//  Created by Granheim Brustad , Henrik on 28/08/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

protocol MosaicRow {
    func nextFrame() -> CGRect?
}

class BigRow: MosaicRow {

    let offset: CGFloat
    let spacing: CGFloat = 1

    private var index = 0
    private let frames: [CGRect]

    init(index: Int, contentSize: CGSize, flipped: Bool) {
        let width = (contentSize.width - 2) / 3
        let height = width
        self.offset = CGFloat(2 * index) * (height + spacing)

        self.frames = flipped ?
            [CGRect(x: 0, y: 0, width: 2 * width + spacing, height: 2 * height + spacing),
             CGRect(x: 2 * (width + spacing), y: 0, width: width, height: height),
             CGRect(x: 2 * (width + spacing), y: height + spacing, width: width, height: height)]
            :
            [CGRect(x: 0, y: 0, width: width, height: height),
             CGRect(x: width + spacing, y: 0, width: 2 * width + spacing, height: 2 * height + spacing),
             CGRect(x: 0, y: height + spacing, width: width, height: height)]

    }

    func nextFrame() -> CGRect? {
        guard index != frames.endIndex  else { return nil }
        var frame = frames[index]
        frame.origin.y += offset
        index = frames.index(after: index)

        return frame
    }
}

class SmallRow: MosaicRow {

    let offset: CGFloat
    let spacing: CGFloat = 1

    private var index = 0
    private let frames: [CGRect]

    init(index: Int, contentSize: CGSize) {
        let width = (contentSize.width - 2) / 3
        let height = width
        self.offset = CGFloat(2 * index) * (height + spacing)

        self.frames = [CGRect(x: 0, y: 0, width: width, height: height),
                       CGRect(x: width + spacing, y: 0, width: width, height: height),
                       CGRect(x: 2 * (width + spacing), y: 0, width: width, height: height),

                       CGRect(x: 0, y: height + spacing, width: width, height: height),
                       CGRect(x: width + spacing, y: height + spacing, width: width, height: height),
                       CGRect(x: 2 * (width + spacing), y: height + spacing, width: width, height: height)]
    }

    func nextFrame() -> CGRect? {
        guard index != frames.endIndex  else { return nil }
        var frame = frames[index]
        frame.origin.y += offset
        index = frames.index(after: index)

        return frame
    }
}

class Row: MosaicRow {

    let bigRow: BigRow
    let smallRow: SmallRow

    init(index: Int, contentSize: CGSize) {
        let flipped = index % 2 != 0
        self.bigRow = BigRow(index: 2 * index, contentSize: contentSize, flipped: flipped)
        self.smallRow = SmallRow(index: 2 * index + 1, contentSize: contentSize)
    }

    func nextFrame() -> CGRect? {
        if let frame = bigRow.nextFrame() { return frame }
        return smallRow.nextFrame()
    }
}
