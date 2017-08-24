//
//  UIApplication+isRunningOnSimulator.swift
//  https://github.com/wvdk/A-Swift-Vocabulary
//
//  Thanks to http://stackoverflow.com/a/30284266/6407050
//
//  Created by Wesley Van der Klomp on 5/11/17.
//

import Foundation

extension UIApplication {
 
    static var isRunningOnSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}
