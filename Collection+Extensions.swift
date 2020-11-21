
import Foundation

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    ///
    /// This method is convenient but much slower than a typical subscript get. I don't recommend using it on large arrays.
    ///
    /// Usage: `myArray[safe: 123]`
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
