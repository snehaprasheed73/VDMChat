//
//  NicknameViewController.swift
//  VDMChat
//
//  Created by Sneha Mohan on 2017-06-17.
//  Copyright © 2017 Tony. All rights reserved.
//

import UIKit

class NicknameViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barTintColor = UIColor.blue
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
    }
    
    func textFieldShouldReturn(_ nameTextfield: UITextField) -> Bool {
         nameTextfield.resignFirstResponder()
        
        if let text = nameTextfield.text, !text.isEmpty
        {
            let user_defaults = UserDefaults.standard
            user_defaults.removeObject(forKey:"username")
            user_defaults.set(nameTextfield.text!, forKey: "username") //setObject
            user_defaults.synchronize()
            
         }
        else
        {
            
        }
        
        return true
    }
    override func viewWillDisappear(_ animated:Bool) {
        
        if let text = nameTextfield.text, !text.isEmpty
        {
            let user_defaults = UserDefaults.standard
            user_defaults.removeObject(forKey:"username")
            user_defaults.set(nameTextfield.text!, forKey: "username") //setObject
            user_defaults.synchronize()
            
        
        }
        else
        {
            
        }

        
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
