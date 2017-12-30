//
//  CustomOperators.swift
//
//  Created by Wesley Van der Klomp on 12/29/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import Foundation

precedencegroup RandomAdditionOrSubtractionPrecedence {
    lowerThan: AdditionPrecedence
    associativity: left
}

infix operator +||-: RandomAdditionOrSubtractionPrecedence

func +||- (right: Double, left: Double) -> Double {
    return flipACoin() ? (right + left) : (right - left)
}

func +||- (right: Int, left: Int) -> Int {
    return flipACoin() ? (right + left) : (right - left)
}

//func +||- <Numeric> (right: Numeric, left: Numeric) -> Numeric {
//    return flipACoin() ? (right + left) : (right - left)
//}
