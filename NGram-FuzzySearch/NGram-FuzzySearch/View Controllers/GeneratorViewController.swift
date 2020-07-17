//
//  GeneratorViewController.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 7/7/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Cocoa

class GeneratorViewController: NSViewController {

    @IBOutlet var seedWord: NSTextField!
    @IBOutlet var numberOfErrors: NSTextField!
    @IBOutlet var lengthVariation: NSTextField!
    
    
    override func viewWillAppear() {
        appDelegate.dictionaryRepository.subscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        appDelegate.dictionaryRepository.unsubscribe(self)
    }
    
    @IBAction func generateText(_ sender: Any) {
        let messageText = "Ошибка в вводных данных"
        if seedWord.stringValue == "" {
            let alert = NSAlert()
            alert.messageText = messageText
            alert.informativeText = "Не введено слово, из которого будет генерироваться словарь."
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            return
        }
        
        if numberOfErrors.integerValue < 0 {
            let alert = NSAlert()
            alert.messageText = messageText
            alert.informativeText = "Отрицательное количество ошибок."
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            return
        }
        
        if lengthVariation.integerValue < 0 {
            let alert = NSAlert()
            alert.messageText = messageText
            alert.informativeText = "Отрицательная вариация длины слова."
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            return
        }
        
        let errors = numberOfErrors.integerValue
        let seed = seedWord.stringValue
        let variation = lengthVariation.integerValue
        
        let generator = Generator(from: Word(seed))
        let dictionary = generator.generate(errors, lengthVariation: variation)
        
        appDelegate.dictionaryRepository.add(dictionary, completionHandler: operationSuccess(in:))
        print(appDelegate.dictionaryRepository.count)
    }
}

extension GeneratorViewController: DictionaryRepositorySubscriber {
    func operationInProgress(in repository: DictionaryRepository) {
        performSegue(withIdentifier: "inProgress", sender: self)
    }
    
    func operationSuccess(in repository: DictionaryRepository) {
        let alert = NSAlert()
        alert.messageText = "Успешно сгенерирована последовательность"
        alert.informativeText = "Теперь в репозитории словарей хранится \(repository.count) словарей."
        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
    }
    
    func receiveUpdate(from repository: DictionaryRepository) {
        print("")
    }
}
