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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        project?.getSingleCI(idProject: (project?.id)!, idPipeline: (pipeline?.id)!, completed: self.updateUI)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(pipeline: PipelineModel?) {
        if (pipeline != nil) {
            pipelineDetail = pipeline
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
