public extension Date {
    
    
    public static func createFromFormattedString(mmddyy: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.date(from: mmddyy)
    }
    
    
}
