//
//  UILabel+setTextWhileKeepingAttributes.swift
//  https://github.com/wvdk/A-Swift-Vocabulary
//
//  Created by Wesley Van der Klomp on 3/29/18.
//

import Foundation
import Contacts

extension CNContact {
    
    /// A calculated property returning the most familiar available proper noun for the contact.
    var displayName: String {
        get {
            var displayName: String = ""
            if !self.givenName.isEmpty {
                displayName += self.givenName
                if !self.familyName.isEmpty {
                    displayName += " \(self.familyName)"
                }
            } else if !self.familyName.isEmpty {
                displayName += self.familyName
            } else {
                let somePhoneNumber = self.phoneNumbers.first(where: { $0.label == CNLabelPhoneNumberMobile }) ?? self.phoneNumbers.first(where: { $0.label == CNLabelHome }) ?? self.phoneNumbers.first
                let someEmail = self.emailAddresses.first(where: { $0.label == CNLabelHome }) ?? self.emailAddresses.first
                if let phoneNumber = somePhoneNumber {
                    displayName += phoneNumber.value.stringValue
                } else if let email = someEmail {
                    displayName += email.value as String
                } else {
                    displayName = "Somebody that you used to know..."
                }
            }
            
            return displayName
        }
    }
    
    /// A calculated property returning the phone number which is most likely to be useful to a mobile app (if any).
    var bestFoundPhoneNumber: String? {
        get {
            print("wid: phoneNumbers: \(self.phoneNumbers)")
            
            let bestNumber: CNPhoneNumber? = {
                if let i = phoneNumbers.index(where: { $0.label == CNLabelPhoneNumberMobile }) {
                    return phoneNumbers[i].value
                }
                
                if let i = phoneNumbers.index(where: { $0.label == CNLabelPhoneNumberMain }) {
                    return phoneNumbers[i].value
                }
                
                if let i = phoneNumbers.index(where: { $0.label == CNLabelPhoneNumberiPhone }) {
                    return phoneNumbers[i].value
                }
                
                return phoneNumbers.first?.value
            }()
            
            guard let bestNumberString = bestNumber?.stringValue, bestNumberString != "" else { return nil }
            
            return bestNumberString
        }
    }
    
}
