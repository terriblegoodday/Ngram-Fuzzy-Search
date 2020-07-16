//
//  AppDelegate.swift
//  NGram-FuzzySearch
//
//  Created by Eduard Dzhumagaliev on 6/10/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var dictionaryRepository = DictionaryPersistentStore()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }


}

