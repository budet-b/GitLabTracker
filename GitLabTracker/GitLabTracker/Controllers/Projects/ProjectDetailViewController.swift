//
//  ProjectDetailViewController.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 29/06/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var lastActivityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var defaultBranchLabel: UILabel!
    @IBOutlet weak var gitUrlLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var project: ProjectModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        projectName.text = project?.name
        defaultBranchLabel.text = project?.defaultBranch
        creationDateLabel.text = project?.createdAt?.description
        lastActivityLabel.text = project?.lastActivityAt?.description
        gitUrlLabel.text = project?.sshURL?.description
        visibilityLabel.text = project?.visibility
        self.tableViewOutlet.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Branch"
            cell.imageView?.image = UIImage(named: "branchIcon")
        case 1:
            cell.textLabel?.text = "Commits"
            cell.imageView?.image = UIImage(named: "commitIcon")
        case 2:
            cell.textLabel?.text = "Issues"
            cell.imageView?.image = UIImage(named: "issueIcon")
        case 3:
            cell.textLabel?.text = "Merge requests"
            cell.imageView?.image = UIImage(named: "mrIcon")
        case 4:
            cell.textLabel?.text = "Members"
            cell.imageView?.image = UIImage(named: "memberIcon")
        case 5:
            cell.textLabel?.text = "Events"
            cell.imageView?.image = UIImage(named: "activityIcon")
        default:
            cell.textLabel?.text = ""
        }
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
