//
//  NGram_FuzzySearchTests.swift
//  NGram-FuzzySearchTests
//
//  Created by Eduard Dzhumagaliev on 6/10/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import XCTest
@testable import NGram_FuzzySearch

class NGram_FuzzySearchTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDictionary() {
        let exampleText = "lorem"
        let testDictionary = Dictionary(withFilename: "exampleFile.txt", andText: exampleText)
        XCTAssert(testDictionary.testDictEquality(["lor" : ["lorem"], "ore" : ["lorem"], "rem" : ["lorem"]]))
    }
    
    func testDictionaryComplex() {
        let exampleText = "lorem ipsum dolor sit amet"
        let testDictionary = Dictionary(withFilename: "exampleFile.txt", andText: exampleText)
        let shouldEqualTo = [
            "lor": ["lorem", "dolor"],
            "ore": ["lorem"],
            "rem": ["lorem"],
            "ips": ["ipsum"],
            "psu": ["ipsum"],
            "sum": ["ipsum"],
            "dol": ["dolor"],
            "olo": ["dolor"],
            "sit": ["sit"],
            "ame": ["amet"],
            "met": ["amet"]
        ]
        XCTAssert(testDictionary.testDictEquality(shouldEqualTo))
    }
    
    func testRawSearch() {
        let exampleText = "триграмма нграмма графика грамм граммовка триграфика грвмм"
        let testDictionary = Dictionary(withFilename: "exampleFile.txt", andText: exampleText)
        let searchResults = FuzzySearch.search(in: testDictionary, query: "биграмма")
        XCTAssert(searchResults.description == "[грамм, граммовка, графика, нграмма, триграмма, триграфика, ]")
    }
}
