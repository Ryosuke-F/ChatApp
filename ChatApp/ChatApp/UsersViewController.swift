//
//  UsersViewController.swift
//  ChatApp
//
//  Created by Ryosuke Fukuda on 7/5/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit
import Parse

var userName = ""


class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var resultTableView: UITableView!
    
    var resultUsernameArray = [String]()
    var resultUsersProfilePic = [PFFile]()
    
    
    var cellHeight: CGFloat = 65

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultTableView.delegate = self
        self.resultTableView.dataSource = self
        
        let messageBarButton = UIBarButtonItem(title: "Messages", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("messageButtonTapped"))
        
        let groupBarButton = UIBarButtonItem(title: "Group", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("groupButtonTapped"))
        
        var buttonArray = NSArray(objects: messageBarButton, groupBarButton)
        self.navigationItem.rightBarButtonItems = buttonArray as? [AnyObject]

        
        var nib: UINib = UINib(nibName: "UsersTableViewCell", bundle: nil)
        self.resultTableView.registerNib(nib, forCellReuseIdentifier: "UsersCell")
        
        self.navigationItem.hidesBackButton = true
  
    }
    
    override func viewDidAppear(animated: Bool) {
        

        self.navigationItem.setHidesBackButton(true, animated: false)
        
        userName = PFUser.currentUser()!.username!
        
        let predicate = NSPredicate(format: "username != '"+userName+"'")
        var query = PFQuery(className: "_User", predicate: predicate)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            self.resultUsernameArray.removeAll(keepCapacity: true)
            self.resultUsersProfilePic.removeAll(keepCapacity: true)
            
            for object in objects! {
                
                self.resultUsersProfilePic.append(object["image"] as! PFFile)
                self.resultUsernameArray.append(object.username!!)
                
                self.resultTableView.reloadData()
                
            }
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {

        
    }
    
    func messageButtonTapped() {
        println("messageButtonTapped")
        
        self.performSegueWithIdentifier("goToMessagesVc", sender: self)
        
        
    }
    
    func groupButtonTapped() {
        
        println("groupButtonTapped")
        
        self.performSegueWithIdentifier("GoToGroupVC", sender: self)
        
        
    }
    
    
    @IBAction func logOutButton(sender: AnyObject) {
        
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultUsernameArray.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return cellHeight
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UsersCell") as? UsersTableViewCell
        
        cell!.nameLabel.text = resultUsernameArray[indexPath.row]
        
        resultUsersProfilePic[indexPath.row].getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell!.profilePic.image = image
   
            }
            
            
        }
        
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! UsersTableViewCell
        
        otherName = cell.nameLabel.text!
        
        self.performSegueWithIdentifier("goToConvoVC", sender: nil)
        
    }
    
    


}
