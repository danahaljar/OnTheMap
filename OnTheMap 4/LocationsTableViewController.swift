//
//  LocationsTableViewController.swift
//  MemeMe.Version1
//
//  Created by Dana AlJar on 29/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController {
    
    let allLocations = StudentInformation.allLocations
    
    
    var locations: [StudentInformation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.locations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get data
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            
            guard let data = data , error == nil , response != nil else
                //ERROR!
            { print("Something is wrong")
                return}
            print("downloaded")
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String:Any]
                
                guard let results = dict["results"] as? [[String:Any]] else { return }
                
                let resultsData = try JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                
                let studentsLocations = try JSONDecoder().decode([StudentInformation].self, from: resultsData)
                
            }
            catch {
                print("Error: ", error)
                print("Error Localized Description: ", error.localizedDescription)
            }
          
        }
        task.resume()
        
    }
    
    
    // table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        let loc = self.allLocations[(indexPath as NSIndexPath).row]
        
        
        cell.textLabel?.text = loc.mapString
        
        
        return cell
    }
    
    // logout button
    @IBAction func logoutButtonIsPressed(_ sender: Any) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
        self.performSegue(withIdentifier: "fromListtoLogin", sender: self)
        
    }
    
}



