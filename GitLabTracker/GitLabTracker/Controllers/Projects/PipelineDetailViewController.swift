//
//  PipelineDetailViewController.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 01/07/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import UIKit

class PipelineDetailViewController: UIViewController {

    var pipeline: CIModel?
    var project: ProjectModel?
    var pipelineDetail: PipelineModel?
    
    @IBOutlet weak var retryJobButton: UIButton!
    @IBOutlet weak var branchNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var finishedAtLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var triggeredByLabel: UILabel!
    
    @IBOutlet weak var triggeredByAvatar: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        project?.getSingleCI(idProject: (project?.id)!, idPipeline: (pipeline?.id)!, completed: self.updateUI)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(pipelineReceived: PipelineModel?) {
        if (pipelineReceived != nil) {
            pipelineDetail = pipelineReceived
            branchNameLabel.text = pipeline?.ref
            statusLabel.text = pipelineDetail?.status
            if (statusLabel.text == "success") {
                statusLabel.textColor = UIColor.green
            } else {
                statusLabel.textColor = UIColor.red
            }
            let res = Date.convertDateFormat(from: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", to: "MMMM dd yyyy HH:mm", dateString: pipelineDetail?.createdAt)
            let res2  = Date.convertDateFormat(from: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", to: "MMMM dd yyyy HH:mm", dateString: pipelineDetail?.finishedAt)
            finishedAtLabel.text = res2
            triggeredByLabel.text = pipelineDetail?.triggerByName
            let url = URL(string: (pipelineDetail?.triggerByUrl)!)
            let data = try? Data(contentsOf: url!)
            if (data != nil) {
                triggeredByAvatar.image = UIImage(data: data!)
            } else {
                triggeredByAvatar.image = UIImage(named: "placeholder")
            }
            let (_,m,s) = secondsToHoursMinutesSeconds(seconds: (pipelineDetail?.duration)!)
            createdAtLabel.text = res
            let minutes = String(m)
            let seconds = String(s)
            let finalString = "\(minutes) : \(seconds)"
            durationLabel.text = finalString
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    @IBAction func retryJobClicked(_ sender: Any) {
        if pipelineDetail?.status == "success" {
            let alert = UIAlertController(title: "Job Retry", message: "Cannot retry a succedded job", preferredStyle: .actionSheet)
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            if (pipelineDetail != nil) {
                pipelineDetail?.retryJob(idProject: (project?.id)!, pipelineId: (pipeline?.id)!, completed: self.finishedRetry)
            }
        }
    }
    
    func finishedRetry(res: Bool) {
        if (res) {
            let alert = UIAlertController(title: "Job Retry", message: "success", preferredStyle: .actionSheet)
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Job Retry", message: "fail", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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

extension Date {
    static func convertDateFormat(from: String, to: String, dateString: String?) -> String? {
        let fromDateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = from
        var formattedDateString: String? = nil
        if dateString != nil {
            let formattedDate = fromDateFormatter.date(from: dateString!)
            if formattedDate != nil {
                let toDateFormatter = DateFormatter()
                toDateFormatter.dateFormat = to
                formattedDateString = toDateFormatter.string(from: formattedDate!)
            }
        }
        return formattedDateString
    }
}
