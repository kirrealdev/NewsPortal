//
//  String + Extension.swift
//  Practice_2
//
//  Created by KirRealDev on 29.10.2021.
//

import Foundation
import UIKit

func convertToString(dateString: String, formatIn : String, formatOut : String) -> String {

    let dateFormater = DateFormatter()
    dateFormater.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
    dateFormater.dateFormat = formatIn
    let date = dateFormater.date(from: dateString)

    dateFormater.timeZone = NSTimeZone.system

    dateFormater.dateFormat = formatOut
    let timeStr = dateFormater.string(from: date!)
    return timeStr
}
