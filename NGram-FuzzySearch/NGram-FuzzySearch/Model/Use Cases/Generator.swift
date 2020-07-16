//
//  Generator.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 7/6/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Cocoa

protocol GeneratorDelegate {
    func operationInProgress()
    func operationDidFinish()
}

class Generator {
    
    private let word: Word
    var delegate: GeneratorDelegate?
    
    private var busyIndices = Set<Int>()
    
    init(from word: Word) {
        self.word = word
    }
    
    private func generateWithErrors() -> Word {
        var rawWord = word.stringRepresentation
        let index = Int.random(in: 0..<rawWord.count)
        
        if busyIndices.count == rawWord.count {
            
        } else if busyIndices.contains(index) {
            return generateWithErrors()
        } else {
            busyIndices.insert(index)
        }
        
        let randomIndexL = String.Index(utf16Offset: index, in: rawWord)
        let randomIndexU = String.Index(utf16Offset: index + 1, in: rawWord)
            
        rawWord.replaceSubrange(randomIndexL..<randomIndexU, with: String(Character(UnicodeScalar(Int.random(in: 32...74))!)))
        
        return Word(rawWord)
    }

    
    func generate(_ errors: Int = 3, lengthVariation: Int = 3) -> Dictionary {
        var wordsWithErrors = Set<Word>()
        wordsWithErrors.insert(word)
        
        if lengthVariation != 0 {
            for i in 1...lengthVariation {
                wordsWithErrors.insert(Word(String(word.stringRepresentation.suffix(from: String.Index(utf16Offset: i, in: word.stringRepresentation)))))
                var wordToAppend = word.stringRepresentation
                for _ in 1...i {
                    let randomChar = Character(UnicodeScalar(Int.random(in: 32...74))!)
                    wordToAppend = String(randomChar) + wordToAppend
                }
                wordsWithErrors.insert(Word(wordToAppend))
            }
        }
        
        while wordsWithErrors.count < errors + 1 + lengthVariation*2*2*errors {
            let generatedWord = generateWithErrors()
            let generatedString = generatedWord.stringRepresentation
            wordsWithErrors.insert(generatedWord)
            if lengthVariation != 0 {
                for i in 1...lengthVariation {
                    wordsWithErrors.insert(Word(String(generatedString.suffix(from: String.Index(utf16Offset: i, in: generatedString)))))
                    var wordToAppend = generatedWord.stringRepresentation
                    for _ in 1...i {
                        let randomChar = Character(UnicodeScalar(Int.random(in: 32...74))!)
                        wordToAppend = String(randomChar) + generatedString
                    }
                    wordsWithErrors.insert(Word(wordToAppend))
                }
            }
        }
        
        return Dictionary(withFilename: "\(word.stringRepresentation).\(errors).\(lengthVariation)", andText: wordsWithErrors.map({ (currentWord) -> String in
            currentWord.stringRepresentation
            }).joined(separator: " "))
    }
    
}
