//
//  ProfilViewController.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 05/07/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import UIKit

class ProfilViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameImage: UIImageView!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    
    var userModel = UserModel()
    var events: [EventModel] = []
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        userModel.downloadData(completed: self.updateUI)
        logoutButtonOutlet.layer.cornerRadius = 10
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        usernameLabel.text = userModel.name
        let data = try? Data(contentsOf: userModel.avatarURL!)
        usernameImage.image = UIImage(data: data!)
        userModel.getEventsForUser(idUser: userModel.id!, completed: self.updateEvents)
    }
    
    func updateEvents(eventList: [EventModel]) {
        events = eventList
        self.eventTableView.reloadData()
        self.eventTableView.tableFooterView = UIView()
        if (myActivityIndicator.isAnimating) {
            myActivityIndicator.stopAnimating()
            myActivityIndicator.removeFromSuperview()
        }
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "token")
        let vc = self.storyboard?.instantiateInitialViewController()
        self.present(vc!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTableViewCell", for: indexPath) as! EventTableViewCell
        if events.count == 0 {
            return cell
        }
        cell.eventTitle.text = events[indexPath.row].message

        switch events[indexPath.row].actionName {
        case "opened":
            cell.eventImageView.image = UIImage(named: "issueIcon")
        case "accepted":
            cell.eventImageView.image = UIImage(named: "approvalIcon")
        case "pushed":
            cell.eventImageView.image = UIImage(named: "commitIcon")
        case "pushed to":
            cell.eventImageView.image = UIImage(named: "commitIcon")
        case "pushed new":
            cell.eventImageView.image = UIImage(named: "addIcon")
        case "merged":
            cell.eventImageView.image = UIImage(named: "branchIcon")
        case "issue":
            cell.eventImageView.image = UIImage(named: "issueIcon")
        case "merge_request":
            cell.eventImageView.image = UIImage(named: "branchIcon")
        case "deleted":
            cell.eventImageView.image = UIImage(named: "deletedIcon")
        default:
            break
        }
        let actionDate = Date.convertDateFormat(from: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", to: "MMMM dd yyyy HH:mm", dateString: events[indexPath.row].actionDate)

        cell.eventDetail.text = actionDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
