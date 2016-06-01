//
//  MergeVC.swift
//

import Foundation
import UIKit

class MergeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let documentsURL =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    
    @IBOutlet weak var tableView: UITableView!
    var arrFiles = [String]()
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            for item in directoryContents {
                let filename = item.lastPathComponent!
                let ext = filename.substringWithRange(Range<String.Index>(start: filename.endIndex.advancedBy(-4), end: filename.endIndex))
                if(ext == ".m4a") {
                    arrFiles.append(item.lastPathComponent!)
                }
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFiles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        cell.textLabel?.text = self.arrFiles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let track: AMTTrack = AMTTrack()
        let name = self.arrFiles[indexPath.row].substringToIndex(self.arrFiles[indexPath.row].endIndex.advancedBy(-4))
        track.trackName = name
        var urlPath = NSURL()
        let urls = try! NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
        for item in urls {
            if self.arrFiles[indexPath.row] == item.lastPathComponent! {
                urlPath = item
            }
        }
        
        track.audioURL = urlPath
        track.trackVolume = 1.0
        amtTrackManager.arrTracks?.append(track)
        
        self.dismissViewControllerAnimated(true, completion: { _ in })
        

    }
}