import Foundation
import CoreLocation

// This is an outdated legacy class from the old UIKit version of the app. This is used to read data previously stored in UserDefaults so it can be moved over to the newer SwiftData system.
class PRDataItem: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    let date: Date!
    let location: CLLocation!
    
    // Names used when storing & retrieving properties from memory.
    private let kLocationKey = "location"
    private let kDateKey = "date"
    
    init(location: CLLocation, date: Date) {
        self.location = location
        self.date = date
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, h:mm a (MM/dd/yy)"
        let formattedDate = dateFormatter.string(from: self.date)
        return formattedDate
    }
    
    // NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: kDateKey)
        aCoder.encode(location, forKey: kLocationKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.date = aDecoder.decodeObject(forKey: kDateKey) as! Date
        self.location = aDecoder.decodeObject(forKey: kLocationKey) as! CLLocation
    }
    
}
