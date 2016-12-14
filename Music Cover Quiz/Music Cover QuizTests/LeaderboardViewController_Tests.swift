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
        let leader = [LeaderBoardEntry(name: "test", points: 3), LeaderBoardEntry(name: "test2", points: 5)]
        let sorted = board.sortLeaderBoard(toSort: leader)
        assert(sorted[0].points > sorted[1].points)
    }
    
    func testLoadStoreLeaderBoard(){
        let sollLeaderBoard = [LeaderBoardEntry(name: "test", points: 3), LeaderBoardEntry(name: "test2", points: 5)]
        board.leaderBoard = sollLeaderBoard
        board.storeLeaderBoard()
        
        board.leaderBoard = []
        board.leaderBoard = board.loadLeaderBoard()
        
        XCTAssertEqual(sollLeaderBoard[0].points, board.leaderBoard[1].points)
        XCTAssertEqual(sollLeaderBoard[0].name, board.leaderBoard[1].name)
        XCTAssertEqual(sollLeaderBoard[1].points, board.leaderBoard[0].points)
        XCTAssertEqual(sollLeaderBoard[1].name, board.leaderBoard[0].name)
    }
}
