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
    
    let menu = NSMenu()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }
        constructMenu()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func constructMenu() {
        menu.addItem(NSMenuItem(title: "Start Monitoring",
                                    action: #selector(AppDelegate.startMonitoring(_:)),
                                    keyEquivalent: "g"))
        menu.addItem(NSMenuItem(title: "Stop Monitoring",
                                    action: #selector(AppDelegate.stopMonitoring(_:)),
                                    keyEquivalent: "s"))
//        menu.addItem(NSMenuItem(title: "Preferences",
//        action: Selector?,
//        keyEquivalent: "p"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit",
                                action: #selector(NSApplication.terminate(_:)),
                                keyEquivalent: "q"))


        statusItem.menu = menu
            
    }
    
    var timer: Timer?
    var max = 75.0
    var min = 65.0
    
    @objc func startMonitoring(_ sender: Any?) {
        timer?.invalidate()
        print("timer invalidated")
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func stopMonitoring(_ sender: Any?) {
        timer?.invalidate()
        print("timer invalidated")
    }
    
    func deliverNotification(_ title: String, message: String, isCharged: Bool) {
        let notification = NSUserNotification()
        notification.title = "\(title)"
        notification.informativeText = message
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.scheduleNotification(notification)
        
    }
    
    @objc func fireTimer(_ sender: Any?) {
        let internalFinder = InternalFinder()
        
        if let internalBattery = internalFinder.getInternalBattery() {
                    print(internalBattery.charge)
                    // Internal battery found, access properties here.
                    
                    if ((internalBattery.charge ?? .nan) >= max) {
                        
                        // if user if charging
                        if ((internalBattery.isCharging ?? false) == true) {
                            
                            // notify user
                            self.deliverNotification("Stop Charging", message: "Battery is greater than \(max)", isCharged: internalBattery.isCharging ?? false)
                            
                        } else {
                            print("user stopped charging")
                        }
                        
                        // tell user to start charging
                    } else if ((internalBattery.charge ?? .nan) <= min) {
                        
                        // if user is NOT charging, deliver some more notifications
                        if ((internalBattery.isCharging ?? false) == false) {
                            
                            // notify user
                            self.deliverNotification("Start Charging", message: "Battery is less than \(min)", isCharged: internalBattery.isCharging ?? false)
                            
                        } else {
                            print("user started charging")
                        }
                    }
                }
    }
    
    
}

