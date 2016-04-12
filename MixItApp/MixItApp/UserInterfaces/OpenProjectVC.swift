//
//  OpenProjectVC.swift


import Foundation
import UIKit

class OpenProjectVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblProjects: UITableView!
    var arrProjects : [AnyObject]?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.arrProjects = nil
        self.arrProjects = ProjectManager.getProjectList()
        tblProjects.reloadData()
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProjects!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ProjectCell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "ProjectCell")
        }
        cell!.textLabel!.text = arrProjects![indexPath.row] as? String
        return cell!
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        self.dismissViewControllerAnimated(true, completion: { _ in })
        amtTrackManager.initTrackManager()
        amtTrackManager.currentProjectName = arrProjects![indexPath.row] as! String
        amtTrackManager.arrTracks = ProjectManager.openProject(arrProjects![indexPath.row] as! String)
        amtTrackManager.trackMerged = false
        return indexPath
    }
}