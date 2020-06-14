//
//  Dictionary.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 6/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Cocoa

typealias Ngram = String
typealias NgramsDict = [Ngram: [Word]]


class Word: NSObject {
    let stringRepresentation: String
    
    lazy var ngrams: [Ngram] = {
        let stringCount = self.stringRepresentation.count
        return stride(from: 0, to: stringCount - 2, by: 1).map {
            let lowerBound = String.Index.init(utf16Offset: $0, in: stringRepresentation)
            let upperBound = String.Index.init(utf16Offset: $0+3, in: stringRepresentation)
            return String(stringRepresentation[lowerBound..<upperBound])
        }
    }()
    
    init(_ string: String) {
        stringRepresentation = string
    }
    
    convenience init(withSubstring substring: Substring) {
        self.init(String(substring))
    }
}

class Dictionary: NSObject, FuzzySearchable {
    let filename: String
    let text: String
    lazy var ngrams: NgramsDict = {
        var ngrams: [Ngram: [Word]] = [:]
        for substring in text.split(separator: " ") {
            let word = Word(withSubstring: substring)
            for ngram in word.ngrams {
                ngrams[ngram, default: []].append(word)
            }
        }
        return ngrams
    }()
    
    init(withFilename filename: String, andText text: String) {
        self.filename = filename
        self.text = text
    }
}
