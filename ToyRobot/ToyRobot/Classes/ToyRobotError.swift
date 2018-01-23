//
//  ToyRobotError.swift
//  ToyRobot
//
//  Created by Joshua on 24/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation
enum ErrorCode: Int {
    case badRequest = 400
    case outOfBound = -50
    case notPlaced = -51
    case noCommands = -52
    case unknown = -1
    
    func string () -> String {
        
        switch self {
        case .badRequest:
            return NSLocalizedString("Invalid Command.\n Please Try again", comment: "Invalid command error or a bad request")
        case .outOfBound:
            return  NSLocalizedString("Command will put the robot out of bounds.\n Please try again", comment: "Out of bounds error")
        case .notPlaced:
            return NSLocalizedString("Robot not yet placed", comment: "no proper move as robot is not yet initialized")
        case .noCommands:
            return  NSLocalizedString("No commands found", comment: "error description")
        case .unknown:
            return NSLocalizedString("Unkown error", comment: "an unknown error")
        }
        
    }
}
class ToyRobotError: Error {
    static let domainError = "com.coffeeforthewicked"
    
    static func error(withCode errorCode: ErrorCode) -> Error {
        return NSError(domain: ToyRobotError.domainError, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: errorCode.string()])
    }
}
