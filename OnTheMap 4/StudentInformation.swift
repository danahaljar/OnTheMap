
import Foundation

struct StudentInformation : Codable {
    
    // variables
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    
    /* // init
     init(dictionary: [String : AnyObject]) {
     self.firstName = dictionary["firstName"] as! String
     self.createdAt = dictionary["createdAt"] as! String
     self.lastName = dictionary["lastName"] as! String
     self.latitude = dictionary["latitude"] as! Double
     self.longitude = dictionary["longitude"] as! Double
     self.mapString = dictionary["mapString"] as! String
     self.mediaURL = dictionary["mediaURL"] as! String
     self.objectId = dictionary["objectId"] as! String
     self.uniqueKey = dictionary["uniqueKey"] as! String
     self.updatedAt = dictionary["updatedAt"] as! String
     }
     */
    // array
    static var allLocations: [StudentInformation] {
        
        let locationsArray = [StudentInformation]()
        
        return locationsArray
    }
    
    
    
}


