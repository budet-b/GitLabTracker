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
    var groupModel = GroupeModel()
    var projects : [ProjectModel] = []
    var groups: [GroupeModel] = []
    var selectedProject: ProjectModel?
    var selectedGroup: GroupeModel?
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
        groupModel.downloadData(completed: self.updateGroup)
        
        myActivityIndicator.stopAnimating()
        myActivityIndicator.removeFromSuperview()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedGroup = nil
        selectedProject = nil
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
    }
    
    func updateProject(projectsList: [ProjectModel]) {
        print("success")
        self.projects = projectsList
        self.personnalProjectCollectionView.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case personnalProjectCollectionView:
            return projects.count
        case groupsCollectionView:
            return groups.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case personnalProjectCollectionView:
            let cell = personnalProjectCollectionView.dequeueReusableCell(withReuseIdentifier: "PersonnalProjectCell", for: indexPath) as! PersonnalProjectCollectionViewCell
            let urlImage = projects[indexPath.row].avatarURL!
            let data = try? Data(contentsOf: urlImage)
            if (data != nil) {
                cell.projectImage.image = UIImage(data: data!)
            } else {
                cell.projectImage.image = UIImage(named: "placeholder")
            }
            cell.projectImage.image = projects[indexPath.row].image
            cell.projectName.text = projects[indexPath.row].name
            return cell
        case groupsCollectionView:
            let cell = groupsCollectionView.dequeueReusableCell(withReuseIdentifier: "GroupProjectCell", for: indexPath) as! GroupProjectCollectionViewCell
            cell.groupProjectName.text = groups[indexPath.row].name
            let urlImage = groups[indexPath.row].avatarURL!
            let data = try? Data(contentsOf: urlImage)
            if (data != nil) {
                cell.groupProjectImage.image = UIImage(data: data!)
            } else {
                cell.groupProjectImage.image = UIImage(named: "placeholder")
            }
            cell.groupProjectImage.image = groups[indexPath.row].image
            return cell
        default:
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    func updateGroup(groupList: [GroupeModel]) {
        self.groups = groupList
        self.groupsCollectionView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case personnalProjectCollectionView:
            performSegue(withIdentifier: "projectSegue", sender: indexPath)
        case groupsCollectionView:
            performSegue(withIdentifier: "groupsSegue", sender: indexPath)
        default:
            return
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "groupsSegue" {
            if let groupProject = segue.destination as? GroupProjectsTableViewController {
                if let indexPath = sender as? IndexPath {
                    groupProject.group = groups[indexPath.row]
                    groupProject.title = groups[indexPath.row].name
                }
            }
        } else if segue.identifier == "projectSegue" {
            if let indexPath = sender as? IndexPath {
                let barViewControllers = segue.destination as! UITabBarController
                barViewControllers.title = projects[indexPath.row].name
                barViewControllers.viewControllers?.forEach {
                    if let vc = $0 as? ProjectDetailViewController {
                        vc.project = projects[indexPath.row]
                    }
                    if let vc = $0 as? ProjectCITableViewController {
                        vc.project = projects[indexPath.row]
                    }
                }
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
