//
//  charging_notifsTests.swift
//  charging-notifsTests
//
//  Created by Carol Zhang on 2020-11-15.
//  Copyright © 2020 Carol Zhang. All rights reserved.
//

// https://www.raywenderlich.com/960290-ios-unit-testing-and-ui-testing-tutorial

import XCTest
@testable import charging_notifs

var sut: AppDelegate!

class charging_notifsTests: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
        sut = AppDelegate()
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testConstructMenu() throws {
        // given:
        let statusItem : NSStatusItem = {
            let item = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
            return item
        }()
        
        // when:
        sut.constructMenu(statusItem: statusItem)
        
        // then
        XCTAssertEqual(statusItem.menu?.numberOfItems, 6, "number of items in menu is wrong")
        XCTAssertEqual(sut.isMonitoring, false, "is monitoring is true")
    }
    
    func testStartMonitoring() throws {
        // given:
        sut.isMonitoring = false
        
        // when:
        sut.startMonitoring("")
        
        // then:
        XCTAssertEqual(sut.isMonitoring, true)
        
    }
    
    func testStopMonitoring() throws {
        // given:
        sut.isMonitoring = true
        
        // when:
        sut.stopMonitoring("")
        
        // then:
        XCTAssertEqual(sut.isMonitoring, false)
    }
    
    func testDeliverNotification() throws {
        //given:
        
        // when
        var notif = sut.deliverNotification("Title", message: "Message", isCharged: true)
        
        // then
        XCTAssertEqual(notif == nil, false)
        
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
