# TipKarma

TipKarma is a tip calculator application for iOS submitted as [prework](https://github.com/dylancm4/TipKarma) for the CodePath May 2016 iOS bootcamp.

Time spent: **45** hours

## User Stories

**Required** functionality:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

**Optional** functionality:

* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.
* [x] Add a light/dark color theme to the settings view.

## Notes

The concept behind the app is that tipping well results in good karma, while tipping poorly results in bad karma. This concept is reinforced using UI animations. When a tip percentage 15% or above is used, a green "karma wheel", three arrows in a circle, spins clockwise in the direction the arrows are pointing, indicating good karma. The higher the tip, the faster the karma wheel spins. When a tip percentage below 15% is used, the karma wheel spins counterclockwise, against the direction of the arrows, and the arrows turn red, indicating bad karma. A user probably would not want these negative karma indicators in a real-world app, but implementing these animations was a rewarding learning exercise for this project.

The concept of spinning a karma wheel necessitates a UI control to trigger the spin, hence the "Calculate" tip button, to calculate the tip amount and total amount and spin the karma wheel. Since the tip amount and total amount are only updated when the "Calculate" tip button is pressed, rather than being updated on the fly, changes the user makes to the bill amount and/or tip percentage will not be accurately reflected in the tip amount and total amount until the "Calculate" tip button is pressed. In this case, to avoid confusion, the tip amount and total amount will be hidden from view until the "Calculate" tip button is pressed.

I spent a significant amount of time on this project, 45 hours over the course of about a week, because I had just started learning about Swift and iOS programming about two weeks earlier, so there were several learning curves to tackle. I took my time and tried to really challenge myself and use this project as a learning experience.

The slow framerate of the gif video walkthrough can cause the spinning arrows animation to appear to stutter or spin in the opposite direction. The animations in the app are smooth.

## Walkthrough

![Video Walkthrough](TipKarmaDemo.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## License

Copyright [2016] Dylan Miller

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
