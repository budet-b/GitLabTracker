//
//  ProjectDetailInfomationTableViewController.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 30/06/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import UIKit

class ProjectDetailInfomationTableViewController: UITableViewController {

    var project: ProjectModel?
    var type: ProjectInformation?
    var branchs: [BranchModel] = []
    var commits: [CommitModel] = []
    var issues: [IssueModel] = []
    var mergeRequests : [MergeRequestModel] = []
    var members: [MemberProject] = []
    var events: [EventModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type! {
        case .branch:
            project?.getBranchs(idProject: (project?.id)!, completed: self.updateBranchUI)
        case .commit:
            project?.getCommits(idProject: (project?.id)!, completed: self.updateCommitUI)
        case .issues:
            project?.getIssuesFromProject(idProject: (project?.id)!, completed: self.updateIssueUI)
        case .mergeRequest:
            project?.getMergeRequestsFromProject(idProject:  (project?.id)!, completed: self.updateMergeRequestUI)
        case .members:
            project?.getMembersFromProject(idProject:  (project?.id)!, completed: self.updateMembersUI)
        case .event:
            project?.getEventsFromProject(idProject: (project?.id)!, completed: self.updateEvent)
        default:
            break
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = project?.name
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMergeRequestUI(mergeRequestsList: [MergeRequestModel]) {
        mergeRequests = mergeRequestsList
        if (mergeRequests.count == 0) {
            let alert = UIAlertController(title: "No Merge requests found", message: "You are up to date !", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction((UIAlertAction(title: "Ok", style: .default, handler:
                { (action) -> Void in
                    self.navigationController?.popViewController(animated: true)
            })))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.tableView.reloadData()
        }
    }
    
    func updateEvent(eventList: [EventModel]) {
        events = eventList
        self.tableView.reloadData()
    }
    
    func updateCommitUI(commitList: [CommitModel]) {
        commits = commitList
        self.tableView.reloadData()
    }
    
    func updateMembersUI(memberList: [MemberProject]) {
        members = memberList
        self.tableView.reloadData()
    }
    
    func updateIssueUI(issueList: [IssueModel]) {
        issues = issueList
        if (issues.count == 0) {
            let alert = UIAlertController(title: "No issue found", message: "Good job, no issue found on your project !", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction((UIAlertAction(title: "Ok", style: .default, handler:
                { (action) -> Void in
                    self.navigationController?.popViewController(animated: true)
            })))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.tableView.reloadData()
        }
    }
    
    func updateBranchUI(branchsList: [BranchModel]) {
        branchs = branchsList
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch type! {
        case .branch:
            return branchs.count
        case .commit:
            return commits.count
        case .issues:
            return issues.count
        case .mergeRequest:
            return mergeRequests.count
        case .members:
            return members.count
        case .event:
            return events.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableDetailInformation", for: indexPath)
        switch type! {
        case .branch:
            cell.textLabel?.text = branchs[indexPath.row].name
            if (branchs[indexPath.row].name == project?.defaultBranch) {
                cell.textLabel?.textColor = UIColor.green
            }
            if (branchs[indexPath.row].merged)! {
                cell.detailTextLabel?.text = "Merged"
                cell.detailTextLabel?.textColor = UIColor.blue
            } else {
                cell.detailTextLabel?.text = "Active"
                cell.detailTextLabel?.textColor = UIColor.gray
            }
        case .commit:
            cell.textLabel?.text = commits[indexPath.row].message
            cell.detailTextLabel?.text = commits[indexPath.row].author_name
        case .issues:
            cell.textLabel?.text = issues[indexPath.row].title
            cell.detailTextLabel?.text = issues[indexPath.row].description
        case .mergeRequest:
            cell.textLabel?.text = mergeRequests[indexPath.row].title
            cell.detailTextLabel?.text = mergeRequests[indexPath.row].description
        case .members:
            cell.textLabel?.text = members[indexPath.row].username
            cell.detailTextLabel?.text = members[indexPath.row].state
            if (members[indexPath.row].state == "active") {
                cell.detailTextLabel?.textColor = UIColor.green
            } else {
                cell.detailTextLabel?.textColor = UIColor.red
            }
        case .event:
            cell.textLabel?.text = events[indexPath.row].message
            let res = Date.convertDateFormat(from: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", to: "MMMM dd yyyy HH:mm", dateString: events[indexPath.row].actionDate)
            cell.detailTextLabel?.text = res
        default:
            break
        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if type! == .mergeRequest {
            let webUrl = mergeRequests[indexPath.row].webUrl
            UIApplication.shared.open(URL(string : webUrl!)!, options: [:], completionHandler: nil)
        } else if type! == .members {
            let webUrl = members[indexPath.row].webUrl
            UIApplication.shared.open(URL(string : webUrl!)!, options: [:], completionHandler: nil)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
