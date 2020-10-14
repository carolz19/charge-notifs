//
//  EditViewController.swift
//  charging-notifs
//
//  Created by Carol Zhang on 2020-08-11.
//  Copyright © 2020 Carol Zhang. All rights reserved.
//

import Cocoa

var max = 75.0
var min = 45.0


// TODO: figure out a way to delay timer after user starts/stops charging

class EditViewController: NSViewController {
    
    @IBOutlet var maxLabel: NSTextField!
    @IBOutlet var minLabel: NSTextField!
    
    @IBOutlet var newMax: NSTextField!
    @IBOutlet var newMin: NSTextField!
    
    let LONGSLEEP = 3600
    
    var timer: Timer? // may cause issues

    override func viewDidLoad() {
        super.viewDidLoad()
        updateValues(max: max, min: min)
        
    }
    
    func updateValues(max: Double, min: Double) {
        maxLabel.stringValue = String(describing: "Stop charging when > \(max)%")
        minLabel.stringValue = String(describing: "Start charging when < \(min)%")
        
    }
}

extension EditViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> EditViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("EditViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? EditViewController else {
            fatalError("Why cant i find EditViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

// MARK: Actions

extension EditViewController {
    
    @IBAction func startMonitoring(_ sender: NSButton) {
        
        let updatedMax = Double(newMax.stringValue)
        let updatedMin = Double(newMin.stringValue)
        
        if (updatedMax ?? nil != nil) {
            max = updatedMax ?? .nan
            updateValues(max: max, min: min)
        }
        
        if (updatedMin ?? nil != nil) {
            min = updatedMin ?? .nan
            updateValues(max: max, min: min)
        }
        
        print("start monitoring")
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func stopMonitoring(_ sender: NSButton) {
        timer?.invalidate()
        print("timer invalidated")
    }
    
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
    
    func deliverNotification(_ title: String, message: String, isCharged: Bool) {
        let notification = NSUserNotification()
        notification.title = "\(title)"
        notification.informativeText = message
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.scheduleNotification(notification)
        
    }
    
    @objc func fireTimer(sender: Any?){
        let internalFinder = InternalFinder()
        if let internalBattery = internalFinder.getInternalBattery() {
            print(internalBattery.charge)
            // Internal battery found, access properties here.
            
            if ((internalBattery.charge ?? .nan) >= max) {
                
                // if user if charging
                if ((internalBattery.isCharging ?? false) == true) {
                    
                    // notify user
                    self.deliverNotification("Stop Charging", message: "Battery is greater than \(max)", isCharged: internalBattery.isCharging ?? false)
                    
                    // give internalBattery instance some time to update
//                    sleep(60)
                    
                    // user stopped charging, don't check battery for an hour
                } else {
                    print("user stopped charging")
//                    sleep(UInt32(self.LONGSLEEP))
                }
                
                // tell user to start charging
            } else if ((internalBattery.charge ?? .nan) <= min) {
                
                // if user is NOT charging, deliver some more notifications
                if ((internalBattery.isCharging ?? false) == false) {
                    
                    // notify user
                    self.deliverNotification("Start Charging", message: "Battery is less than \(min)", isCharged: internalBattery.isCharging ?? false)
                    
                    // give internalBattery instance some time to update
//                    sleep(60)
                    
                    // user started charging, don't need to check battery for a long time
                } else {
                    print("user started charging")
//                    sleep(UInt32(self.LONGSLEEP))
                }
            }
        }
    }
}
