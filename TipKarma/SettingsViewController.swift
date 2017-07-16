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
    let darkThemeOnKey = "darkThemeOn"
    let restartBillAmount = "restartBillAmount"
    let restartBillAmountAbsTime = "restartBillAmountAbsTime"
    
    // Save the default tip percentage to NSUserDefaults.
    func saveTipPercentage(_ tipPercentage: Int)
    {
        let defaults = UserDefaults.standard
        defaults.set(tipPercentage, forKey: dfltPercentageKey)
        defaults.synchronize()
    }
    
    // Load the default tip percentage from NSUserDefaults. If the default tip
    // percentage has not been set yet (it is 0), default to 15%. This means
    // that 0 is not allowed as a default tip percentage.
    func loadTipPercentage() -> Int
    {
        let defaults = UserDefaults.standard
        let tipPercentage = defaults.integer(forKey: dfltPercentageKey)
        return tipPercentage != 0 ? tipPercentage : 15
    }
    
    // Save the dark them "on" NSUserDefaults.
    func saveDarkThemeOn(_ darkThemeOn: Bool)
    {
        let defaults = UserDefaults.standard
        defaults.set(darkThemeOn, forKey: darkThemeOnKey)
        defaults.synchronize()
    }
    
    // Load the dark theme "on" from NSUserDefaults.
    func loadDarkThemeOn() -> Bool
    {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: darkThemeOnKey)
    }
    
    // Save the "restart" bill amount to NSUserDefaults. This is used so that
    // the bill amount is remembered across app restarts under 10 minutes.
    func saveBillAmount(_ billAmount: Double)
    {
        let defaults = UserDefaults.standard
        defaults.set(billAmount, forKey: restartBillAmount)
        defaults.set(
            CFAbsoluteTimeGetCurrent(), forKey: restartBillAmountAbsTime)
        defaults.synchronize()
    }
    
    // Load the "restart" bill amount from NSUserDefaults. If longer than 10
    // minutes has elapsed since it was saved, 0 is returned.
    func loadBillAmount() -> Double
    {
        let defaults = UserDefaults.standard
        let billAmount = defaults.double(forKey: restartBillAmount)
        let billAmountAbsTime =
            defaults.double(forKey: restartBillAmountAbsTime)
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
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipPercentageStepper: UIStepper!
    @IBOutlet weak var darkThemeLabel: UILabel!
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Load the settings and set the tip percentage stepper, tip percentage
        // label, and dark theme switch.
        let settings = TipKarmaSettings()
        tipPercentageStepper.value = Double(settings.loadTipPercentage())
        tipPercentageLabel.text = "\(Int(tipPercentageStepper.value))"
        darkThemeSwitch.isOn = settings.loadDarkThemeOn()
        
        // Update views with correct theme colors.
        setDarkColorTheme(darkThemeSwitch.isOn, fadeMainView: false)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    // Perform actions needed when the "Back" button is pressed.
    @IBAction func backButtonPress(_ sender: UIBarButtonItem)
    {
        // Save the settings.
        let settings = TipKarmaSettings()
        settings.saveTipPercentage(Int(tipPercentageStepper.value))
        settings.saveDarkThemeOn(darkThemeSwitch.isOn)
        
        // Return to the primary view.
        dismiss(animated: true, completion: nil)
    }
    
    // Update the tip percentage label based on the tip percentage stepper.
    @IBAction func tipPercentageStepperValueChanged(_ sender: UIStepper)
    {
        tipPercentageLabel.text = "\(Int(sender.value))"
    }
    
    // Update the color theme based on the dark theme switch.
    @IBAction func darkThemeValueChanged(_ sender: UISwitch)
    {
        self.setDarkColorTheme(sender.isOn, fadeMainView: true)
    }
    
    // OPTIONAL TASK: Update views with correct theme colors for either the
    // light color theme or the dark color theme.
    func setDarkColorTheme(_ darkThemeOn: Bool, fadeMainView: Bool)
    {
        // If the theme colors are already set correctly, there is no need
        // to set them again.
        if darkThemeOn == darkThemeColorsSet
        {
            return;
        }
        darkThemeColorsSet = darkThemeOn
        
        if (darkThemeOn)
        {
            tipLabel.textColor = UIColor.lightGray
            tipPercentageLabel.textColor = UIColor.lightGray
            tipPercentLabel.textColor = UIColor.lightGray
            tipPercentageStepper.tintColor = UIColor.lightGray
            darkThemeLabel.textColor = UIColor.lightGray
            darkThemeSwitch.thumbTintColor = UIColor.init(
                white: 0.9, alpha: 1.0)
            navigationController!.navigationBar.barTintColor =
                UIColor.lightGray
        }
        else // light color theme
        {
            let textRgb = CGFloat(0.235282)
            let textColor = UIColor.init(
                red: textRgb, green: textRgb, blue: textRgb, alpha: 1)
            
            tipLabel.textColor = textColor
            tipPercentageLabel.textColor = textColor
            tipPercentLabel.textColor = textColor
            tipPercentageStepper.tintColor = textColor
            darkThemeLabel.textColor = textColor
            darkThemeSwitch.thumbTintColor = nil // default
            navigationController!.navigationBar.barTintColor = nil // default
        }
        
        // Fade the main view color for a cool effect.
        UIView.animate(
            withDuration: fadeMainView ? 0.25 : 0.0,
            animations:
            {
                let mainViewRed = CGFloat(0.823468)
                let mainViewGreen = CGFloat(0.894601)
                let mainViewBlue = CGFloat(0.847952)
                if (darkThemeOn)
                {
                    self.mainView.backgroundColor = UIColor.init(
                        red: mainViewRed * 0.25, green: mainViewGreen * 0.25,
                        blue: mainViewBlue * 0.25, alpha: 1)
                }
                else // light color theme
                {
                    self.mainView.backgroundColor = UIColor.init(
                        red: mainViewRed, green: mainViewGreen, blue: mainViewBlue,
                        alpha: 1)
                }
            }
        )
    }
    
    // Indicates whether the view colors are set to the dark color theme colors.
    var darkThemeColorsSet = false
}
