//
//  ToyRobotError.swift
//  ToyRobot
//
//  Created by Joshua on 24/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation

class ToyRobotError: Error {
    static let domainError = "com.coffeeforthewicked"
    
    static func error(withCode errorCode: Int, andLocalizedErrorMessage errorMessage: String?) -> Error {
        return NSError(domain: ToyRobotError.domainError, code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage ?? "Unknown Error"])
    }
}
