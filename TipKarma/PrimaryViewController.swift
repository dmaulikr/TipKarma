//
//  PrimaryViewController.swift
//  TipKarma
//
//  App created as prework for the CodePath May 2016 iOS bootcamp.
//
// The concept behind the app is that tipping well results in good karma, while
// tipping poorly results in bad karma. This concept is reinforced using UI
// animations. When a tip percentage 15% or above is used, a green "karma
// wheel", three arrows in a circle, spins clockwise in the direction the arrows
// are pointing, indicating good karma. The higher the tip, the faster the karma
// wheel spins. When a tip percentage below 15% is used, the karma wheel spins
// counterclockwise, against the direction of the arrows, and the arrows turn
// red, indicating bad karma. A user probably would not want these negative
// karma indicators in a real-world app, but implementing these animations was a
// rewarding learning exercise for this project.
//
// The concept of spinning a karma wheel necessitates a UI control to trigger
// the spin, hence the "Calculate" tip button, to calculate the tip amount and
// total amount and spin the karma wheel. Since the tip amount and total amount
// are only updated when the "Calculate" tip button is pressed, rather than
// being updated on the fly, changes the user makes to the bill amount and/or
// tip percentage will not be accurately reflected in the tip amount and total
// amount until the "Calculate" tip button is pressed. In this case, to avoid
// confusion, the tip amount and total amount will be hidden from view until the
// "Calculate" tip button is pressed.
//
//  Created by Dylan Miller on 3/5/16.
//  Copyright © 2016 Dylan Miller. All rights reserved.
//

import UIKit

class PrimaryViewController: UIViewController
{
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipPercentageStepper: UIStepper!
    @IBOutlet weak var tipButton: UIButton!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var karmaImageViewGreen: UIImageView!
    @IBOutlet weak var karmaImageViewRed: UIImageView!
    @IBOutlet weak var tipImageViewGreen: UIImageView!
    @IBOutlet weak var tipImageViewRed: UIImageView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Give the "Calculate" tip button rounded corners. This might not be
        // completely in line with the iOS Human Interface Guidelines.
        tipButton.layer.cornerRadius = 10.0
        tipButton.layer.masksToBounds = true

        // OPTIONAL TASK: Bring up the keyboard so that the user can immediately
        // start typing.
        billAmountTextField.becomeFirstResponder()
        
        // Special auto layout adjustment for pre-iPhone 5.
        if (UIScreen.main.bounds.size.height == 480)
        {
            print("iphone 4Ss")
            karmaImageViewGreen.bounds.size.width = 2
            karmaImageViewGreen.bounds.size.height = 2
            karmaImageViewRed.bounds.size.width = 2
            karmaImageViewRed.bounds.size.height = 2
            tipImageViewGreen.bounds.size.width = 2
            tipImageViewGreen.bounds.size.height = 2
            tipImageViewRed.bounds.size.width = 2
            tipImageViewRed.bounds.size.height = 2
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // The instructions page for this assignment says: "When returning to
        // the main tip view controller from the settings page, it would be good
        // to have the tip percentage reflect the new default value." Arguments
        // can be made for and against doing this, but it is done here since the
        // instructions recommended it. Note that because of the "Calculate" tip
        // button design of this app, the tip amount and total amount is not
        // recalculated here.
        
        // Load the settings and set the tip percentage stepper and label.
        let settings = TipKarmaSettings()
        let tipPercentage = settings.loadTipPercentage()
        tipPercentageStepper.value = Double(tipPercentage)
        tipPercentageLabel.text = "\(tipPercentage)"

        // OPTIONAL TASK: Load the bill amount so that it is remembered across
        // app restarts under 10 minutes.
        let restartBillAmount = settings.loadBillAmount()

        if (billAmount != restartBillAmount) // if they match, do not reformat text field
        {
            billAmountTextField.text =
                String(format:"%.2f", settings.loadBillAmount())
        }
        
        // Update views with correct theme colors.
        setDarkColorTheme(settings.loadDarkThemeOn())

        if viewFirstAppearance
        {
            viewFirstAppearance = false

            // Update the tip amount and total amount to reflect the loaded
            // settings.
            updateTipAndTotal()
            
            // Set the karma wheel to red if tip percentage is under 15%.
            if tipPercentage < 15
            {
                let greenAlpha = self.karmaImageViewGreen.alpha
                self.karmaImageViewGreen.alpha = self.karmaImageViewRed.alpha
                self.karmaImageViewRed.alpha = greenAlpha
                self.tipImageViewGreen.alpha = self.karmaImageViewGreen.alpha
                self.tipImageViewRed.alpha = self.karmaImageViewRed.alpha
            }
        }

        // Possible hide or reveal the tip amount and total amount.
        hideTipAndTotalIfNotAccurateOrZero()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // OPTIONAL TASK: Save the bill amount so that it is remembered across
        // app restarts under 10 minutes.
        let settings = TipKarmaSettings()
        settings.saveBillAmount(billAmount)
    }
    
