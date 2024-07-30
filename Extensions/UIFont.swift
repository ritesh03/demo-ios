//
//  UIFont.swift
//  synex
//
//  Created by Ritesh chopra on 01/09/23.
//

import Foundation
import UIKit

extension UIFont {
    
    enum CustomFont: String {
        case regular = "Inter-Regular"
        case bold = "Inter-Bold"
        case extraBold = "Inter-ExtraBold"
        case medium = "Inter-Medium"
        case semiBold = "Inter-SemiBold"


        
        func fontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name: rawValue, size: size)!
        }
    }
}
