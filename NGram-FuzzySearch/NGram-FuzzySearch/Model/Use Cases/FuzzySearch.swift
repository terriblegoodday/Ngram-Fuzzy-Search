//
//  FuzzySearchable.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 6/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Cocoa

protocol FuzzySearchable {
    var ngrams: NgramsDict {
        get
    }
}

class FuzzySearch {
    
    class SearchResults: CustomStringConvertible {
        let query: Word
        let words: Set<Word>
        
        private static let noMaxDistance: Double = -1
        
        var description: String {
            var desc: String = "["
            for word in words.sorted(by: { (left, right) -> Bool in
                left.stringRepresentation < right.stringRepresentation
            }) {
                desc += word.stringRepresentation + ", "
            }
            desc += "]"
            return desc
        }
        
        fileprivate init(withWords words: Set<Word>, and query: Word) {
            self.query = query
            self.words = words
        }
        
        func rate(by metric: Metric, maxDistance: Double = noMaxDistance) -> RatedResults {
            
            
            let ratedResults = Array.init(self.words).map { (currentWord) -> RatedWord in
                let (distance, intersectionCount, unionCount) = metric.execute(word1: currentWord, word2: query)
                return RatedWord(currentWord, with: distance, intersectionCount: intersectionCount, unionCount: unionCount)
            }
            
            return RatedResults(withWords: ratedResults, query: query, metric: metric)
        }
    }
    
    class RatedResults: CustomStringConvertible {
        var description: String {
            var desc: String = "$$$ \(self.metricDescription) $$$["
            for word in words.sorted(by: { (left, right) -> Bool in
                left.rating < right.rating
            }) {
                desc += "\(word.stringRepresentation) : \(word.rating), "
            }
            desc += "]"
            return desc
        }
        
        let query: Word
        let words: [RatedWord]
        let metricDescription: String
        private(set) var intersectionCount: Int
        private(set) var unionCount: Int

        
        fileprivate init(withWords words: [RatedWord], query: Word, metric: Metric) {
            self.query = query
            self.words = words
            
            self.intersectionCount = 0
            self.unionCount = 0
            
            for word in words {
                self.intersectionCount += word.intersectionCount
                self.unionCount += word.unionCount
            }
            
            self.metricDescription = metric.description
        }
    }
        
    static func search(in dictionary: FuzzySearchable, query: Word) -> SearchResults {
        var words: Set<Word> = []
        for ngram in dictionary.ngrams {
            for word in ngram.value {
                let setA = Set(query.ngrams)
                let setB = Set(word.ngrams)
                if !setA.intersection(setB).isEmpty {
                    words.insert(word)
                }
            }
        }
        return SearchResults(withWords: words, and: query)
    }
    
    static func search(in dictionary: FuzzySearchable, query: String) -> SearchResults {
        return search(in: dictionary, query: Word(query))
    }
}
