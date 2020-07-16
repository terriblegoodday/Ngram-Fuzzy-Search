//
//  Array+RandomItem.swift
//  MarkovChain
//
//  Created by Diana Komolova on 19/10/2017.
//  Copyright © 2017 Diana Komolova. All rights reserved.
//

import Foundation
import Cocoa

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension Array where Element: StringProtocol {
    func combinations(size: Int, allowDuplicates: Bool = true) -> [String] {
        let n = count

        var combinations: [String] = []

        var indices = [0]

        var i = 0

        while true {
            // build out array of indexes (if not complete)

            while indices.count < size {
                i = indices.last! + (allowDuplicates ? 0 : 1)
                if i < n {
                    indices.append(i)
                }
            }

            // add combination associated with this particular array of indices
            if combinations.count < size {
                combinations.append(indices.map { self[$0] }.joined())
            } else {
                return combinations
            }

            // prepare next one (incrementing the last component and/or deleting as needed

            repeat {
                if indices.count == 0 { return combinations }
                i = indices.last! + 1
                indices.removeLast()
            } while i > n - (allowDuplicates ? 1 : (size - indices.count))
            indices.append(i)
        }
    }
}

extension NSViewController {
    var appDelegate: AppDelegate {
    return NSApplication.shared.delegate as! AppDelegate
   }
}

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}
