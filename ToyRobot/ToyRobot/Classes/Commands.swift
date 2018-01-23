//
//  Commands.swift
//  ToyRobot
//
//  Created by Joshua on 23/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation
import UIKit

// Methods needed for conforming to the protocol
protocol CommandProtocol {
    func move()
    func left()
    func right()
    func place()
    func report() -> CGPoint?
}

// Valid commands
enum Command {
    case Move
    case Left
    case Right
    case Report
    case Place
    case Invalid
}

enum Direction: String {
    case N = "NORTH"
    case S = "SOUTH"
    case W = "WEST"
    case E = "EAST"
}

struct ExecutableCommand {
    let type: Command
    let point: CGPoint?
    let f: Direction?
}

// Checks if all the given commands are valid, but it does not check if commands already exceeding the given table bounds
struct Commands {
    
    // process the command and return the proper method to use
    func process (command cmd: String) -> ExecutableCommand {
        
            switch cmd.uppercased() {
            case "MOVE":
                return ExecutableCommand(type: Command.Move, point: nil, f:nil)
            case "LEFT":
                return ExecutableCommand(type: Command.Left, point: nil, f:nil)
            case "RIGHT":
                return ExecutableCommand(type: Command.Right, point: nil, f:nil)
            case "REPORT":
                return ExecutableCommand(type: Command.Report, point: nil, f:nil)
            default: // it can either be a place command or an invalid one
                // lets try to tokenize the cmd
                let commandToken = cmd.components(separatedBy: " ")
                if commandToken.count == 2{ // there should only be 2 token PLACE and x,y,f values
                    if let checkCmd = commandToken.first, checkCmd.uppercased() == "PLACE" {
                        // first token cmd is valid check for second token
                        // second token should be 3 token consisting of x and y coordinate plus the initial direction
                        if let checkDirectionToken = commandToken.last?.components(separatedBy: ","), checkDirectionToken.count == 3 {
                            if let x = Int(checkDirectionToken[0]), let y = Int(checkDirectionToken[1]), let f = checkDirectionToken.last{
                                // lets check the direction
                                let initialDirection = Direction(rawValue: f.uppercased())
                                guard initialDirection != nil else {
                                    print ("invalid direction")
                                    return ExecutableCommand(type: Command.Invalid, point: nil, f:nil)
                                }
                                // return the initial place
                                return ExecutableCommand(type: Command.Place, point: CGPoint(x:x, y:y), f: initialDirection)
                            }
                        }
                    }
                }
            }
        // return an invalid command
        return ExecutableCommand(type: Command.Invalid, point: nil, f:nil)
    }
}
