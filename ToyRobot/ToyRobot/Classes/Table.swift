//
//  Table.swift
//  ToyRobot
//
//  Created by Joshua on 23/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation
import UIKit

struct Table {
    let minX: UInt
    let minY: UInt
    let maxX: UInt
    let maxY: UInt

    func isWithInThisTable (_ point: CGPoint) -> Bool {
        let pointX = Int(point.x)
        let pointY = Int(point.y)
        if pointX < minX || pointX > maxX || pointY < minY || pointY > maxY{
            return false
        }
        return true
    }
}
