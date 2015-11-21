//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let today = NSDate()
let thisMonth = NSCalendar.currentCalendar().components([.Month, .Day, .Year], fromDate: today)
let monthString = "\(thisMonth.month)"
