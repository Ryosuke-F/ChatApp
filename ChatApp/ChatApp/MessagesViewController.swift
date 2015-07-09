//
//  MessagesViewController.swift
//  ChatApp
//
//  Created by Ryosuke Fukuda on 7/7/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit
import Parse

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var messageTableView: UITableView!

    let cellHeight: CGFloat = 60
    
    var resultNameArray = [String]()
    var resultImageFiles = [PFFile]()
    
    var senderArray = [String]()
    var otherArray = [String]()
    var messageArray = [String]()
    
    var senderArray2 = [String]()
    var otherArray2 = [String]()
    var messageArray2 = [String]()
    
    var senderArray3 = [String]()
    var otherArray3 = [String]()
    var messageArray3 = [String]()
    
    var results = 0
    var currResult = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var theWidth = view.frame.size.width
        var theHeight = view.frame.size.width

    }
    
    override func viewDidAppear(animated: Bool) {
        
        userName = PFUser.currentUser()!.username!
        
        resultNameArray.removeAll(keepCapacity: false)
        resultImageFiles.removeAll(keepCapacity: false)
        
        senderArray.removeAll(keepCapacity: false)
        otherArray.removeAll(keepCapacity: false)
        messageArray.removeAll(keepCapacity: false)
        
        senderArray2.removeAll(keepCapacity: false)
        otherArray2.removeAll(keepCapacity: false)
        messageArray2.removeAll(keepCapacity: false)
        
        senderArray3.removeAll(keepCapacity: false)
        otherArray3.removeAll(keepCapacity: false)
        messageArray3.removeAll(keepCapacity: false)
        
        let setPredicate = NSPredicate(format: "sender = %@ OR Other = %@", userName, otherName)
        var query = PFQuery(className: "Messages", predicate: setPredicate)
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    
                    self.senderArray.append(object.objectForKey("sender") as! String)
                    self.otherArray.append(object.objectForKey("other") as! String)
                    self.messageArray.append(object.objectForKey("message") as! String)
                    
                    
                }
                
                for var i = 0; i <= self.senderArray.count - 1; i++ {
                    
                    if self.senderArray[i] == userName {
                        
                        self.otherArray2.append(self.otherArray[i])
                        
                    } else {
                        
                        self.otherArray2.append(self.senderArray[i])
                        
                    }
                    
                    self.messageArray2.append(self.messageArray[i])
                    self.senderArray2.append(self.senderArray[i])
                    
                }
                
                for var i2 = 0; i2 <= self.otherArray2.count - 1; i2++ {
                    
                    var isfound = false
                    
                    for var i3 = 0; i3 <= self.otherArray3.count - 1; i3++ {
                        
                        if self.otherArray3[i3] == self.otherArray2[i2] {
                            
                            isfound = true
                            
                        }
                        
                    }
                    
                    if isfound == false {
                        
                        self.otherArray3.append(self.otherArray2[i2])
                        self.messageArray3.append(self.messageArray2[i2])
                        self.senderArray3.append(self.senderArray2[i2])
                        
                    }
                    
                }
                
                
                self.results = self.otherArray3.count
                self.currResult = 0
                self.fetchResults()
                
                
            } else {
                
                
                
                
            }
            
        }
        

        
    }
    
    
    func fetchResults() {
        
        if currResult < results {
            
            var queryF = PFUser.query()
            queryF?.whereKey("username", equalTo: self.otherArray3[currResult])
            
            var objects = queryF?.findObjects()
            
            for object in objects! {
                
                self.resultNameArray.append(object.objectForKey("username") as! String)
                self.resultImageFiles.append(object.objectForKey("image") as! PFFile)
                
                self.currResult = self.currResult + 1
                self.fetchResults()
                
                self.messageTableView.reloadData()
                
            }
            
        }
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return cellHeight
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.resultNameArray.count
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageTableViewCell
        
        cell.nameLabel.text = self.resultNameArray[indexPath.row]
        cell.messageLabel.text = self.messageArray3[indexPath.row]
        cell.otherNameLabel.text = self.otherArray3[indexPath.row]
        
        resultImageFiles[indexPath.row].getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.profileImageView.image = image
                
                
                
            }
            
        }
        
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! MessageTableViewCell
        
        otherName = cell.nameLabel.text!
        
        self.performSegueWithIdentifier("goToConvoVC2", sender: nil)
        
    }
    


}
