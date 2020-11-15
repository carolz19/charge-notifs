//
//  AppDelegate.swift
//  charging-notifs
//
//  Created by Carol Zhang on 2020-08-11.
//  Copyright © 2020 Carol Zhang. All rights reserved.
// https://www.raywenderlich.com/450-menus-and-popovers-in-menu-bar-apps-for-macos

import Cocoa
import AppKit
//import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var timer: Timer?
    var max = 80.0
    var min = 20.0
    var isMonitoring = false
    
    let statusItem : NSStatusItem = {
        let item = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
        return item
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }
        
        constructMenu(statusItem: statusItem)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func constructMenu(statusItem: NSStatusItem) {
        let menu = NSMenu()
        var monitoring = ""
        if (isMonitoring) {
            monitoring = "Currently Monitoring"
        } else {
            monitoring = "Not Currently Monitoring"
        }
        menu.addItem(withTitle: monitoring, action: nil, keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Start Monitoring",
                                    action: #selector(AppDelegate.startMonitoring(_:)),
                                    keyEquivalent: "g"))
        menu.addItem(NSMenuItem(title: "Stop Monitoring",
                                    action: #selector(AppDelegate.stopMonitoring(_:)),
                                    keyEquivalent: "s"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit",
                                action: #selector(NSApplication.terminate(_:)),
                                keyEquivalent: "q"))
        
        statusItem.menu = menu
            
    }
    
    
    
    
    
    
    
    
    
    
    @objc func startMonitoring(_ sender: Any?) {
        print("start monitoring")
        isMonitoring = true
        constructMenu(statusItem: statusItem)
        // invalidate any existing timers
        timer?.invalidate()
        
        // checks battery level at a given time interval
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func stopMonitoring(_ sender: Any?) {
        print("stop monitoring")
        isMonitoring = false
        constructMenu(statusItem: statusItem)
        // invalidate timer to stop monitoring
        timer?.invalidate()
    }
    
    func deliverNotification(_ title: String, message: String, isCharged: Bool) {
        let notification = NSUserNotification()
        notification.title = "\(title)"
        notification.informativeText = message
        notification.contentImage = NSImage(named:NSImage.Name("AppIcon"))
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.scheduleNotification(notification)
        
    }
    
    @objc func fireTimer(_ sender: Any?) {
        let internalFinder = InternalFinder()
        
        // get user's battery information
        if let internalBattery = internalFinder.getInternalBattery() {
            print(internalBattery.charge ?? 0)
            // send notif is battery level above max and user is charging
            if ((internalBattery.charge ?? .nan) >= max
                && (internalBattery.isCharging ?? false) == true) {
                self.deliverNotification("Stop Charging",
                                        message: "Battery is greater than \(max)%",
                                        isCharged: internalBattery.isCharging ?? false)
            // send notif is battery level below max and user isn't charging
            } else if ((internalBattery.charge ?? .nan) <= min
                && ((internalBattery.isCharging ?? false) == false)) {
                    self.deliverNotification("Start Charging",
                                            message: "Battery is less than \(min)%",
                                            isCharged: internalBattery.isCharging ?? false)
            }
        }
    }
}

