//
//  ViewController.swift
//  MixItApp
//
//  Created by KWANIL KIM on 2/21/16.
//  Copyright © 2016 MixMusicProduction. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let fileManager = NSFileManager.defaultManager()
    let musicPath = NSBundle.mainBundle().pathForResource("2", ofType: "jpg")

    var songLists = [String]()
    
    @IBOutlet weak var tableList: UITableView!
    
    override func viewDidLoad() {
        var path = NSBundle.mainBundle().resourcePath!
        path.appendContentsOf("/Music")
        let items = try! fileManager.contentsOfDirectoryAtPath(path)
        for item in items {
            songLists.append(item)
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "ListViewController" {
            let VC = segue.destinationViewController as UIViewController
            let indexPath: NSIndexPath = tableList.indexPathForSelectedRow!
            VC.title = songLists[indexPath.row]
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songLists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = songLists[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.performSegueWithIdentifier("ListViewController", sender: tableView)
    }
    
    
    
}

