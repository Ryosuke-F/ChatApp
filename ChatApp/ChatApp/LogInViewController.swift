//
//  LogInViewController.swift
//  ChatApp
//
//  Created by Ryosuke Fukuda on 7/5/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            
            self.performSegueWithIdentifier("goToUsersVC", sender: self)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        
        return true
        
    }
    
    
    @IBAction func LogInButton(sender: AnyObject) {
        
        println("LogInButton")
        PFUser.logInWithUsernameInBackground(usernameTxt.text, password: passwordTxt.text) { (user: PFUser?, error: NSError?) -> Void in
            
            if error == nil {
                
                println("logged in")
                
                var installation: PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()
                
                self.performSegueWithIdentifier("goToUsersVC", sender: nil)
                
            } else {
                
                println("error")
            }
            
        }
        
        
    }
    
    
    @IBAction func signUpButton(sender: AnyObject) {
        
        println("signUpButton")
        
    }


}
