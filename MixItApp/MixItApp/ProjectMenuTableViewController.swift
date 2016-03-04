//
//  ProjectMenuTableViewController.swift
//  MixItApp
//
//  Created by Michael Li on 3/3/16.
//  Copyright © 2016 MixMusicProduction. All rights reserved.
//

import UIKit

class ProjectMenuTableViewController: UITableViewController {
    
    var projects:[ProjectList] = projectData

    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is a list of projects")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projects.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProjectsCell", forIndexPath: indexPath)

        // Configure the cell...
        let project = projects[indexPath.row] as ProjectList
        cell.textLabel?.text = project.name
        cell.detailTextLabel?.text = "Number of tracks: " + String(project.numberOfTracks)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        //print(projects[row].name)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ProjectInfoList" {
            let VC = segue.destinationViewController as UIViewController
            let indexPath: NSIndexPath = tableView.indexPathForSelectedRow!
            let row = indexPath.row
            VC.title = projects[row].name
        }
    }

}

/*
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

if segue.identifier == "ListViewController" {
let VC = segue.destinationViewController as UIViewController
let indexPath: NSIndexPath = tableList.indexPathForSelectedRow!
VC.title = songLists[indexPath.row]

}
*/