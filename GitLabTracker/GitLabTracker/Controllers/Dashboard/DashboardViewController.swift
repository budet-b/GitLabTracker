//
//  DashboardViewController.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 29/06/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profilPictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var personnalProjectCollectionView: UICollectionView!
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    //PersonnalProjectCell
    var userModel = UserModel()
    var projectModel = ProjectModel()
    var projects : [ProjectModel] = []
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupsCollectionView.delegate = self
        self.groupsCollectionView.dataSource = self
        self.personnalProjectCollectionView.dataSource = self
        self.personnalProjectCollectionView.delegate = self
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        userModel.downloadData(completed: self.updateUI)
        let nib = UINib(nibName: "PersonnalProjectCell", bundle: nil)
        personnalProjectCollectionView.register(nib, forCellWithReuseIdentifier: "PersonnalProjectCollectionView")

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
        projectModel.downloadData(completed: self.updateProject)
        myActivityIndicator.stopAnimating()
        myActivityIndicator.removeFromSuperview()
    }
    
    func updateProject(projects: [ProjectModel]) {
        print("success")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = personnalProjectCollectionView.dequeueReusableCell(withReuseIdentifier: "PersonnalProjectCollectionView", for: indexPath)
        return cell
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
