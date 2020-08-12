//
//  AppDelegate.swift
//  charging-notifs
//
//  Created by Carol Zhang on 2020-08-11.
//  Copyright © 2020 Carol Zhang. All rights reserved.
//

import Cocoa
import AppKit
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let LONGSLEEP = 3600


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }
        constructMenu()

    }
//
//
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current() // 1
//            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
//                granted, error in
//                print("Permission granted: \(granted)") // 3
//        }
//    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func deliverNotification(_ message: String, isCharged: Bool) {
        let notification = NSUserNotification()
        notification.title = "\(message)"
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.scheduleNotification(notification)

    }

    @objc func fortyFiveSeventyFive(_ sender: Any?) {
        var deliverCount = 0
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            let internalFinder = InternalFinder()
            if let internalBattery = internalFinder.getInternalBattery() {
                print(internalBattery.charge)
                // Internal battery found, access properties here.
                
                if ((internalBattery.charge ?? .nan) >= 75) {
                    
                    // if user is still charging, deliver one more notification
                    print(internalBattery.isCharging ?? false)
                    if ((internalBattery.isCharging ?? false) == true) {
                        
                        // don't wanna annoy the user! deliver no more than 2 notifs
                        if (deliverCount < 1) {
                            self.deliverNotification("Stop Charging", isCharged: internalBattery.isCharging ?? false)
                            deliverCount += 1
                            print("number of notifications delivered \(deliverCount)")
                        }
                        
                        // user stopped charging, don't check battery for an hour
                    } else {
                        deliverCount = 0
                        print("user stopped charging")
                        sleep(UInt32(self.LONGSLEEP))
                    }
                    
                    // tell user to start charging
                } else if ((internalBattery.charge ?? .nan) <= 45) {
                    
                    // if user is NOT charging, deliver some more notifications
                    if ((internalBattery.isCharging ?? false) == false) {
                        
                        // don't wanna annoy the user! deliver no more than 2 notifs
                        if (deliverCount < 1) {
                            self.deliverNotification("Start Charging", isCharged: internalBattery.isCharging ?? false)
                            deliverCount += 1
                            print("number of notifications delivered \(deliverCount)")
                        }
                        
                        // user started charging, don't need to check battery for a long time
                    } else {
                        deliverCount = 0
                        print("user started charging")
                        sleep(UInt32(self.LONGSLEEP))
                    }
                }
            }
            
        }

    }
    //
    @objc func eightyTwenty(_ sender: Any?) {
        var deliverCount = 0
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
            let internalFinder = InternalFinder()
            if let internalBattery = internalFinder.getInternalBattery() {
            // Internal battery found, access properties here.
                
                if ((internalBattery.charge ?? .nan) >= 80) {
                    
                    // if user is still charging, deliver one more notification
                    print(internalBattery.isCharging ?? false)
                    if ((internalBattery.isCharging ?? false) == true) {
        
                        // don't wanna annoy the user! deliver no more than 2 notifs
                        if (deliverCount < 1) {
                            self.deliverNotification("Stop Charging", isCharged: internalBattery.isCharging ?? false)
                            deliverCount += 1
                            print("number of notifications delivered \(deliverCount)")
                        }

                    // user stopped charging, don't check battery for an hour
                    } else {
                        deliverCount = 0
                        print("user stopped charging")
                        sleep(UInt32(self.LONGSLEEP))
                    }
                
                // tell user to start charging
                } else if ((internalBattery.charge ?? .nan) <= 20) {
                    
                    // if user is NOT charging, deliver some more notifications
                    if ((internalBattery.isCharging ?? false) == false) {
                        
                        // don't wanna annoy the user! deliver no more than 2 notifs
                        if (deliverCount < 1) {
                            self.deliverNotification("Start Charging", isCharged: internalBattery.isCharging ?? false)
                            deliverCount += 1
                            print("number of notifications delivered \(deliverCount)")
                        }
                        
                    // user started charging, don't need to check battery for a long time
                    } else {
                        deliverCount = 0
                        print("user started charging")
                        sleep(UInt32(self.LONGSLEEP))
                    }
                }
            }
            
        }
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "20-80", action: #selector(AppDelegate.eightyTwenty(_:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem(title: "45-75", action: #selector(AppDelegate.fortyFiveSeventyFive(_:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
}

