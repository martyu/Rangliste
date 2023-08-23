//
//  RanglisteTests.swift
//  RanglisteTests
//
//  Created by Marty Ulrich on 8/21/23.
//

import XCTest
@testable import Rangliste

final class RanglisteTests: XCTestCase {
    func testExample() throws {
		let mock = MockData()
		print(mock.ageGroups)
		print(mock.names)
		print(mock.schwingers)
		print(mock.schwingfest)
		print(mock.schwingfestNames)
		print(mock.schwingfests)
		print(mock.scorecards)
    }
}
