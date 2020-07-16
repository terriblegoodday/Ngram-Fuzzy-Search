//
//  DictionaryViewController.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 7/7/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Cocoa

class DictionaryViewController: NSViewController {

    @IBOutlet var textView: NSTextView?
    var dictionary: Dictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        textView?.string = dictionary?.text ?? "0/"
        self.view.window?.title = dictionary?.filename ?? "untitled"
    }
    
}
