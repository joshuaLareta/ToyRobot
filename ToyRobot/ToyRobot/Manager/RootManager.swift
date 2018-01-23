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
    var responseString: String?
    var isValid: Bool = false
}

class RootManager: NSObject {
    var currentTable: Table?
    var robot: Robot?
    lazy var commands: Commands = {
        let tempCommand = Commands()
        return tempCommand
    }()
    
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
    
    //MARK: Private functions
    // add a robot when needed
    private func add(aRobot robot: Robot) {
        self.robot = robot
    }
    
    private func validateExecutableCommand (command cmd: ExecutableCommand) -> Error?{
        // check if the command is a move
        if robot?.hasBeenPlaced == true || cmd.type == .Place{
            if cmd.type == .Move {
                // lets check the robots location
                if let newLocation = robot?.simulateMovement(forCommand: cmd){
                    // has a valid location
                    if currentTable?.isWithInThisTable(newLocation) == false {
                        return ToyRobotError.error(withCode: 400, andLocalizedErrorMessage: NSLocalizedString("Move command will put the robot out of bounds.\n Please try again", comment: "Out of bounds error"))
                    }
                }
            }
            return nil
        }
        
        return ToyRobotError.error(withCode: 400, andLocalizedErrorMessage: NSLocalizedString("Robot not yet placed", comment: "no proper move as robot is not yet initialized"))
    }
    
    //MARK: Public functions
    // function that executes a given command and then calls the callback if done
    // everything is a synchronous call
   public func executeCommand (_ command: String?, _ completedExecutionCallback: ((_ response: ManagerResponse?, _ error: Error?)->Void)?) {
        
        var error: Error? = nil
        var response: ManagerResponse? = nil
        
        // check if the command is not nil when whitespace and new lines are removed from it
        if let commandString = command?.trimmingCharacters(in: .whitespacesAndNewlines), commandString.isEmpty == false {
            // process the commandString if its a valid command for the robot
            let cmd = commands.process(command: commandString)
            
            if cmd.type != Command.Invalid {
                if cmd.type == .Place || robot == nil {
                    add(aRobot: Robot()) // just initialize a robot if it not yet there
                }

                // cmd is a valid command need to check if it implemented with the robot's current location it will not be out of bounds
                // command is not invalid lets check if its within the bound of the table
                error =  validateExecutableCommand(command: cmd)
                if error == nil {
                    if let robotResponse = self.robot?.execute(command: cmd) {
                        // if it has a response it means a report was issued and need to be handled properly
                        let stringResponse = NSLocalizedString("current position of th robot is at \(robotResponse.x,robotResponse.y, robot?.currentDirection?.rawValue)", comment: "the report response")
                        response = ManagerResponse(shouldBeDisplayed: true, responseString: stringResponse, isValid: true)
                    } else {
                        response = ManagerResponse(shouldBeDisplayed: false, responseString: nil, isValid: true)
                    }
                    // if there is no error proceed with the robot command
                }
            }else {
                error = ToyRobotError.error(withCode: 400, andLocalizedErrorMessage: NSLocalizedString("Invalid Command.\n Please Try again", comment: "The input command was invalid error"))
            }
            
        } else {
            // no command after removing whitespace and new line, generate an error
            error = ToyRobotError.error(withCode: 404, andLocalizedErrorMessage: NSLocalizedString("No commands found", comment: "error description"))
        }
        
        // check if completion block is nil, if it is not continue to call it
        if let callback = completedExecutionCallback {
            callback(response, error)
        }
    }
}
