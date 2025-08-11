//
//  AppTheme.swift
//  MapplsSDKDemo
//
//  Created by rento on 07/01/25.
//

import UIKit

actor Theme: NSObject, ThemeProtocol {
    
    static let shared: Theme = Theme()
    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    private var currentTheme: ThemeColors = .default {
        didSet {
            self.observers.allObjects.compactMap({ $0 as? AppThemeChangeable }).forEach({ $0.appThemeChanged(theme: self.currentTheme)})
        }
    }
    
    func register<Observer>(observer: Observer) where Observer : AppThemeChangeable {
        observer.appThemeChanged(theme: currentTheme)
        observers.add(observer)
    }
}

enum ThemeColors {
    case `default`
    
    var accentBrandPrimary: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .light {
                return .Colors.oceanGreen
            }else {
                
                return .Colors.mintGreen
            }
        }
    }
    
    var backgroundPrimary: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .light {
                return .Colors.pureWhite
            }else {
                return .Colors.midnightBlue
            }
        }
    }
    
    var backgroundSecondary: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .light {
                return .Colors.softWhite
            }else {
                return .Colors.obsidianBlue
            }
        }
    }
    
    var strokeBorder: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .light {
                return .Colors.frostGray
            }else {
                return .Colors.slateGray
            }
        }
    }
    
    var textPrimary: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .light {
                return .Colors.jetBlack
            }else {
                return .Colors.pureWhite
            }
        }
    }
    
    var textSecondary: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .light {
                return .Colors.slateBlue
            }else {
                return .Colors.steelGray
            }
        }
    }
    
    var textPlaceholder: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .light {
                return .Colors.lightBlue
            }else {
                return .Colors.lightBlue
            }
        }
    }
}

protocol AppThemeChangeable: AnyObject, Sendable {
    func appThemeChanged(theme: ThemeColors)
}

extension AppThemeChangeable where Self: UITraitEnvironment {
    var themeProvider: ThemeProtocol {
        return Theme.shared
    }
}

protocol ThemeProtocol: AnyObject, Sendable {
    func register<Observer: AppThemeChangeable>(observer: Observer) async
}

