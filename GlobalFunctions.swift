//
//  GlobalFunctions.swift
//
//  Created by Wesley Van der Klomp on 12/29/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import Foundation

/// Produces a random Bool.
func flipACoin() -> Bool {
    return arc4random_uniform(2) > 0
}

/// Returns a random Double between 0.0 and 0.9
func random() -> Double {
    return Double(arc4random_uniform(UInt32(10))) * 0.1
}

/// Runs the provided black after a delay.
func start(_ closure: @escaping () -> (), after delay: TimeInterval) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
}
