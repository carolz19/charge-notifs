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
    let popover = NSPopover()
    
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = EditViewController.freshController()
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }
    
    // action method that will either open or close the popover depending on its current state
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    // displays the popover to the user. You just need to supply a source rect and macOS will position the popover and arrow so it looks like it’s coming out of the menu bar icon.
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
//    func deliverNotification(_ title: String, message: String, isCharged: Bool) {
//        let notification = NSUserNotification()
//        notification.title = "\(title)"
//        notification.informativeText = message
//        notification.soundName = NSUserNotificationDefaultSoundName
//        NSUserNotificationCenter.default.scheduleNotification(notification)
//
//    }
//
//    fileprivate func fireTimer(_ max: Double, _ min: Double) -> Timer {
//        return Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
//            let internalFinder = InternalFinder()
//            if let internalBattery = internalFinder.getInternalBattery() {
//                print(internalBattery.charge)
//                // Internal battery found, access properties here.
//
//                if ((internalBattery.charge ?? .nan) >= max) {
//
//                    // if user if charging
//                    if ((internalBattery.isCharging ?? false) == true) {
//
//                        // notify user
//                        self.deliverNotification("Stop Charging", message: "Battery is greater than \(max)", isCharged: internalBattery.isCharging ?? false)
//
//                        // give internalBattery instance some time to update
//                        sleep(60)
//
//                        // user stopped charging, don't check battery for an hour
//                    } else {
//                        print("user stopped charging")
//                        sleep(UInt32(self.LONGSLEEP))
//                    }
//
//                    // tell user to start charging
//                } else if ((internalBattery.charge ?? .nan) <= min) {
//
//                    // if user is NOT charging, deliver some more notifications
//                    if ((internalBattery.isCharging ?? false) == false) {
//
//                        // notify user
//                        self.deliverNotification("Start Charging", message: "Battery is less than \(min)", isCharged: internalBattery.isCharging ?? false)
//
//                        // give internalBattery instance some time to update
//                        sleep(60)
//
//                        // user started charging, don't need to check battery for a long time
//                    } else {
//                        print("user started charging")
//                        sleep(UInt32(self.LONGSLEEP))
//                    }
//                }
//            }
//        }
//    }
//
//    @objc func fortyFiveSeventyFive(_ sender: Any?) {
//        fireTimer(75.0, 60.0)
//    }
//
//    @objc func eightyTwenty(_ sender: Any?) {
//        fireTimer(80.0, 20.0)
//    }
//
//    @objc func startMonitoring(_ sender: Any?) {
//        // stub
//    }
//
//    @objc func editMaxMin(_ sender: Any?) {
//        // stub
//    }
//
//    func constructMenu() {
//        let menu = NSMenu()
//
//        menu.addItem(NSMenuItem(title: "20-80", action: #selector(AppDelegate.eightyTwenty(_:)), keyEquivalent: "e"))
//        menu.addItem(NSMenuItem(title: "45-75", action: #selector(AppDelegate.fortyFiveSeventyFive(_:)), keyEquivalent: "f"))
//        menu.addItem(NSMenuItem(title: "Start Monitoring Battery", action: #selector(AppDelegate.startMonitoring(_:)), keyEquivalent: "f"))
//        menu.addItem(NSMenuItem(title: "Edit Max and Min Charge", action: #selector(AppDelegate.editMaxMin(_:)), keyEquivalent: "f"))
//        menu.addItem(NSMenuItem.separator())
//        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
//
//        statusItem.menu = menu
//    }
}

