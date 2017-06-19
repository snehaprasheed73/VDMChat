//
//  MainViewController.swift
//  VDMChat
//
//  Created by Sneha Mohan on 2017-06-17.
//  Copyright © 2017 Tony. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    
  var messageArray = [String]()
    var ref: DatabaseReference!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var textviewmssg: UITextView!
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var message_tableview: UITableView!
    
//@IBOutlet weak var message_tableview: UITableView!
   private let Array: NSArray = ["First","Second","Third"]
   override func viewDidLoad() {
        
        super.viewDidLoad()
   
    textviewmssg.textContainer.maximumNumberOfLines = 8
    textviewmssg.textContainer.lineBreakMode = .byWordWrapping
        navigationController?.navigationBar.barTintColor = UIColor.blue
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        textLabel.layer.borderWidth = 1.5
        textLabel.layer.borderColor = UIColor.black.cgColor
    
        sendButton.backgroundColor = UIColor.blue
        sendButton.layer.cornerRadius = 8
        sendButton.layer.borderWidth = 1
        message_tableview.dataSource = self as? UITableViewDataSource
        message_tableview.delegate = self as? UITableViewDelegate
        // Do any additional setup after loading the view.
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
   
    message_tableview.estimatedRowHeight = 70.0
    message_tableview.rowHeight = UITableViewAutomaticDimension

    
    }
    
    
    

func keyboardWasShown(notification: NSNotification){
    self.tableViewScrollToBottom(animated: true)
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0{

            self.view.frame.origin.y -= keyboardSize.height

        }
    }
}

func keyboardWillBeHidden(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += keyboardSize.height
        }
    }
}
    
    
   func textViewDidChange(_ textView: UITextView)
   {
    
    let height = textviewmssg.frame.size.height
    print(height)
    let fixedWidth = textviewmssg.frame.size.width
    textviewmssg.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    let newSize = textviewmssg.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    var newFrame = textviewmssg.frame
    newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    textviewmssg.frame = newFrame;
    let newheight = textviewmssg.frame.size.height
    print(newheight)

    if height == newheight
    {
    }
    else
    {
        let xPosition = textviewmssg.frame.origin.x
        var yPosition = textviewmssg.frame.origin.y
        var labelheight = textLabel.frame.size.height
        let labelxposition=textLabel.frame.origin.x
        var labelyposition=textLabel.frame.origin.y
        if(height > newheight)
        {
         yPosition = textviewmssg.frame.origin.y + 14.3
         labelyposition=textLabel.frame.origin.y+13.5
         labelheight=textLabel.frame.size.height-13.7
        }
        else{
          yPosition = textviewmssg.frame.origin.y - 14.3
          labelyposition=textLabel.frame.origin.y-13.5
          labelheight=textLabel.frame.size.height+13.7
           }
        let newheighttextview = textviewmssg.frame.size.height
        let width = textviewmssg.frame.size.width
        textviewmssg.frame = CGRect(x: xPosition, y: yPosition, width: width, height: newheighttextview)
        textLabel.frame=CGRect(x: labelxposition, y: labelyposition, width: textLabel.frame.size.width, height: labelheight)
    }
       }
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: DBL_MAX),
                                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                         attributes: [NSFontAttributeName: font],
                                                         context: nil).size
    }
    
    //send button action
    
    @IBAction func clickSend(_ sender: Any)
    {
        let user_defaults = UserDefaults.standard
        let username = user_defaults.object(forKey: "username")
        
        //Saving data to FireDatabase
        
        ref = Database.database().reference()
        let name = username
        let textitem = textviewmssg.text
        let userName: NSDictionary = ["name":name,"text":textitem]
        
        
        let profile = ref.child(byAppendingPath: name as! String)
        profile.setValue(username)
        let string=" : "
        let appendString1 = "\(username!) \(string)"
        print(appendString1)
        let appendString2 = "\(appendString1) \(textviewmssg.text!)"
        print(appendString2)
        messageArray.append(appendString2)
        print(messageArray)
        
        textviewmssg.resignFirstResponder()
        textviewmssg.text=""
        textviewmssg.frame=CGRect(x: 2, y: 630, width: 313, height: 29)
        textLabel.frame=CGRect(x: 0, y: 621, width: 375, height: 45)
        self.message_tableview.reloadData()
        
        self.tableViewScrollToBottom(animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count;
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.text = messageArray[row]
        
        return cell
    
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "ToNicknamecontroller", sender: nil)
        print("You tapped cell number \(indexPath.row).")
    }
    func tableViewScrollToBottom(animated: Bool) {
    
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            
            let numberOfSections = self.message_tableview.numberOfSections
            let numberOfRows = self.message_tableview.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.message_tableview.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