    @IBAction func billAmountEditingChanged()
    {
        // Possibly hide or reveal the tip amount and total amount.
        hideTipAndTotalIfNotAccurateOrZero()
    }
    
    // Update the tip percentage label based on the tip percentage stepper.
    @IBAction func tipPercentageStepperValueChanged(_ sender: UIStepper)
    {
        tipPercentageLabel.text = "\(Int(sender.value))"
        
        // Possibly hide or reveal the tip amount and total amount.
        hideTipAndTotalIfNotAccurateOrZero()
    }
    
    // Set the tip amount and total amount and spin the karma wheel. While the
    // CodePath demo video used a UI design which did not require the user to
    // press a button, the "Calculate" tip button is needed in my design in
    // order to for the karma wheel to spin to indicate good or bad karma.
    @IBAction func tipButtonPress(_ sender: UIButton)
    {
        // Dismiss the keyboard and set billAmount.
        view.endEditing(true)
        
        // Update the tip amount and total amount.
        updateTipAndTotal()

        // Spin the karma wheel.
        spinKarmaWheel(Int(tipPercentageStepper.value))

        // Possibly hide or reveal the tip amount and total amount.
        hideTipAndTotalIfNotAccurateOrZero()
    }
    
    // Dismiss the keyboard when the main view is tapped anywhere.
    @IBAction func onTap(_ sender: AnyObject)
    {
        view.endEditing(true)
    }
    
    // Calculate the tip amount and total amount based on the bill amount
    // and tip percentage.
    func getTipAndTotal() -> (tipAmount: Double, totalAmount: Double)
    {
        let tipAmount = billAmount * tipPercentageStepper.value / 100.0
        let totalAmount = billAmount + tipAmount
        return (tipAmount, totalAmount)
    }
    
    // Update the tip amount and total amount based on the bill amount
    // and tip percentage.
    // OPTIONAL TASK: Use locale specific currency and currency thousands
    // separators.
    func updateTipAndTotal()
    {
        let amounts = getTipAndTotal()

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let tipAmountString =
            formatter.string(from: NSNumber(value: amounts.tipAmount))
        {
            tipAmountLabel.text = tipAmountString
        }
        if let tipAmountString =
            formatter.string(from: NSNumber(value: amounts.totalAmount))
        {
            totalAmountLabel.text = tipAmountString
        }
        
        lastTipAmount = amounts.tipAmount
        lastTotalAmount = amounts.totalAmount
    }
    
