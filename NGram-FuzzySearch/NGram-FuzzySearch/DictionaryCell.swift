//
//  DictionaryCell.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 7/7/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Cocoa

protocol DictionaryCellDelegate {
    func showDictionary(for cell: DictionaryCell)
}

class DictionaryCell: NSTableCellView {
    
    var delegate: DictionaryCellDelegate?
    
    @IBAction func showDictionary(_ sender: Any) {
        delegate?.showDictionary(for: self)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func viewWillDraw() {
        super.viewWillDraw()
    }
    
}
