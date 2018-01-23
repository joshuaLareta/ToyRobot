//
//  RootManager.swift
//  ToyRobot
//
//  Created by Joshua on 23/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation

struct ManagerResponse {
    var shouldBeDisplayed: Bool = false
    var responseString: String
}

class RootManager: NSObject {
    var currentTable: Table?
    var robot: Robot?
    
    // initialize rootManager with a given table
    init(withTable table: Table?) {
        currentTable = table
    }
    
    override init() { // initialize everything as nil
        currentTable = nil
        robot = nil
    }
    
    
    deinit {
        print("de initializing RootManager")
    }
    
    
    // function that executes a given command and then calls the callback if done
    // everything is a synchronous call
    func executeCommand (_ command: String?, _ completedExecutionCallback: ((_ response: ManagerResponse?, _ error: Error?)->Void)?) {
        
        
    }
    
    
    // add a robot when needed
    private func add(aRobot robot: Robot) {
        self.robot = robot
    }
}
