//
//  GroupConvoViewController.swift
//  ChatApp
//
//  Created by Ryosuke Fukuda on 7/7/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit
import Parse

var groupName_Title = ""

class GroupConvoViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var resultScrollView: UIScrollView!
    @IBOutlet weak var frameMessageView: UIView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var myImg: UIImage? = UIImage()
    
    var resultsImageFiles = [PFFile]()
    var resultsImageFile2 = [PFFile]()
    
    var messageArray = [String]()
    var senderArray = [String]()
    
    var scrollViewOriginalY: CGFloat = 0
    var frameMessageOriginalY: CGFloat = 0
    
    var messageX: CGFloat = 37
    var messageY: CGFloat = 26
    
    var frameX: CGFloat = 32.0
    var frameY: CGFloat = 21.0
    
    var imageX: CGFloat = 3
    var imageY: CGFloat = 3
    
    
    let mLabel = UILabel(frame: CGRectMake(5, 8, 200, 20))
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultScrollView.frame = CGRectMake(0, 64, theWidth, theHeight-114)
        resultScrollView.layer.zPosition = 20
        
        frameMessageView.frame = CGRectMake(0, resultScrollView.frame.maxY, theWidth, 50)
        lineLabel.frame = CGRectMake(0, 0, theWidth, 1)
        messageTextView.frame = CGRectMake(2, 1, self.frameMessageView.frame.size.width-52, 48)
        sendButton.center = CGPointMake(frameMessageView.frame.size.width-30, 24)
        
        scrollViewOriginalY = self.resultScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y
        
        self.title = otherName
        
        mLabel.text = "Type a message..."
        mLabel.backgroundColor = UIColor.clearColor()
        mLabel.textColor = UIColor.lightGrayColor()
        messageTextView.addSubview(mLabel)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let tapScrollViewgesture  = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewgesture.numberOfTapsRequired = 1
        resultScrollView.addGestureRecognizer(tapScrollViewgesture)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getGroupMessageFunc", name: "getGroupMessage", object: nil)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.title = groupName_Title
        
        var query = PFQuery(className: "_User")
        
        query.whereKey("username", equalTo: userName)
        
        var objects = query.findObjects()
        
        self.resultsImageFiles.removeAll(keepCapacity: false)
        
        for object in objects! {
            
            self.resultsImageFiles.append(object.objectForKey("image") as! PFFile)
            
            self.resultsImageFiles[0].getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                
                let image = UIImage(data: imageData!)
                self.myImg = image
                
                self.refreshResults()
                
            })
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGroupMessageFunc() {
        
        refreshResults()
        
    }
    
    func refreshResults() {
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        messageX = 37.0
        messageY = 26.0
        
        frameX = 32.0
        frameY = 21.0
        
        imageX = 3
        imageY = 3
        
        messageArray.removeAll(keepCapacity: true)
        senderArray.removeAll(keepCapacity: true)
        

        
        var query = PFQuery(className: "GroupMessages")
        
        query.whereKey("Group", equalTo: groupName_Title)
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    
                    self.senderArray.append(object["sender"] as! String)
                    self.messageArray.append(object["message"] as! String)
                    
                    
                }
                
                for subView in self.resultScrollView.subviews {
                    
                    subView.removeFromSuperview()
                    
                }
                
                
                for var i = 0; i <= self.messageArray.count-1; i++ {
                    
                    if self.senderArray[i] == userName {
                        
                        
                        var messageLbl: UILabel = UILabel()
                        messageLbl.frame = CGRectMake(0, 0, self.resultScrollView.frame.size.width-94, CGFloat.max)
                        messageLbl.backgroundColor = UIColor.blueColor()
                        messageLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.Left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.whiteColor()
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = (self.resultScrollView.frame.size.width - self.messageX) - messageLbl.frame.size.width
                        messageLbl.frame.origin.y = self.messageY
                        self.resultScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        var frameLbl: UILabel = UILabel()
                        frameLbl.frame.size = CGSizeMake(messageLbl.frame.size.width+10, messageLbl.frame.size.height+10)
                        frameLbl.frame.origin.x = (self.resultScrollView.frame.size.width - self.frameX) - frameLbl.frame.size.width
                        frameLbl.frame.origin.y = self.frameY
                        frameLbl.backgroundColor = UIColor.blueColor()
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.resultScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        
                        var img: UIImageView = UIImageView()
                        img.image = self.myImg
                        img.frame.size = CGSizeMake(34, 34)
                        img.frame.origin.x = (self.resultScrollView.frame.size.width - self.imageX) - img.frame.size.width
                        img.frame.origin.y = self.imageY
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultScrollView.addSubview(img)
                        self.imageY += frameLbl.frame.size.height + 20
                        
                        
                        
                        self.resultScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                        
                        
                    } else {
                        
                        var messageLbl: UILabel = UILabel()
                        messageLbl.frame = CGRectMake(0, 0, self.resultScrollView.frame.size.width-94, CGFloat.max)
                        messageLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        messageLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.Left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.blackColor()
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = self.messageX
                        messageLbl.frame.origin.y = self.messageY
                        self.resultScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        
                        
                        var frameLbl: UILabel = UILabel()
                        frameLbl.frame = CGRectMake(self.frameX, self.frameY, messageLbl.frame.size.width+10, messageLbl.frame.size.height+10)
                        frameLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.resultScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        
                        
                        var img: UIImageView = UIImageView()
                        
                        var query = PFQuery(className: "_User")
                        query.whereKey("username", equalTo: self.senderArray[i])
                        var objects = query.findObjects()
                        
                        self.resultsImageFile2.removeAll(keepCapacity: false)
                        
                        for object in objects! {
                            
                            
                            self.resultsImageFile2.append(object["image"] as! PFFile)
                            
                            self.resultsImageFile2[0].getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                                
                                if error == nil {
                                    
                                    img.image = UIImage(data: imageData!)
                                    
                                }
                            })
                            
                        }

                        img.frame = CGRectMake(self.imageX, self.imageY, 34, 34)
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultScrollView.addSubview(img)
                        self.imageY += frameLbl.frame.size.height + 20
                        
                        self.resultScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                        
                    }
                    
                    var bottonOffset: CGPoint = CGPointMake(0, self.resultScrollView.contentSize.height - self.resultScrollView.bounds.size.height)
                    self.resultScrollView.setContentOffset(bottonOffset, animated: false)
                    
                    
                    
                }
                
                
            }
            
        }

        
    }
    
    
    
    func didTapScrollView() {
        
        self.view.endEditing(true)
    }
    
    
    func keyBoardWasShown(notification: NSNotification) {
        
        let dict:NSDictionary = notification.userInfo!
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect:CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.1, delay: 0, options: .CurveLinear, animations: {
            
            self.resultScrollView.frame.origin.y = self.scrollViewOriginalY - rect.height
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY - rect.height
            
            var bottomOffset:CGPoint = CGPointMake(0, self.resultScrollView.contentSize.height - self.resultScrollView.bounds.size.height)
            self.resultScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })
        
    }
    
    func keyBoardWillHide(notification: NSNotification) {
        
        let dict:NSDictionary = notification.userInfo!
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect:CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.1, delay: 0, options: .CurveLinear, animations: {
            
            self.resultScrollView.frame.origin.y = self.scrollViewOriginalY
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY
            
            var bottomOffset:CGPoint = CGPointMake(0, self.resultScrollView.contentSize.height - self.resultScrollView.bounds.size.height)
            self.resultScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })
        
    }
    
    
    func textViewDidChange(textView: UITextView) {
        
        if !messageTextView.hasText() {
            
            self.mLabel.hidden = false
            
        } else {
            
            self.mLabel.hidden = true
        }
        
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if !messageTextView.hasText() {
            
            self.mLabel.hidden = false
            
        }
        
    }
    
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        if messageTextView.text == "" {
            
            println("no text")
            
        } else {
            
            var groupMessagetable = PFObject(className: "GroupMessages")
            groupMessagetable["Group"] = groupName_Title
            groupMessagetable["sender"] = userName
            groupMessagetable["message"] = self.messageTextView.text
            
            groupMessagetable.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                
                if success == true {
                    
                    var senderSet = Set([""])
                    senderSet.removeAll(keepCapacity: false)
                    
                    for var i = 0; i <= self.senderArray.count - 1; i++ {
                        
                        if self.senderArray[i] != userName {
                            
                            senderSet.insert(self.senderArray[i])
                            
                        }
                        
                    }
                    
                    var senderSetArray: NSArray = Array(senderSet)
                    
                    for var i2 = 0; i2 <= senderSetArray.count - 1; i2++ {
                        
                        println(senderSetArray[i2])
                        
                        var uQuery: PFQuery = PFUser.query()!
                        uQuery.whereKey("username", equalTo: senderSetArray[i2])
                        
                        var pushQuery: PFQuery = PFInstallation.query()!
                        pushQuery.whereKey("user", matchesQuery: uQuery)
                        
                        var push: PFPush = PFPush()
                        push.setQuery(pushQuery)
                        push.setMessage("New Group Message")
                        push.sendPushInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                            
                            
                            
                        })
                        println("push sent")
                        
                    }
                    
                    
                    println("message sent")
                    self.messageTextView.text = ""
                    self.mLabel.hidden = false
                    self.refreshResults()
                    
                    
                } else {
                    
                    println("error")
                    
                }
                
            })
            
            
        }
        
    }
    
    
    


}
