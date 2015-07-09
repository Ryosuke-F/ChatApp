//
//  ConvoViewController.swift
//  ChatApp
//
//  Created by Ryosuke Fukuda on 7/5/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit
import Parse

var otherName = ""

class ConvoViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var resultScrollView: UIScrollView!
    @IBOutlet weak var frameMessageView: UIView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    //@IBOutlet weak var blockButton: UIBarButtonItem!
    
    
    var isBlocked = false
    
    
    var scrollViewOriginalY: CGFloat = 0
    var frameMessageOriginalY: CGFloat = 0
    
    let mLabel = UILabel(frame: CGRectMake(5, 8, 200, 20))
    
    var blockButton = UIBarButtonItem()
    var reportButton = UIBarButtonItem()

    var messageArray = [String]()
    var senderArray = [String]()
    
    var myImg: UIImage? = UIImage()
    var otherImg: UIImage? = UIImage()
    
    var resultsImageFiles = [PFFile]()
    var resultsImageFiles2 = [PFFile]()
    
    var messageX: CGFloat = 37
    var messageY: CGFloat = 26
    
    var frameX: CGFloat = 32.0
    var frameY: CGFloat = 21.0
    
    var imageX: CGFloat = 3
    var imageY: CGFloat = 3
    
    
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
                
        print(messageArray)
        print(senderArray)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let tapScrollViewgesture  = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewgesture.numberOfTapsRequired = 1
        resultScrollView.addGestureRecognizer(tapScrollViewgesture)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getMessageFunc", name: "getMessage", object: nil)
        
        blockButton.title = ""
        
        blockButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("blockButtonTapped"))
        
        reportButton = UIBarButtonItem(title: "Report", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("reportButton_Tapped"))
        
        var buttonArray = NSArray(objects: blockButton, reportButton)
        self.navigationItem.rightBarButtonItems = buttonArray as [AnyObject]
        
        
    }
    
    
    func getMessageFunc() {
        
        refreshResult()
        
    }
    
    
    
    func didTapScrollView() {
        
        self.view.endEditing(true)
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
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        
        
        var checkQuery = PFQuery(className: "Block")
        checkQuery.whereKey("user", equalTo: otherName)
        checkQuery.whereKey("blocked", equalTo: userName)
        var objects2 = checkQuery.findObjects()
        
        if objects2?.count == 0 {
            
            isBlocked = false
        
        } else {
            
            isBlocked = true
            
        }
        
        
        var blockeQuery = PFQuery(className: "Block")
        blockeQuery.whereKey("user", equalTo: userName)
        blockeQuery.whereKey("blocked", equalTo: otherName)
        
        var objects0 = blockeQuery.findObjects()
        
        if objects0?.count > 0 {
            self.blockButton.title = "Unblock"
            
        } else {
            self.blockButton.title = "Block"
            
        }
        
        
        var query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: userName)
        var objects = query.findObjects()
        
        self.resultsImageFiles.removeAll(keepCapacity: true)
        
        
        for object in objects! {
            
            self.resultsImageFiles.append(object["image"] as! PFFile)
            
            self.resultsImageFiles[0].getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    
                    self.myImg = UIImage(data: imageData!)
                    
                    self.refreshResult()
  
                }
                
                
            })
            
        }
        
        
        var query2 = PFQuery(className: "_User")
        query2.whereKey("username", equalTo: otherName)
        var objects3 = query.findObjects()
        
        self.resultsImageFiles2.removeAll(keepCapacity: true)
        
        for object in objects3! {
            
            self.resultsImageFiles2.append(object["image"] as! PFFile)
            
            self.resultsImageFiles2[0].getDataInBackgroundWithBlock({ (imgData: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    self.otherImg = UIImage(data: imgData!)
                    
                    self.refreshResult()
                    
                    
                }
            })
        }
        
        
    }
    
    
    
    func refreshResult() {
        
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
        
        let innerP1 = NSPredicate(format: "sender = %@ AND other = %@", userName, otherName)
        var innerQ1: PFQuery = PFQuery(className: "Messages", predicate: innerP1)
        
        let innerP2 = NSPredicate(format: "sender = %@ AND other = %@", otherName, userName)
        var innerQ2: PFQuery = PFQuery(className: "Messages", predicate: innerP2)
        
        var query = PFQuery.orQueryWithSubqueries([innerQ1, innerQ2])
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
                        img.image = self.otherImg
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        
        
        if isBlocked == true {
            
            println("you are blocked")
            return
        }
        
        println("sendButtonTapped")
        
        if blockButton.title == "Unblock" {
            
            println("you have blocked this user. Unblock to send a message")
            self.messageTextView.text = ""
            return
            
        }

        if messageTextView.text == "" {
            
            println("no text")
            
        } else {
            
            var messageDBTable = PFObject(className: "Messages")
            messageDBTable["sender"] = userName
            messageDBTable["other"] = otherName
            messageDBTable["message"] = self.messageTextView.text
            messageDBTable.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                
                if success == true {
                    
                    var uQuery: PFQuery = PFUser.query()!
                    uQuery.whereKey("username", equalTo: otherName)
                    
                    var pushQuery: PFQuery = PFInstallation.query()!
                    pushQuery.whereKey("user", matchesQuery: uQuery)
                    
                    var push: PFPush = PFPush()
                    push.setQuery(pushQuery)
                    push.setMessage("New Message")
                    push.sendPush(nil)
                    println("push sent")
                    
                    
                    
                    println("message sent")
                    self.messageTextView.text = ""
                    self.mLabel.hidden = false
                    self.refreshResult()
                    
                }
                
            })
 
        }
        
    }
    
    
    func blockButtonTapped() {
        
        println("blockButtonTapped")
        
        if blockButton.title == "Block" {
            
            var addBlock = PFObject(className: "Block")
            addBlock.setObject(userName, forKey: "user")
            addBlock.setObject(otherName, forKey: "blocked")
            addBlock.saveInBackground()
            
            self.blockButton.title = "Unblock"
            
            
        } else {
            
            var query: PFQuery = PFQuery(className: "Block")
            query.whereKey("user", equalTo: userName)
            query.whereKey("blocked", equalTo: otherName)
            var objects = query.findObjects()
            
            for object in objects! {
                
                object.deleteInBackground()
                
            }
            
            self.blockButton.title = "Block"
            
            
            
        }
        
        
    }
    
    
    func reportButton_Tapped() {
        
        println("reportButton_Tapped")
        
        var addReport = PFObject(className: "Report")
        addReport.setObject(userName, forKey: "user")
        addReport.setObject(otherName, forKey: "reported")
        addReport.saveInBackground()
        
        println("report sent")
        
        
    }
    


}
