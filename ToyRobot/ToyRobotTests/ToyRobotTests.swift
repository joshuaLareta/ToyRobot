//
//  ToyRobotTests.swift
//  ToyRobotTests
//
//  Created by Joshua on 23/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import XCTest
@testable import ToyRobot

class ToyRobotTests: XCTestCase {

    var manager: RootManager? = {
        let tempManager = RootManager(withTable:Table(minX: 0, minY: 0, maxX: 5, maxY: 5) )
        return tempManager
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        manager = nil
    }
    
    func testValidExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let inputList: [String] = ["Place 1,2,East", "Move","Move","left","Move","Report"]
        for input in inputList {
            manager?.executeCommand(input, { (response, error) in
                if response?.shouldBeDisplayed == true {
                    XCTAssert(response?.responseString == "current position of the robot is at\n3, 3, NORTH")
                }
            })
        }
    }
    func testPlaceAndMoveThenReport() {
        let inputList: [String] = ["Place 0,0,North","Move","Report"]
        for input in inputList {
            manager?.executeCommand(input, { (response, error) in
                if response?.shouldBeDisplayed == true {
                    XCTAssert(response?.responseString == "current position of the robot is at\n0, 1, NORTH")
                }
            })
        }
    }
    
    func testPlaceOutOfBound() {
        let inputList: [String] = ["Place -1,0,North"]
        for input in inputList {
            manager?.executeCommand(input, { (response, error) in
                XCTAssert(error?.localizedDescription == "Command will put the robot out of bounds.\n Please try again")
            })
        }
    }
    
    func testMoveOutOfBounds() {
        let inputList: [String] = ["Place 0,3,North","Move","Move","Move"]
        var hasHitObjective = false
        for input in inputList {
            manager?.executeCommand(input, { (response, error) in
                if error != nil {
                    XCTAssert(error?.localizedDescription == "Command will put the robot out of bounds.\n Please try again")
                    hasHitObjective = true
                }
            })
        }
        if hasHitObjective == false{
            XCTFail() // force to fail as it didnt hit our checking
        }
    }
    
    func testInvalidCommand() {
        let inputList: [String] = ["Places -1,0,North"]
        for input in inputList {
            manager?.executeCommand(input, { (response, error) in
                XCTAssert(error?.localizedDescription == "Invalid Command.\n Please Try again")
            })
        }
    }
    
    func testRobotNotPlaced() {
        let inputList: [String] = ["Move"]
        for input in inputList {
            manager?.executeCommand(input, { (response, error) in
                XCTAssert(error?.localizedDescription == "Robot not yet placed")
            })
        }
    }
    
    func testInvalidCommandInTheMiddleOfTheExecution() {
        let inputList: [String] = ["Place 0,0,North","Move","Move","Left","turn"]
        for input in inputList {
            manager?.executeCommand(input, { (response, error) in
                if error != nil{
                    XCTAssert(error?.localizedDescription == "Invalid Command.\n Please Try again")
                }
            })
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
}
