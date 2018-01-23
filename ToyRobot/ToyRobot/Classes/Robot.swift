//
//  Robot.swift
//  ToyRobot
//
//  Created by Joshua on 23/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

struct Robot {
    var location: CGPoint?
    var hasBeenPlaced: Bool = false
    
    init() {
        
    }
    
    func reportCurrentLocation () -> CGPoint? {
        return location
    }
}
