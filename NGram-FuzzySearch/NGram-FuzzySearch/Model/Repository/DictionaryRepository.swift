//
//  DictionaryRepository.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 7/7/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Foundation

protocol DictionaryRepositorySubscriber: class {
    func operationInProgress(in repository: DictionaryRepository)
    func operationSuccess(in repository: DictionaryRepository)
    func receiveUpdate(from repository: DictionaryRepository)
}

protocol DictionaryRepository: class {
    func subscribe(_ subscriber: DictionaryRepositorySubscriber)
    func unsubscribe(_ subscriber: DictionaryRepositorySubscriber)
    func refresh()
    func add(_ dictionary: Dictionary, completionHandler sendComplete: @escaping (DictionaryRepository) -> Void?)
    func dictionary(at index: Int) -> Dictionary
    var count: Int { get }
}

class DictionaryPersistentStore: NSObject, DictionaryRepository {
    private lazy var subscribers = [DictionaryRepositorySubscriber]()
    
    private var dictionaries: [Dictionary] = []
    
    private let subdirectory = "Dictionaries"
    
    func subscribe(_ subscriber: DictionaryRepositorySubscriber) {
        print("Subject: Attached an observer.\n")
        subscribers.append(subscriber)
    }

    func unsubscribe(_ subscriber: DictionaryRepositorySubscriber) {
        if let idx = subscribers.firstIndex(where: { $0 === subscriber }) {
            subscribers.remove(at: idx)
            print("Subject: Detached an observer.\n")
        }
    }
    
    private func text(at path: String) -> String {
        do {
            let fileContents = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let filtered = fileContents.replacingOccurrences(of: "\\\n", with: " ")
            return filtered
        } catch let error {
            print(error.localizedDescription)
            return ""
        }
    }
    
    private func getFileUrls() -> [URL]? {
        return FileManager.default.urls(for: .documentDirectory)
    }
    
    private func write(dictionary: Dictionary) {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileURL = documentsDirectory.appendingPathComponent("\(dictionary.filename).rtf")
            do {
                try dictionary.text.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendUpdates() {
        subscribers.forEach { (subscriber) in
            subscriber.receiveUpdate(from: self)
        }
    }
    
    func refresh() {
        dictionaries.removeAll()
        
        if let urls = getFileUrls() {
            for url in urls {
                url.startAccessingSecurityScopedResource()
                let dictionary = Dictionary(withFilename: url.lastPathComponent, andText: text(at: url.path))
                dictionaries.append(dictionary)
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        sendUpdates()
    }
    
    func add(_ dictionary: Dictionary, completionHandler sendComplete: @escaping (DictionaryRepository) -> Void?) {
        dictionaries.append(dictionary)
        write(dictionary: dictionary)
        refresh()
        sendComplete(self)
    }
    
    func dictionary(at index: Int) -> Dictionary {
        return dictionaries[index]
    }
    
    override init() {
        super.init()
        self.refresh()
    }
    
    var count: Int {
        get {
            return dictionaries.count
        }
    }
}
