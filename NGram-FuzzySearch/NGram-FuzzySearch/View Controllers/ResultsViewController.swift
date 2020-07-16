//
//  ResultsViewController.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 7/7/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Cocoa
import Charts

class ResultsViewController: NSViewController {
    
    let qgrams = "QGrams Metric"
    let cosineDistance = "Cosine Distance Metric"
    let jacardDistance = "Jacard Distance Metric"
    let tverskyIndex = "Tversky Index Metric"
    
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var chartView: BarChartView!
    @IBOutlet var percentView: BarChartView!
    
    var sortOrder: String
    var sortAscending: Bool
    
    struct WordWithRatings {
        let word: String
        let qgrams: Double
        let cosineDistance: Double
        let jacardDistance: Double
        let tverskyIndex: Double
    }
    
    func sortWordsByRating() {
        dataSource.sort { (left, right) -> Bool in
            if sortAscending {
                switch sortOrder {
                case qgrams:
                    return left.qgrams < right.qgrams
                case cosineDistance:
                    return left.cosineDistance < right.cosineDistance
                case jacardDistance:
                    return left.jacardDistance < right.jacardDistance
                case tverskyIndex:
                    return left.tverskyIndex < right.tverskyIndex
                default:
                    return left.qgrams < right.qgrams
                }
            } else {
                switch sortOrder {
                case qgrams:
                    return left.qgrams > right.qgrams
                case cosineDistance:
                    return left.cosineDistance > right.cosineDistance
                case jacardDistance:
                    return left.jacardDistance > right.jacardDistance
                case tverskyIndex:
                    return left.tverskyIndex > right.tverskyIndex
                default:
                    return left.qgrams > right.qgrams
                }
            }
        }
    }
    
    func reloadFileList() {
        sortWordsByRating()
        tableView.reloadData()
    }
    
    var results: [String : FuzzySearch.RatedResults?] = [:]
    var dataSource: [WordWithRatings] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dataEntries1 = [BarChartDataEntry]()
        var dataEntries2 = [BarChartDataEntry]()
        var dataEntries3 = [BarChartDataEntry]()
        var dataEntries4 = [BarChartDataEntry]()
        dataEntries1.append(BarChartDataEntry(x: 0, y: Double(results[qgrams]!!.intersectionCount)))
        dataEntries1.append(BarChartDataEntry(x: 1, y: Double(results[qgrams]!!.unionCount)))
        dataEntries2.append(BarChartDataEntry(x: 2, y: Double(results[tverskyIndex]!!.intersectionCount)))
        dataEntries2.append(BarChartDataEntry(x: 3, y: Double(results[tverskyIndex]!!.unionCount)))
        dataEntries3.append(BarChartDataEntry(x: 4, y: Double(results[cosineDistance]!!.intersectionCount)))
        dataEntries3.append(BarChartDataEntry(x: 5, y: Double(results[cosineDistance]!!.unionCount)))
        dataEntries4.append(BarChartDataEntry(x: 6, y: Double(results[jacardDistance]!!.intersectionCount)))
        dataEntries4.append(BarChartDataEntry(x: 7, y: Double(results[jacardDistance]!!.unionCount)))
        let dataSet1 = BarChartDataSet(entries: dataEntries1, label: "QGrams")
        dataSet1.colors = [NSUIColor(red: 125, green: 219, blue: 187, alpha: 1.0), NSUIColor(red: 125, green: 142, blue: 219, alpha: 1.0)]
        let dataSet2 = BarChartDataSet(entries: dataEntries2, label: "Tversky Index")
        dataSet2.colors = [NSUIColor(red: 125, green: 219, blue: 187, alpha: 1.0), NSUIColor(red: 125, green: 142, blue: 219, alpha: 1.0)]
        let dataSet3 = BarChartDataSet(entries: dataEntries3, label: "Cosine Distance")
        dataSet3.colors = [NSUIColor(red: 125, green: 219, blue: 187, alpha: 1.0), NSUIColor(red: 125, green: 142, blue: 219, alpha: 1.0)]
        let dataSet4 = BarChartDataSet(entries: dataEntries4, label: "Jacard Distance")
        dataSet4.colors = [NSUIColor(red: 125, green: 219, blue: 187, alpha: 1.0), NSUIColor(red: 125, green: 142, blue: 219, alpha: 1.0)]
        let chartData = BarChartData(dataSets: [dataSet1, dataSet2, dataSet3, dataSet4])
        chartView.data = chartData
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        let description = Description()
        description.text = "Количество пересечений/объединений"
        chartView.chartDescription = description
        
        var percentEntries1 = [BarChartDataEntry]()
        var percentEntries2 = [BarChartDataEntry]()
        var percentEntries3 = [BarChartDataEntry]()
        var percentEntries4 = [BarChartDataEntry]()
        var percentEntries5 = [BarChartDataEntry]()
        
        func countRatedWords(result: Int, currentWord: RatedWord) -> Int {
            if currentWord.rating <= 0.5 {
                return result + 1
            }
            return result
        }
        
