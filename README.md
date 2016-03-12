# TipKarma demo

This is a tip calculator application for iOS submitted as [Prework](https://github.com/dylancm4/TipKarma) for the CodePath May 2016 iOS bootcamp.

Time spent: 40 hours

Completed:

* [x] Required: User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Required: Settings page to change the default tip percentage.
* [x] Optional: UI animations
* [x] Optional: Remembering the bill amount across app restarts (if <10mins)
* [x] Optional: Using locale-specific currency and currency thousands separators.
* [x] Optional: Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.
* [x] Optional: Add a light/dark color theme to the settings view.

Notes:
The concept behind the app is that tipping well results in good karma, while tipping poorly results in bad karma. This concept is reinforced using UI animations. When a tip percentage 15% or above is used, a green "karma wheel", three arrows in a circle, spins clockwise in the direction the arrows are pointing, indicating good karma. The higher the tip, the faster the karma wheel spins. When a tip percentage below 15% is used, the karma wheel spins counterclockwise, against the direction of the arrows, and the arrows turn red, indicating bad karma. A user probably would not want these negative karma indicators in a real-world app, but implementing these animations was a rewarding learning exercise for this project.

I spent a significant amount of time on this project, 40 hours over the course of a week, because I had just started learning about Swift and iOS programming a few weeks prior, so there were several learning curves to tackle. I took my time and tried to really challenge myself and use this project as a learning experience.

The slow framerate of the gif video walkthrough can cause the spinning arrows animation to appear to stutter or spin in the opposite direction. The animations in the app are smooth.

![Video Walkthrough](TipKarmaDemo.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
