//
//  FuzzySearchViewController.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 7/7/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Cocoa

class FuzzySearchViewController: NSViewController {
    var currentDictionary: Dictionary?
    var ratedResults: [String : FuzzySearch.RatedResults] = [:]
    @IBOutlet var searchField: NSSearchField!
    @IBOutlet var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.dictionaryRepository.subscribe(self)
    }


    @IBAction func performSearch(_ sender: Any) {
        ratedResults.removeAll()
        let messageText = "Ошибка при выполнении поиска"
        if tableView.selectedRow == -1 {
            let alert = NSAlert()
            alert.messageText = messageText
            alert.informativeText = "Не выбрана метрика."
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            return
        }
        if searchField.stringValue.isEmpty {
            let alert = NSAlert()
            alert.messageText = messageText
            alert.informativeText = "Не введен поисковый запрос."
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            return
        }
        let currentDictionary = appDelegate.dictionaryRepository.dictionary(at: tableView.selectedRow)
        let metrics: [Metric] = [
            QGrams(),
            JacardDistance(),
            CosineDistance(),
            TverskyIndex()
        ]
        let searchResults = FuzzySearch.search(in: currentDictionary, query: searchField.stringValue)
        metrics.forEach { (metric) in
            ratedResults[metric.description] = searchResults.rate(by: metric)
        }
        performSegue(withIdentifier: "showResults", sender: self)
    }
    
    @IBSegueAction func instantiateResultsViewController(_ coder: NSCoder, sender: Any?) -> ResultsViewController? {
        let resultsViewController = ResultsViewController(coder: coder)
        resultsViewController?.results = ratedResults
        return resultsViewController
    }
    
    
    @IBAction func refreshDictionaries(_ sender: Any) {
        appDelegate.dictionaryRepository.refresh()
    }
    
    @IBSegueAction func showDictionaryText(_ coder: NSCoder, sender: Any?) -> DictionaryViewController? {
        let dictionaryViewController = DictionaryViewController(coder: coder)
        dictionaryViewController?.dictionary = currentDictionary!
        return dictionaryViewController
    }
}

extension FuzzySearchViewController: DictionaryRepositorySubscriber {
    func operationInProgress(in repository: DictionaryRepository) {
        return
    }
    
    func operationSuccess(in repository: DictionaryRepository) {
        return
    }
    
    func receiveUpdate(from repository: DictionaryRepository) {
        tableView.reloadData()
    }
    
    
}

extension FuzzySearchViewController: DictionaryCellDelegate {
    func showDictionary(for cell: DictionaryCell) {
        currentDictionary = appDelegate.dictionaryRepository.dictionary(at: tableView.row(for: cell))
        performSegue(withIdentifier: "showDictionaryText", sender: self)
    }
    
    
}

extension FuzzySearchViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return appDelegate.dictionaryRepository.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DictionaryCell"), owner: self) as? DictionaryCell else {
            return nil
        }
        cell.delegate = self
        cell.textField?.stringValue = appDelegate.dictionaryRepository.dictionary(at: row).filename
        return cell
    }
}
