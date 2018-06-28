//
//  DashboardViewController.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 29/06/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var profilPictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    var userModel = UserModel()
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        userModel.downloadData(completed: self.updateUI)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        usernameLabel.text = userModel.name
        let data = try? Data(contentsOf: userModel.avatarURL!)
        profilPictureImageView.image = UIImage(data: data!)
        
        myActivityIndicator.stopAnimating()
        myActivityIndicator.removeFromSuperview()
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