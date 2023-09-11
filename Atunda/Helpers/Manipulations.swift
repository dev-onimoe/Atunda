//
//  Manipulations.swift
//  Atunda
//
//  Created by Mas'ud on 9/5/22.
//

import Foundation
import UIKit

class Manipulations{
    
    static func changeCharColor (fullString : String, targetString : String, color : UIColor) -> NSMutableAttributedString {
        let longestWordRange = (fullString as NSString).range(of: targetString)

        let attributedString = NSMutableAttributedString(string: fullString)

        attributedString.setAttributes([NSAttributedString.Key.foregroundColor : color], range: longestWordRange)
        //label.attributedText = attributedString
        return attributedString
    }
    
    static func changeCharFontType (fullString : String, targetString : String, font : UIFont) -> NSMutableAttributedString {
        let longestWordRange = (fullString as NSString).range(of: targetString)

        let attributedString = NSMutableAttributedString(string: fullString)

        attributedString.setAttributes([NSAttributedString.Key.font : font], range: longestWordRange)
        //label.attributedText = attributedString
        return attributedString
    }
}
