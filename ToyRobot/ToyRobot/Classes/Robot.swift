//
//  Robot.swift
//  ToyRobot
//
//  Created by Joshua on 23/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

class Robot: NSObject, CommandProtocol {
    var location: CGPoint? = nil
    var hasBeenPlaced: Bool = false
    var command: ExecutableCommand?
    var currentDirection: Direction?
    
    func execute(command cmd: ExecutableCommand) -> CGPoint? {
        command = cmd // assign the cmnd to the robot's property
        switch cmd.type {
        case .Move:
            move()
        case .Left:
            left()
        case .Right:
            right()
        case .Report:
            return report()
        case .Place:
            place()
        default:
           print("Invalid move")
        }
        return nil
    }
    
    func report () -> CGPoint? {
        return location
    }
    
    func left() {
    }
    func right() {
        
    }
    func move() {
        location = newLocationAfterImplementingMovement()
    }
    func place() {
        location = command?.point
        currentDirection = command?.f
        hasBeenPlaced = true
    }
    
    func newLocationAfterImplementingMovement() -> CGPoint?{
        
        if let direction = currentDirection {
            var x = 0, y = 0
            var currentLocation = location
            switch direction {
            case .N:
                x = 0
                y = 1
            case .S:
                x = 0
                y = -1
            case .W:
                x = -1
                y = 0
            case .E:
                x = 1
                y = 0
            }
            if let currentX = currentLocation?.x, let currentY = currentLocation?.y {
                currentLocation = CGPoint(x: Int(currentX)+x, y: Int(currentY)+y) //update the location
            }
            return currentLocation
        }
        
        return nil
    }
    
    // this function only simulates the movement of the given command and will robot will not move on its current place
    func simulateMovement (forCommand cmd: ExecutableCommand) -> CGPoint? {
        return newLocationAfterImplementingMovement()
    }

}
