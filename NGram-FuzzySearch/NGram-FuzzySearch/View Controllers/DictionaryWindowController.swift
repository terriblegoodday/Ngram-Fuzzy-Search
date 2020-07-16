//
//  DictionaryWindowController.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 7/7/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Cocoa

class DictionaryWindowController: NSWindowController {
    
    var text: String = "🤡"

    override func windowDidLoad() {
        super.windowDidLoad()
        
//        let dictionaryViewController = self.contentViewController as! DictionaryViewController
//        dictionaryViewController.text = text
    }
    
    init?(coder: NSCoder, text: String) {
        self.text = text
        super.init(coder: coder)
     }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
