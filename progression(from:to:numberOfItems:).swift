//
//  progression(from:to:numberOfItems:).swift
//  https://github.com/wvdk/A-Swift-Vocabulary
//
//  Created by Wesley Van der Klomp on 8/15/17.
//

func progression(from: Double, to: Double, numberOfItems: Int) -> [Double] {
    
    let delta = (to - from) / Double(numberOfItems)
    
    var results: [Double] = []
    
    for _ in 0..<numberOfItems {
        let lastItem = results.last ?? from
        
        let numberToAppend = lastItem + delta
        
        results.append(numberToAppend)
    }
    
    return results
}

progression(from: 0.0, to: 1.0, numberOfItems: 10) // Desired output: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]

progression(from: 0.0, to: 100.0, numberOfItems: 100)

progression(from: 429.0, to: 3232.0, numberOfItems: 53)
