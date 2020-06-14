
//
//  DictionaryTest.swift
//  NGram-FuzzySearchTests
//
//  Created by Eduard Dzhumagaliev on 6/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Foundation

extension Word {
    func getStringRepr() -> String {
        return stringRepresentation
    }
}

extension Dictionary {
    func testDictEquality(_ dictionary: [String: [String]]) -> Bool {
        var ngramsDict: [String: [String]] = [:]
        
        for ngram in ngrams {
            for word in ngram.value {
                ngramsDict[ngram.key, default: []].append(word.getStringRepr())
            }
        }
        
        return ngramsDict == dictionary
    }
}