        let wordsCount: Double = Double(results[qgrams]!!.words.count)
        let qgramsPercent = Double(results[qgrams]!!.words.reduce(0, countRatedWords(result:currentWord:))) * 100.0 / wordsCount
        let tverskyPercent = Double(results[tverskyIndex]!!.words.reduce(0, countRatedWords(result:currentWord:))) * 100.0 / wordsCount
        let cosinePercent = Double(results[cosineDistance]!!.words.reduce(0, countRatedWords(result:currentWord:))) * 100.0 / wordsCount
        let jacardPercent = Double(results[jacardDistance]!!.words.reduce(0, countRatedWords(result:currentWord:))) * 100.0 / wordsCount
        
        func threshold(currentWord: RatedWord) -> Bool {
            return currentWord.rating <= 0.5
        }
        
        func convert(toString word: Word) -> String {
            return word.stringRepresentation
        }
        
        let qgramsFiltered = Set(results[qgrams]!!.words.filter(threshold(currentWord:)).map(convert(toString:)))
        let tverskyFiltered = Set(results[tverskyIndex]!!.words.filter(threshold(currentWord:)).map(convert(toString:)))
        let cosineFiltered = Set(results[cosineDistance]!!.words.filter(threshold(currentWord:)).map(convert(toString:)))
        let jacardFiltered = Set(results[jacardDistance]!!.words.filter(threshold(currentWord:)).map(convert(toString:)))
        
        let intersectionOfResults = qgramsFiltered.intersection(tverskyFiltered).intersection(cosineFiltered).intersection(jacardFiltered)
        
        let intersectionPercent = Double(intersectionOfResults.count) * 100.0 / wordsCount
        
        percentEntries1.append(BarChartDataEntry(x: 0, y: Double(qgramsPercent)))
        percentEntries2.append(BarChartDataEntry(x: 1, y: Double(tverskyPercent)))
        percentEntries3.append(BarChartDataEntry(x: 2, y: Double(cosinePercent)))
        percentEntries4.append(BarChartDataEntry(x: 3, y: Double(jacardPercent)))
        percentEntries5.append(BarChartDataEntry(x: 4, y: Double(intersectionPercent)))
        let percentSet1 = BarChartDataSet(entries: percentEntries1, label: "QGrams")
        let percentSet2 = BarChartDataSet(entries: percentEntries2, label: "Tversky Index")
        let percentSet3 = BarChartDataSet(entries: percentEntries3, label: "Cosine Distance")
        let percentSet4 = BarChartDataSet(entries: percentEntries4, label: "Jacard Distance")
        let percentSet5 = BarChartDataSet(entries: percentEntries5, label: "Пересечение")
        let percentData = BarChartData(dataSets: [percentSet1, percentSet2, percentSet3, percentSet4, percentSet5])
        percentView.data = percentData
        
        
        let descriptorQgrams = NSSortDescriptor(key: qgrams, ascending: true)
        let descriptorTverskyIndex = NSSortDescriptor(key: tverskyIndex, ascending: true)
        let descriptorCosineDistance = NSSortDescriptor(key: cosineDistance, ascending: true)
        let descriptorJacardDistance = NSSortDescriptor(key: jacardDistance, ascending: true)

        // 2
        tableView.tableColumns[1].sortDescriptorPrototype = descriptorQgrams
        tableView.tableColumns[2].sortDescriptorPrototype = descriptorTverskyIndex
        tableView.tableColumns[3].sortDescriptorPrototype = descriptorCosineDistance
        tableView.tableColumns[4].sortDescriptorPrototype = descriptorJacardDistance
        
        if let qgrams = results[qgrams] as? FuzzySearch.RatedResults,
            let cosineDistance = results[cosineDistance] as? FuzzySearch.RatedResults,
            let jacardDistance = results[jacardDistance] as? FuzzySearch.RatedResults,
            let tverskyIndex = results[tverskyIndex] as? FuzzySearch.RatedResults
        {
            for i in 0..<qgrams.words.count {
                dataSource.append(WordWithRatings(word: qgrams.words[i].stringRepresentation, qgrams: qgrams.words[i].rating, cosineDistance: cosineDistance.words[i].rating, jacardDistance: jacardDistance.words[i].rating, tverskyIndex: tverskyIndex.words[i].rating))
            }
        }
        
        reloadFileList()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    required init?(coder: NSCoder) {
        self.sortOrder = qgrams
        self.sortAscending = true
        super.init(coder: coder)
    }
    
}

extension ResultsViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return results[qgrams]??.words.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TableViewCell"), owner: nil) as? NSTableCellView else {
            return nil
        }
        
        switch tableColumn {
        case tableView.tableColumns[0]:
            cell.textField?.stringValue = dataSource[row].word
        case tableView.tableColumns[1]:
            cell.textField?.doubleValue = dataSource[row].qgrams
        case tableView.tableColumns[2]:
            cell.textField?.doubleValue = dataSource[row].tverskyIndex
        case tableView.tableColumns[3]:
            cell.textField?.doubleValue = dataSource[row].cosineDistance
        case tableView.tableColumns[4]:
            cell.textField?.doubleValue = dataSource[row].jacardDistance
        default: break

        }
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
      // 1
      guard let sortDescriptor = tableView.sortDescriptors.first else {
        return
      }
      if let order = sortDescriptor.key {
        // 2
        sortOrder = order
        sortAscending = sortDescriptor.ascending
        reloadFileList()
      }
    }
}
