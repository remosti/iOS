//
//  LeaderboardViewController_Tests.swift
//  Music Cover Quiz
//
//  Created by Remo Stirnimann on 12.12.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import XCTest
@testable import Music_Cover_Quiz


class LeaderboardViewController_Tests: XCTestCase {
    
    let FILENAME = "leaders.xml"
    var board = LeaderboardViewController()
    
    override func setUp() {
        let fileManager = FileManager.default
        let appPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = appPath.appendingPathComponent(FILENAME)
        if fileManager.fileExists(atPath: "\(filePath)"){
            do{
                try fileManager.removeItem(at: filePath)
            }catch let error as NSError{
                print(error.debugDescription)
            }
        }
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func getFileContent() -> [String]{
        let appPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = appPath.appendingPathComponent(FILENAME)
        let data = NSArray(contentsOf: filePath)
        return data as! [String]
    }
    
    func testSaveNewPlayerScore(){
        board.saveNewPlayerScore(name: "demo", points: 3)
        assert(getFileContent().contains("demo;3"))
    }
    
    func testSortLeaderboard(){
        assert(true)
        // TO BE IMPLEMENTED
    }
    
    func testLoadLeaderBoard(){
        assert(true)
        //TO BE IMPLEMENTED
    }
    
    func testStoreLeaderBoard(){
        assert(true)
        //TO BE IMPLEMENTED
    }
}
