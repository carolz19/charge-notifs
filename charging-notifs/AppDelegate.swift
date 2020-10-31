//
//  AppDelegate.swift
//  charging-notifs
//
//  Created by Carol Zhang on 2020-08-11.
//  Copyright © 2020 Carol Zhang. All rights reserved.
// https://www.raywenderlich.com/450-menus-and-popovers-in-menu-bar-apps-for-macos

import Cocoa
import AppKit
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let LONGSLEEP = 3600
    
//    let popover = NSPopover()
    let menu = NSMenu()
    
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
//            button.action = #selector(togglePopover(_:))
        }
        
        constructMenu()
        
    }
    
    func constructMenu() {
        menu.addItem(NSMenuItem(title: "Start Monitoring",
                                action: #selector(EditViewController.startMonitoring(_:)),
                                keyEquivalent: "g"))
        menu.addItem(NSMenuItem(title: "Stop Monitoring",
                                action: #selector(EditViewController.startMonitoring(_:)),
                                keyEquivalent: "s"))
//        menu.addItem(NSMenuItem(title: "Preferences",
//                                action: <#T##Selector?#>,
//                                keyEquivalent: "p"))
        statusItem.menu = menu
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

