//
//  NSColor+init(hexString).swift
//  https://github.com/wvdk/A-Swift-Vocabulary
//
//  Thanks https://gist.github.com/yannickl/16f0ed38f0698d9a8ae7
//
//  Created by Wesley Van der Klomp on 7/25/17.
//

import Cocoa

extension NSColor {
    
    convenience init(hexString:String) {
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
}

