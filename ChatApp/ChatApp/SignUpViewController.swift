//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by Ryosuke Fukuda on 7/5/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true

        profileImage.center = CGPointMake(theWidth/2, 180)
        

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        username.resignFirstResponder()
        password.resignFirstResponder()
        
        return true
        
    }
    
    @IBAction func addButton(sender: AnyObject) {
        
        println("addButton")
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        profileImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func signUpButton(sender: AnyObject) {
        
        println("signUpButton")
        
        var user = PFUser()
        user.username = username.text
        user.password = password.text
        
        let imageData = UIImagePNGRepresentation(profileImage.image)
        let imageFile = PFFile(name: "ProfilePhoto.png", data: imageData)
        user["image"] = imageFile
        
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if success == true {
                
                println("signed up")
                
                var installation: PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()
                
                
                self.performSegueWithIdentifier("goToUsersVC2", sender: nil)

                
                
            } else {
                
                println("error")
                
            }
            
        }
        
    }

}
