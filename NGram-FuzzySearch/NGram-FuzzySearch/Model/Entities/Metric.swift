//
//  Metric.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 7/5/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Foundation

protocol Metric {
    func execute(word1: Word, word2: Word) -> (rating: Double, intersectionCount: Int, unionCount: Int);
    
    var description: String { get }
}

protocol VectorMixin {
    func dot(_ a: [Double], _ b: [Double]) -> Double
    func magnitude(_ a: [Double]) -> Double
}

extension VectorMixin {
    func dot(_ a: [Double], _ b: [Double]) -> Double {
        var x: Double = 0
        for i in 0...a.count-1 {
            x += a[i] * b[i]
        }
        return x
    }
    
    func magnitude(_ a: [Double]) -> Double {
        var x: Double = 0
        for coordinate in a {
            x += coordinate * coordinate
        }
        return sqrt(x)
    }
    
    func vectorSimilarity(_ vector1: [Double], _ vector2: [Double]) -> Double {
        return round(1000 * dot(vector1, vector2)/(magnitude(vector1) * magnitude(vector2))) / 1000
    }
}

class QGrams: Metric {
    var description = "QGrams Metric"
    
    func execute(word1: Word, word2: Word) -> (rating: Double, intersectionCount: Int, unionCount: Int) {
        let ngramIntersection = Set(word1.ngrams).intersection(Set(word2.ngrams))
        let intersectionCount = ngramIntersection.count
        if word1.stringRepresentation == word2.stringRepresentation {
            print(ngramIntersection)
            print(word2.ngrams.count)
            print(word1.ngrams.count)
            print(intersectionCount)
        }
        
        let disagreement = Double(max(Set(word1.ngrams).count, Set(word2.ngrams).count) - intersectionCount)
        let total = Double(max(Set(word1.ngrams).count, Set(word2.ngrams).count))+Double(intersectionCount)
        
        return (rating: Double(
            disagreement/total
        ), intersectionCount: intersectionCount, unionCount: 0)
    }
}

class CosineDistance: Metric, VectorMixin {
    var description = "Cosine Distance Metric"
    
    func execute(word1: Word, word2: Word) -> (rating: Double, intersectionCount: Int, unionCount: Int) {
        let multiplier = 1.0
        
        let gramUnion = Array(Set(word1.ngrams).union(Set(word2.ngrams))).sorted()
        print("🏀 \(gramUnion)")
        let gramCount = gramUnion.count
                
        var grams1 = Array(repeating: 0.0, count: gramCount)
        var grams2 = Array(repeating: 0.0, count: gramCount)
        
        for i in 0..<gramCount {
            if word1.ngrams.contains(gramUnion[i]) {
                grams1[i] = 1.0
            }
            if word2.ngrams.contains(gramUnion[i]) {
                grams2[i] = 1.0
            }
        }
        print("🏀 \(grams1)")
        print("🏀 \(grams2)")
        let gramSimilarity = vectorSimilarity(grams1, grams2)
        return (rating: multiplier * (1 - gramSimilarity), intersectionCount: 0, unionCount: gramCount)
    }
}

class JacardDistance: Metric {
    var description = "Jacard Distance Metric"
    
    func execute(word1: Word, word2: Word) -> (rating: Double, intersectionCount: Int, unionCount: Int) {
        let multiplier = 1.0
        
        let gramUnion = Set(word1.ngrams).union(Set(word2.ngrams))
        let gramIntersection = Set(word1.ngrams).intersection(Set(word2.ngrams))
        
        return (rating: multiplier * (1 - Double(gramIntersection.count) / Double(gramUnion.count)), intersectionCount: gramIntersection.count, unionCount: gramUnion.count)
    }
}

class TverskyIndex: Metric {
    var description = "Tversky Index Metric"
    
    func execute(word1: Word, word2: Word) -> (rating: Double, intersectionCount: Int, unionCount: Int) {
        let agreeTotal = Set(word1.ngrams).intersection(Set(word2.ngrams)).count
        let v1 = Set(word1.ngrams).count - agreeTotal
        let v2 = Set(word2.ngrams).count - agreeTotal
        
        let alpha = 4.0
        let beta = 0.5
        
        print(word1.ngrams)
        
        let balancedAgree1 = alpha*Double(v1)
        let balancedAgree2 = beta*Double(v2)
        
        return (rating: 1 - Double(agreeTotal)/(Double(agreeTotal)+balancedAgree1+balancedAgree2), intersectionCount: agreeTotal, unionCount: 0)
    }
}
