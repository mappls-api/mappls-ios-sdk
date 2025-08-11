//
//  UIColor+Extension.swift
//  MapplsSDKDemo
//
//  Created by rento on 07/01/25.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 1.0
        if (cString.hasPrefix("#")) {
            cString.remove(at: hexString.startIndex)
        }
        let scanner = Scanner(string: cString)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (cString.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                break
            }
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    struct Colors {
        //MARK: Dark Mode
        static let midnightBlue: UIColor = .init(hexString: "#1B1E27")
        static let pureWhite: UIColor = .init(hexString: "#FFFFFF")
        static let mintGreen: UIColor = .init(hexString: "#21D0B2")
        static let obsidianBlue: UIColor = .init(hexString: "#1F232F")
        static let steelGray: UIColor = .init(hexString: "#8990AB")
        static let slateGray: UIColor = .init(hexString: "#33394A")
        static let lightBlue: UIColor = .init(hexString: "#e2e7fa")
        
        //MARK: Light Mode
        static let softWhite: UIColor = .init(hexString: "#FAFAFA")
        static let jetBlack: UIColor = .init(hexString: "#212121")
        static let oceanGreen: UIColor = .init(hexString: "#339E82")
        static let frostGray: UIColor = .init(hexString: "#EBEDEF")
        static let slateBlue: UIColor = .init(hexString: "#535C7B")
    }
    
}
