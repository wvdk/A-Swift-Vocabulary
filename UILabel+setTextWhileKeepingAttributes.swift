//
//  UILabel+setTextWhileKeepingAttributes.swift
//  https://github.com/wvdk/A-Swift-Vocabulary
//
//  Created by Wesley Van der Klomp on 8/15/17.
//


import UIKit

extension UILabel {

    func setTextWhileKeepingAttributes(string: String) {
        if let newAttributedText = self.attributedText {
            let mutableAttributedText = newAttributedText.mutableCopy()
            
            mutableAttributedText.mutableString.setString(string)
            
            self.attributedText = mutableAttributedText as? NSAttributedString
        }
    }
    
}
