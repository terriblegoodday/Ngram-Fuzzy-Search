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
        let ngrams: [Ngram] = stride(from: 0, to: stringCount - 2, by: 1).map {
            let lowerBound = String.Index.init(utf16Offset: $0, in: stringRepresentation)
            let upperBound = String.Index.init(utf16Offset: $0+3, in: stringRepresentation)
            return String(stringRepresentation[lowerBound..<upperBound])
        }
        return ngrams
    }()
    
    init(_ string: String) {
        stringRepresentation = string
    }
    
    convenience init(withSubstring substring: Substring) {
        self.init(String(substring))
    }
}

class RatedWord: Word {
    private(set) var rating: Double
    
    let intersectionCount: Int
    let unionCount: Int
    
    init(_ string: String, with rating: Double, intersectionCount: Int, unionCount: Int) {
        self.rating = rating;
        self.intersectionCount = intersectionCount
        self.unionCount = unionCount
        super.init(string)
    }
    
    init(_ word: Word, with rating: Double, intersectionCount: Int, unionCount: Int) {
        self.rating = round(rating*100)/100
        self.intersectionCount = intersectionCount
        self.unionCount = unionCount
        super.init(word.stringRepresentation)
    }
}

class Dictionary: NSObject, FuzzySearchable {
    
    override var description: String {
        return "\(filename) \n\(text)"
    }
    
    let filename: String
    let text: String
    lazy var ngrams: NgramsDict = {
        var ngrams: [Ngram: [Word]] = [:]
        for substring in text.split(separator: " ") {
            let word = Word(substring.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "\n", with: ""))
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
