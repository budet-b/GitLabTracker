//
//  ProjectDetailViewController.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 29/06/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import UIKit

enum ProjectInformation: Int {
    case branch = 0
    case commit = 1
    case issues = 2
    case mergeRequest = 3
    case members = 4
    case event = 5
}

class ProjectDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var lastActivityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var defaultBranchLabel: UILabel!
    @IBOutlet weak var gitUrlLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var project: ProjectModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Grodrigue"
        self.navigationController?.title = "Didier"
        self.navigationController?.navigationItem.title = "didié"
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let createdAt = Date.convertDateFormat(from: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", to: "MMMM dd yyyy HH:mm", dateString: project?.createdAt)
        let lastActivity = Date.convertDateFormat(from: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", to: "MMMM dd yyyy HH:mm", dateString: project?.lastActivityAt)

        defaultBranchLabel.text = project?.defaultBranch
        creationDateLabel.text = createdAt
        lastActivityLabel.text = lastActivity
        gitUrlLabel.text = project?.sshURL?.description
        visibilityLabel.text = project?.visibility
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.tableViewOutlet.tableFooterView = UIView()
        self.title = project?.name
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var type = ProjectInformation.branch
        switch indexPath.row {
        case 0:
            type = .branch
        case 1:
            type = .commit
        case 2:
            type = .issues
        case 3:
            type = .mergeRequest
        case 4:
            type = .members
        case 5:
            type = .event
        default:
            break
        }
        performSegue(withIdentifier: "detailProject", sender: type)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailProject" {
            if let type = sender as? ProjectInformation {
                if let vc = segue.destination as? ProjectDetailInfomationTableViewController {
                    vc.project = project
                    vc.type = type
                }
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