    // Hide the tip amount and total amount if they do not accurately reflect
    // the current bill amount and tip percentage in the UI, or reveal them if
    // they are accurate. The amounts are also hidden if they are both zero.
    // When the amounts are hidden, a "TIP" image view is revealed within the
    // karma wheel. With the "Calculate" tip button design of this app, it is
    // a nice feature to hide inaccurate amounts until the "Calculate" tip
    // button is pressed.
    func hideTipAndTotalIfNotAccurateOrZero()
    {
        let newAmounts = getTipAndTotal()
        let hide =
            lastTipAmount != newAmounts.tipAmount ||
            lastTotalAmount != newAmounts.totalAmount ||
            (lastTipAmount == 0 && lastTotalAmount == 0)
        hideTipAndTotal(hide)
    }
    
    // Hide or reveal the tip amount, total amount, and "TIP" image views based
    // on the hide parameter.
    func hideTipAndTotal(_ hide: Bool)
    {
        let newAmountAlpha : CGFloat = hide ? 0.0 : 1.0
        let newTipGreenAlpha : CGFloat =
            hide ? self.karmaImageViewGreen.alpha : 0.0
        let newTipRedAlpha : CGFloat =
            hide ? self.karmaImageViewRed.alpha : 0.0
        if tipAmountLabel.alpha != newAmountAlpha ||
            totalAmountLabel.alpha != newAmountAlpha ||
            tipImageViewGreen.alpha != newTipGreenAlpha ||
            tipImageViewRed.alpha != newTipRedAlpha
        {
            // Fade in/out.
            UIView.animate(
                withDuration: 0.25,
                animations:
                {
                    self.tipAmountLabel.alpha = newAmountAlpha
                    self.totalAmountLabel.alpha = newAmountAlpha
                    self.tipImageViewGreen.alpha = newTipGreenAlpha
                    self.tipImageViewRed.alpha = newTipRedAlpha
                }
            )
        }
    }
    
    // Spin the karma wheel at a speed and direction calculated based on the tip
    // percentage, possibly changing the color of the wheel from green to red, or
    // vice versa.
    // OPTIONAL TASK: UI animations.
    func spinKarmaWheel(_ tipPercentage: Int)
    {
        let seconds = 4.0

        // Base the number of spins (the speed the wheel spins at) on the tip
        // percentage. Above 15%, a higher tip results in more positive spins/
        // karma, maxing out speed at 30%. Below 15%, a lower tip results in
        // more negative spins/karma, maxing out negative speed at 0%.
        let spinDirection: Double
        let numSpins: Double
        let swapKarmaImageColor: Bool
        if tipPercentage >= 15
        {
            spinDirection = 1.0
            numSpins = min(1.0 + (Double(tipPercentage) - 15.0) / 7.5, 3.0)
            swapKarmaImageColor = karmaImageViewRed.alpha > 0.0
        }
        else
        {
            spinDirection = -1.0
            numSpins = 1.0 + (15.0 - Double(tipPercentage)) / 7.5
            swapKarmaImageColor = karmaImageViewGreen.alpha > 0.0
        }
        
        // Gradually fade the karma wheel from green to red if karma goes from
        // positive to negative, or vice versa.
        if (swapKarmaImageColor)
        {
            UIView.animate(
                withDuration: seconds / 2.0,
                animations:
                {
                    let greenAlpha = self.karmaImageViewGreen.alpha
                    self.karmaImageViewGreen.alpha = self.karmaImageViewRed.alpha
                    self.karmaImageViewRed.alpha = greenAlpha
               }
            )
        }
        
        // Rotate the karma wheel the appropriate number of degrees. This is
        // done in a loop which calls animateWithDuration() with at most 90
        // degrees at a time, both so that we can gradually slow down the spin
        // speed and because rotation values 180 degrees and higher can result
        // in rotation in the wrong direction.
        let totalRotationDegrees = numSpins * 360.0
        var degreesRemaining = totalRotationDegrees
        var slowTheSpinMultiplier = 1.0
        while degreesRemaining > 0
        {
            let degreesToRotate = min(degreesRemaining, 90)
            currentRotationDegrees += degreesToRotate
            if currentRotationDegrees >= 360.0
            {
                currentRotationDegrees -= 360.0
            }
            let animationSeconds =
                seconds * degreesToRotate / totalRotationDegrees * slowTheSpinMultiplier
            slowTheSpinMultiplier += 0.5 // slow the spin similar to a roulette wheel
            UIView.animate(
                withDuration: animationSeconds,
                animations:
                {
                    let oneDegreeInRadians = Double.pi * 2.0 / 360.0
                    let endSpinRadians =
                        CGFloat(spinDirection * oneDegreeInRadians * self.currentRotationDegrees)
                    self.karmaImageViewGreen.transform =
                        CGAffineTransform(rotationAngle: endSpinRadians)
                    self.karmaImageViewRed.transform =
                        CGAffineTransform(rotationAngle: endSpinRadians)
                }
            )
            degreesRemaining -= degreesToRotate
        }
    }
    
