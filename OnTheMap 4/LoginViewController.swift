//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Dana AlJar on 30/04/2019.
//  Copyright © 2019 Nora. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var userPassword: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var activityIndicator:
    UIActivityIndicatorView!
    func displayAlert(title:String, message:String?) {
        
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEmail.delegate = self
        userPassword.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoginIsPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        if userEmail.text!.isEmpty || userPassword.text!.isEmpty {
            displayAlert(title: "Login Unsuccessful", message: "Username and/or Password is empty")
        }
        
        let URL_string = "https://onthemap-api.udacity.com/v1/session"
        var request = URLRequest(url: URL(string: URL_string)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(userEmail.text!)\", \"password\": \"\(userPassword.text!)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if let errors = error{
                print(errors.localizedDescription)
                return
            }
            
            do {
                if let response = response {
                    print(response)
                    let user_statusCode = response.value(forKey: "statusCode")! as! Int
                    print("User Status Code: \(user_statusCode)")
                    
                    if (user_statusCode == 200) {
                        print("success")
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "login", sender: self)
                        }
                    }

                    else if (user_statusCode == 403) {
                        DispatchQueue.main.async {
                            self.displayAlert(title: "Login Unsuccessful", message: "Invalid Username and/or Password")
                        }
                        
                    }
                    else
                    {
                        self.displayAlert(title: "Login Unsuccessful", message: "The Internet connection appears to be offline.")
                }
                }
            }
            catch {
                print("Could not get data.")
            }
            
    
            
        }
        
        task.resume()
        //self.performSegue(withIdentifier: "loginSegue", sender: self)
        
    }
    
}


// segue
func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "login" {
        _ = segue.destination as! TabBarViewController
    }
 }
