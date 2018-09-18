//
//  WDemoTests.swift
//  WDemoTests
//
//  Created by wyj on 2018/9/14.
//  Copyright © 2018 Alex. All rights reserved.
//

import XCTest
@testable import WDemo

class WDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchCarList() {
        let expect = self.expectation(description: "fetch car list")
        SwiftNetworkCenter.downloadFile(successBlock: {
            expect.fulfill()
            print("Unit Test Success")
        }) { (error) in
            XCTFail("Get Data Fail")
        }
        waitForExpectations(timeout: 10) { (error) in
            if error != nil {
                XCTFail("Get Data Timeout")
                print("Time out")
            }
        }
    }
    
    //After finish testFetchCarList()
    func testSearchCoreData () {
        let carList = DBHelp.shared.searchWithName(modelName: "CarEntity")
        if carList.count <= 0 {
            XCTFail("Date is null")
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