    // OPTIONAL TASK: Update views with correct theme colors for either the
    // light color theme or the dark color theme.
    func setDarkColorTheme(_ darkThemeOn: Bool)
    {
        // If the theme colors are already set correctly, there is no need
        // to set them again.
        if darkThemeOn == darkThemeColorsSet
        {
            return
        }
        darkThemeColorsSet = darkThemeOn
        
        let mainViewRed = CGFloat(0.823468)
        let mainViewGreen = CGFloat(0.894601)
        let mainViewBlue = CGFloat(0.847952)
        
        if (darkThemeOn)
        {
            mainView.backgroundColor = UIColor.init(
                red: mainViewRed * 0.25, green: mainViewGreen * 0.25,
                blue: mainViewBlue * 0.25, alpha: 1)
            billLabel.textColor = UIColor.lightGray
            billAmountTextField.backgroundColor = UIColor.lightGray
            tipLabel.textColor = UIColor.lightGray
            tipPercentageLabel.textColor = UIColor.lightGray
            tipPercentLabel.textColor = UIColor.lightGray
            tipPercentageStepper.tintColor = UIColor.lightGray
            tipButton.setTitleColor(
                UIColor.init(white: 0.9, alpha: 1.0),
                for: UIControlState())
            tipAmountLabel.textColor = UIColor.lightGray
            totalLabel.textColor = UIColor.lightGray
            totalAmountLabel.textColor = UIColor.lightGray
            navigationController!.navigationBar.barTintColor =
                UIColor.lightGray
        }
        else // light color theme
        {
            let textRgb = CGFloat(0.235282)
            let textColor = UIColor.init(
                red: textRgb, green: textRgb, blue: textRgb, alpha: 1)
            
            mainView.backgroundColor = UIColor.init(
                red: mainViewRed, green: mainViewGreen, blue: mainViewBlue,
                alpha: 1)
            billLabel.textColor = textColor
            billAmountTextField.backgroundColor = nil // default
            tipLabel.textColor = textColor
            tipPercentageLabel.textColor = textColor
            tipPercentLabel.textColor = textColor
            tipPercentageStepper.tintColor = textColor
            tipButton.setTitleColor(
                nil, for: UIControlState()) // default
            tipAmountLabel.textColor = textColor
            totalLabel.textColor = textColor
            totalAmountLabel.textColor = textColor
            navigationController!.navigationBar.barTintColor = nil // default
        }
    }
    
    // The bill amount from the billAmountTextField.
    var billAmount : Double
    {
        get
        {
            if let billAmountText = billAmountTextField.text
            {
                if let billAmountNumber = Double(billAmountText)
                {
                    return billAmountNumber
                }
            }
            return 0.0
        }
    }
    
    // Indicates whether this is the first time the view is appearing.
    var viewFirstAppearance = true
    
    // The current rotation in degrees of the karma wheel.
    var currentRotationDegrees = 0.0
    
    // The last calculated tip amount.
    var lastTipAmount = 0.0
    
    // The last calculated total amount.
    var lastTotalAmount = 0.0
    
    // Indicates whether the view colors are set to the dark color theme colors.
    var darkThemeColorsSet = false
}
