//
//  LoginViewController.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 28/06/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var personnaltokenTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pasteButtonAction(_ sender: Any) {
        if let pasteboard = UIPasteboard.general.string {
            personnaltokenTextField.text = pasteboard
        }
    }
    
    @IBAction func loginActionPressed(_ sender: Any) {
        if (personnaltokenTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Impossible to login", message: "Your token is empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let headers: HTTPHeaders = [
                "Private-Token": personnaltokenTextField.text!,
                "Accept": "application/json"
            ]
            let url = "https://gitlab.com/api/v4/user"
            Alamofire.request(url, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON(completionHandler: {
                response in
                if let httpStatusCode = response.response?.statusCode {
                    print(response.result)
                    print(httpStatusCode)
                    switch(httpStatusCode) {
                    case 200:
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(self.personnaltokenTextField.text, forKey: "token")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardNC")
                        self.present(vc!, animated: true, completion: nil)
                    default:
                        let alert = UIAlertController(title: "Impossible to login", message: "invalid token", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
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
