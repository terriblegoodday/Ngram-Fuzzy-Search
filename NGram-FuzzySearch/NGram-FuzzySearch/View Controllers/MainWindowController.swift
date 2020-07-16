//
//  MainWindowController.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 7/7/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    var tabViewController: NSTabViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.tabViewController = self.window?.contentViewController as? NSTabViewController
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func segmentedControlSwitched(_ sender: Any) {
        if let segmentedControl = sender as? NSSegmentedControl {
            self.tabViewController?.selectedTabViewItemIndex = segmentedControl.selectedSegment
        }
    }
    

}
