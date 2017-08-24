//
//  prettyVersionNumber.swift
//  https://github.com/wvdk/A-Swift-Vocabulary
//
//  Created by Wesley Van der Klomp on 7/25/17.
//

var prettyVersionNumber: String {
    get {
        if let infoDictionary = Bundle.main.infoDictionary {
            if let versionNumber = infoDictionary["CFBundleShortVersionString"] as? String,
                let buildNumber = infoDictionary["CFBundleVersion"] as? String {
                
                return "\(versionNumber) (\(buildNumber))"
            }
        }
        
        return "No version number found."
    }
}
