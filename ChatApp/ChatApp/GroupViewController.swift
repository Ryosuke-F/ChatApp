//
//  GroupViewController.swift
//  ChatApp
//
//  Created by Ryosuke Fukuda on 7/7/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit
import Parse

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var resultsNameArray = Set([""])
    var resultsNameArray2 = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        groupName_Title = ""
        
        resultsNameArray.removeAll(keepCapacity: false)
        resultsNameArray2.removeAll(keepCapacity: false)
        
        var query = PFQuery(className: "GroupMessages")
        query.addAscendingOrder("group")
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    
                    self.resultsNameArray.insert(object.objectForKey("Group") as! String)
                    self.resultsNameArray2 = Array(self.resultsNameArray)
                    
                    self.groupTableView.reloadData()
                    
                }
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    @IBAction func createNewGroups(sender: AnyObject) {
        
        println("createNewGroups")
        
        var aleart = UIAlertController(title: "New Group", message: "Type the name of the gropu.", preferredStyle: UIAlertControllerStyle.Alert)
        aleart.addTextFieldWithConfigurationHandler { (TextField) -> Void in
            
        }
        
        aleart.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
            println("okay pressed")
            
            let textF = aleart.textFields![0] as! UITextField
            println(textF.text)
            
            var groupMesaggesObj = PFObject(className: "GroupMessages")
            
            let theUser: String = PFUser.currentUser()!.username!
            
            groupMesaggesObj["sender"] = theUser
            groupMesaggesObj["message"] = "\(theUser) created a new group."
            groupMesaggesObj["Group"] = textF.text
            
            groupMesaggesObj.save()
            
            println("group created")
            groupName_Title = textF.text
            
            self.performSegueWithIdentifier("GroupConvoVC", sender: self)
            
            
        }))
        
        aleart.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            
            println("cancel Pressed")
            
        }))
        
        self.presentViewController(aleart, animated: true, completion: nil)
        
    }
    
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsNameArray2.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell") as! GroupTableViewCell
        
        cell.groupLabel.text = resultsNameArray2[indexPath.row]
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! GroupTableViewCell
        
        groupName_Title = resultsNameArray2[indexPath.row]
        
        self.performSegueWithIdentifier("GroupConvoVC", sender: self)
        
    }


}
