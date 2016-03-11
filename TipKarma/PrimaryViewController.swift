//
//  PrimaryViewController.swift
//  TipKarma
//
//  App created as Prework for the CodePath May 2016 iOS bootcamp.
//
//  The concept behind the app is that tipping well results in good karma, while tipping
//  poorly results in bad karma. This concept is reinforced using UI animations. When a
//  tip percentage 15% or above is used, a green "karma wheel", three arrows in a circle,
//  spins clockwise in the direction the arrows are pointing, indicating good karma. The
//  higher the tip, the faster the karma wheel spins. When a tip percentage below 15% is
//  used, the karma wheel spins counterclockwise, against the direction of the arrows,
//  and the arrows turn red, indicating bad karma. A user probably would not want these
//  negative karma indicators in a real-world app, but implementing these animations was
//  a rewarding learning exercise for this project.
//
//  Created by Dylan Miller on 3/5/16.
//  Copyright © 2016 Dylan Miller. All rights reserved.
//

import UIKit

class PrimaryViewController: UIViewController
{
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipPercentageStepper: UIStepper!
    @IBOutlet weak var tipButton: UIButton!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var karmaImageViewGreen: UIImageView!
    @IBOutlet weak var karmaImageViewRed: UIImageView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Note that the tip percentage stepper and label are set in
        // viewWillAppear().
        
        // Give the TIP button rounded corners. This might not be completely in
        // line with the iOS Human Interface Guidelines.
        tipButton.layer.cornerRadius = 10.0
        tipButton.layer.masksToBounds = true

        // Calculate the tip amount and total amount.
        caclulateTipAndTotal()

        // OPTIONAL TASK: Bring up the keyboard so that the user can immediately
        // start typing.
        billAmountTextField.becomeFirstResponder()
        
        // Special auto layout adjustment for pre-iPhone 5.
        if (UIScreen.mainScreen().bounds.size.height == 480)
        {
            print("iphone 4Ss")
            karmaImageViewGreen.bounds.size.width = 2
            karmaImageViewGreen.bounds.size.height = 2
            karmaImageViewRed.bounds.size.width = 2
            karmaImageViewRed.bounds.size.height = 2
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)

        // The instructions page for this assignment says: "When returning to
        // the main tip view controller from the settings page, it would be good
        // to have the tip percentage reflect the new default value." Arguments
        // can be made for and against doing this, but it is done here since the
        // instructions recommended it. Note that because of the "tip button"
        // design of this app, the tip amount and total amount is not
        // recalculated here.
        
        // Load the settings and set the tip percentage stepper and label.
        let settings = TipKarmaSettings()
        tipPercentageStepper.value = Double(settings.loadTipPercentage())
        tipPercentageLabel.text = "\(Int(tipPercentageStepper.value))"

        // OPTIONAL TASK: Load the bill amount so that it is remembered across
        // app restarts under 10 minutes.
        let restartBillAmount = settings.loadBillAmount();
        if (billAmount != restartBillAmount) // if they match, do not reformat text field
        {
            billAmountTextField.text =
                String(format:"%.2f", settings.loadBillAmount())
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // OPTIONAL TASK: Save the bill amount so that it is remembered across
        // app restarts under 10 minutes.
        let settings = TipKarmaSettings()
        settings.saveBillAmount(billAmount)
    }
    
    // Update the tip percentage label based on the tip percentage stepper.
    @IBAction func tipPercentageStepperValueChanged(sender: UIStepper)
    {
        tipPercentageLabel.text = "\(Int(sender.value))"
    }
    
    // Set the tip amount and total amount and spin the karma wheel. While the
    // CodePath demo video used a GUI design which did not require the user to
    // press a button, the button is needed in my design in order to for the
    // karma wheel to spin to indicate good or bad karma.
    @IBAction func tipButtonPress(sender: UIButton)
    {
        // Dismiss the keyboard and set billAmount.
        view.endEditing(true)
        
        // Calculate the tip amount and total amount.
        caclulateTipAndTotal()

        // Spin the karma wheel.
        spinKarmaWheel(Int(tipPercentageStepper.value))
    }
    
    // Dismiss the keyboard when the main view is tapped anywhere.
    @IBAction func onTap(sender: AnyObject)
    {
        view.endEditing(true)
    }
    
    // Calculate the tip amount and total amount based on the bill amount
    // and tip percentage.
    // OPTIONAL TASK: Use locale specific currency and currency thousands
    // separators.
    func caclulateTipAndTotal()
    {
        let tipAmount = billAmount * tipPercentageStepper.value / 100.0
        let totalAmount = billAmount + tipAmount

        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        if let tipAmountString = formatter.stringFromNumber(tipAmount)
        {
            tipAmountLabel.text = tipAmountString
        }
        if let tipAmountString = formatter.stringFromNumber(totalAmount)
        {
            totalAmountLabel.text = tipAmountString
        }
    
    }
    
    // Spin the karma wheel at a speed and direction calculated based on the tip
    // percentage, possibly changing the color of the wheel from green to red, or
    // vice versa.
    // OPTIONAL TASK: UI animations.
    func spinKarmaWheel(tipPercentage: Int)
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
            UIView.animateWithDuration(
                seconds / 2.0,
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
            UIView.animateWithDuration(
                animationSeconds,
                animations:
                {
                    let oneDegreeInRadians = M_PI * 2.0 / 360.0
                    let endSpinRadians =
                        CGFloat(spinDirection * oneDegreeInRadians * self.currentRotationDegrees)
                    self.karmaImageViewGreen.transform =
                        CGAffineTransformMakeRotation(endSpinRadians)
                    self.karmaImageViewRed.transform =
                        CGAffineTransformMakeRotation(endSpinRadians)
                }
            )
            degreesRemaining -= degreesToRotate
        }
    }
    
    // The bill amount from the billAmountTextField.
    var billAmount : Double
    {
        get
        {
            if let billAmountText = billAmountTextField.text
            {
                if let billAmountNumber = NSNumberFormatter().numberFromString(billAmountText)
                {
                    return billAmountNumber.doubleValue
                }
            }
            return 0.0
        }
    }
    
    // The current rotation in degrees of the karma wheel.
    var currentRotationDegrees = 0.0
}