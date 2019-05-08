import UIKit
import MapKit
import CoreLocation

class LocationsPostingVC: UIViewController, MKMapViewDelegate {

    // UI elements
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var StudentLink: UITextField!
    @IBOutlet weak var Studentlocation: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var lat_value = 0.0, lon_value: Double = 0.0
    var geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // cancel post
    @IBAction func cancelPost(_ sender: Any) {
        dismiss(animated: true) {}
    }
    
    // find location
    @IBAction func findLocation(_ sender: Any) {
        
        geocoder.geocodeAddressString(Studentlocation.text!) { placemarks, error in
            
            if self.Studentlocation.text == "" {
                let alert = UIAlertController(title: "Error", message: "Location not found.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                
                self.lat_value = Double(lat!)
                self.lon_value = Double(lon!)

                let pinSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let pinLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, lon!)
                let pinRegion:MKCoordinateRegion = MKCoordinateRegion(center: pinLocation, span: pinSpan)
                self.myMap.setRegion(pinRegion, animated: true)
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = pinLocation
                self.myMap.addAnnotation(annotation)
                
                self.mapView.isHidden = false
                self.activityIndicator.stopAnimating()
            }
            
        }
        
    }

    // submit post
    @IBAction func submitPost(_ sender: Any) {
        
        if (StudentLink.text == "") {
            let alert = UIAlertController(title: "Error", message: "Please enter a link.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
            
            var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
            request.httpMethod = "POST"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \(Studentlocation.text!), \"mediaURL\": \(StudentLink.text),\"latitude\": \(lat_value), \"longitude\": \(lon_value)}".data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error…
                    return
                }
                print(String(data: data!, encoding: .utf8)!)
            }
            
            task.resume()
            dismiss(animated: true) {}
            
        }
    }
    
    
}
