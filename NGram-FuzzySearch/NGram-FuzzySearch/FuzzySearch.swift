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
        let words: Set<Word>
        
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
        
        init(withWords: Set<Word>) {
            words = withWords
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
        return SearchResults(withWords: words)
    }
    
    static func search(in dictionary: FuzzySearchable, query: String) -> SearchResults {
        return search(in: dictionary, query: Word(query))
    }
}
