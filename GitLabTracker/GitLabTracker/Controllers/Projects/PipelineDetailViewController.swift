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
            let res = Date.convertDateFormat(from: "yyyy-MM-dd'T'HH:mm:ss.zzzz", to: "MMMM dd yyyy", dateString: pipelineDetail?.createdAt)
            createdAtLabel.text = res
        }
    }
    
    
    
    @IBAction func retryJobClicked(_ sender: Any) {
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
