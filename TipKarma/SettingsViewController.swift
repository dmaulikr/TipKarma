//
//  SettingsViewController.swift
//  TipKarma
//
//  Created by Dylan Miller on 3/9/16.
//  Copyright © 2016 Dylan Miller. All rights reserved.
//

import UIKit

// This class controls saving and loading settings to/from NSUserDefaults.
class TipKarmaSettings
{
    let dfltPercentageKey = "dfltTipPercentage"
    let restartBillAmount = "restartBillAmount"
    let restartBillAmountAbsTime = "restartBillAmountAbsTime"
    
    // Save the default tip percentage to NSUserDefaults.
    func saveTipPercentage(tipPercentage: Int)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tipPercentage, forKey: dfltPercentageKey)
        defaults.synchronize()
    }
    
    // Load the default tip percentage from NSUserDefaults. If the default tip
    // percentage has not been set yet (it is 0), default to 15%. This means
    // that 0 is not allowed as a default tip percentage.
    func loadTipPercentage() -> Int
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipPercentage = defaults.integerForKey(dfltPercentageKey)
        return tipPercentage != 0 ? tipPercentage : 15
    }
    
    // Save the "restart" bill amount to NSUserDefaults. This is used so that
    // the bill amount is remembered across app restarts under 10 minutes.
    func saveBillAmount(billAmount: Double)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(billAmount, forKey: restartBillAmount)
        defaults.setDouble(
            CFAbsoluteTimeGetCurrent(), forKey: restartBillAmountAbsTime)
        defaults.synchronize()
    }
    
    // Load the "restart" bill amount from NSUserDefaults. If longer than 10
    // minutes has elapsed since it was saved, 0 is returned.
    func loadBillAmount() -> Double
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let billAmount = defaults.doubleForKey(restartBillAmount)
        let billAmountAbsTime =
            defaults.doubleForKey(restartBillAmountAbsTime)
        if (billAmountAbsTime != 0.0) // defined
        {
            let tenMinutesSeconds = 10.0 * 60.0
            let elapsedSeconds =
                CFAbsoluteTimeGetCurrent() - billAmountAbsTime
            if elapsedSeconds < tenMinutesSeconds
            {
                return billAmount
            }
        }
        return 0.0
    }
}

class SettingsViewController: UIViewController
{
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipPercentageStepper: UIStepper!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Load the settings and set the tip percentage stepper and label.
        let settings = TipKarmaSettings()
        tipPercentageStepper.value = Double(settings.loadTipPercentage())
        tipPercentageLabel.text = "\(Int(tipPercentageStepper.value))"
    }
    
    // Perform actions needed when the "Back" button is pressed.
    @IBAction func backButtonPress(sender: UIBarButtonItem)
    {
        // Save the settings.
        let settings = TipKarmaSettings()
        settings.saveTipPercentage(Int(tipPercentageStepper.value))
        
        // Return to the primary view.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Update the tip percentage label based on the tip percentage stepper.
    @IBAction func tipPercentageStepperValueChanged(sender: UIStepper)
    {
        tipPercentageLabel.text = "\(Int(sender.value))"
    }
}
