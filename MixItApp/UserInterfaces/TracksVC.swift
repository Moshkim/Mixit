import UIKit



let kAppName = "MixIt"
class TracksVC: UIViewController,AMTSoundPickerDelegate {
    
    var isSavedToGallery = false
    var songLists = [String]()
    
    @IBOutlet weak var tblTracks: UITableView!
    //let fileManager: NSFileManager = NSFileManager.defaultManager()
    //let fileManager = NSFileManager.defaultManager()
    //let musicPath = NSBundle.mainBundle().pathForResource("2", ofType: "jpg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isSavedToGallery = false
    }
    
    /*override func viewDidLoad() {
        var path = NSBundle.mainBundle().resourcePath!
        path.appendContentsOf("/Music")
        let items = try! fileManager.contentsOfDirectoryAtPath(path)
        for item in items {
            songLists.append(item)
        }
        super.viewDidLoad()
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let numTracks = amtTrackManager.arrTracks!.count
        
        if(numTracks > 0) {
            for i in 0...numTracks-1 {
                amtTrackManager.setTrackVolume(1, index: i)
            }
        }
 
        tblTracks.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ListViewController" {
            /*
            let VC = segue.destinationViewController as UIViewController
            let indexPath: NSIndexPath = tblTracks.indexPathForSelectedRow!
            let track: AMTTrack = amtTrackManager.arrTracks![indexPath.row] as! AMTTrack
            VC.title = track.trackName
            */
            //var songListCount:Int = TracksVC.songLists.count
            //let indexP: NSIndexPath = tblTracks.indexPathsForSelectedRows!
            let indexPath: NSIndexPath = tblTracks.indexPathForSelectedRow!
            let track: AMTTrack = amtTrackManager.arrTracks![indexPath.row] as! AMTTrack
            let newProjectVC = segue.destinationViewController as! MediaPlayerViewController
            newProjectVC.audioURL = track.audioURL!.absoluteString
            newProjectVC.strTitle = track.trackName!
            newProjectVC.albums = amtTrackManager.arrTracks as! [AMTTrack]
//            for i in amtTrackManager.arrTracks! {
//                var trackNameTemp: AMTTrack = amtTrackManager.arrTracks![indexPath.row] as! AMTTrack
//                newProjectVC.albumTitle.append(trackNameTemp.trackName!)
//            }
            
            
            //newProjectVC.albumTitle = amtTrackManager.arrTracks!.
//            for tracks in amtTrackManager.arrTracks! as [AnyObject]{
//                //let index = amtTrackManager.arrTracks!.indexOf(track) as! AnyObject
//                //var trackNameTemp: AMTTrack = amtTrackManager.arrTracks![tracks] as! [AnyObject]
//                newProjectVC.albumTitle.append(amtTrackManager.arrTracks![indexPath])
//            }
            //newProjectVC.album
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (amtTrackManager.arrTracks?.count)!
    }
    /*
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = songLists[indexPath.row]
        return cell
    }*/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TrackCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath) as! TrackCell
        cell.sliderVolume.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(TracksVC.actionPlayTrack(_:)), forControlEvents: .TouchUpInside)
        //cell.textLabel?.text = songLists[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("ListViewController", sender: tableView)
    }
    
    @IBAction func actionDeleteTrack(sender: AnyObject) {
        if (amtTrackManager.player != nil && amtTrackManager.player!.rate != 0 && amtTrackManager.player!.error == nil)
        || (amtTrackManager.trackPlayer != nil && amtTrackManager.trackPlayer!.playing) {
            let alertViewController = IVMAlertController.initWithTitle("Error", Message: "Unable to delete audio clip during playing", LeftButton: "OK", RightButton: nil, leftBlock: nil, RightBlock: nil)
            self.presentViewController(alertViewController, animated: true, completion: { _ in })
            return
        }
        let buttonPosition: CGPoint = sender.convertPoint(CGPointZero, toView: tblTracks)
        let indexPath: NSIndexPath = tblTracks.indexPathForRowAtPoint(buttonPosition)!
        
        amtTrackManager.pauseTrack();
        amtTrackManager.deleteTrack(indexPath.row)
        self.isSavedToGallery = false
        amtTrackManager.trackMerged = false
        tblTracks.reloadData()
    }
    
    @IBAction func actionPlayTrack(sender: AnyObject) {
        if amtTrackManager.player != nil && amtTrackManager.player!.rate != 0 && amtTrackManager.player!.error == nil {
            let alertViewController = IVMAlertController.initWithTitle("Error", Message: "Unable to play audio clip during playing", LeftButton: "OK", RightButton: nil, leftBlock: nil, RightBlock: nil)
            self.presentViewController(alertViewController, animated: true, completion: { _ in })
            return
        }
        let buttonPosition: CGPoint = sender.convertPoint(CGPointZero, toView: tblTracks)
        let indexPath: NSIndexPath = tblTracks.indexPathForRowAtPoint(buttonPosition)!
        let button: UIButton = (sender as! UIButton)
        if !button.selected {
            button.selected = true
            amtTrackManager.playTrack(indexPath.row)
        }
        else {
            button.selected = false
            amtTrackManager.pauseTrack()
        }
        tblTracks.reloadData()
    }
    
    @IBAction func actionImportTrack(sender: AnyObject) {
        if amtTrackManager.player != nil && amtTrackManager.player?.rate != 0 && amtTrackManager.player?.error == nil {
            let alertViewController = IVMAlertController.initWithTitle("Error", Message: "Unable to import audio clip during playing", LeftButton: "OK", RightButton: nil, leftBlock: nil, RightBlock: nil)
            self.presentViewController(alertViewController, animated: true, completion: { _ in })
            return
        }
        AMTSoundPicker.sharedInstance().presentAudioPicker(self, delegate: self)
    }
    
    @IBAction func actionPlay(sender: UIButton) {
        if amtTrackManager.arrTracks!.count == 0 {
            let alertController = IVMAlertController.initWithTitle(kAppName, Message: "Please import an audio track.", LeftButton: "OK", RightButton: nil, leftBlock: nil, RightBlock: nil)
            self.presentViewController(alertController, animated: true, completion: { _ in })
            return
        }
        if sender.selected {
            sender.selected = false
            amtTrackManager.pauseComposition()
        }
        else {
            sender.selected = true
            amtTrackManager.playComposition()
        }
    }
    
    @IBAction func actionSliders(sender: UIButton) {
        if amtTrackManager.arrTracks!.count == 0 {
            let alertController = IVMAlertController.initWithTitle(kAppName, Message: "Please import an audio track.", LeftButton: "OK", RightButton: nil, leftBlock: nil, RightBlock: nil)
            self.presentViewController(alertController, animated: true, completion: { _ in })
            return
        }
        //print(sender.selected)
        //if sender.selected {
            //print("Test \(amtTrackManager.arrTracks!.count)")
        //}
    }
    
    @IBAction func actionVolumeChanged(sender: UISlider) {
        let buttonPosition: CGPoint = sender.convertPoint(CGPointZero, toView: tblTracks)
        let indexPath: NSIndexPath = tblTracks.indexPathForRowAtPoint(buttonPosition)!
        self.isSavedToGallery = false
        amtTrackManager.setTrackVolume(sender.value, index: indexPath.row)
        //print("Printing out volume: \(sender.value)")
    }
    
    @IBAction func actionOpenProject(sender: AnyObject) {
        self.performSegueWithIdentifier("SG_OPEN_PROJECT", sender: nil)
    }
    
    @IBAction func actionNewProject(sender: AnyObject) {
        let alertController = IVMAlertController.initWithTitle(kAppName, message: "Do you want to delete this project?", cancelButtonTitle: "Cancel", action: {(action: UIAlertAction) -> Void in
            if (action.title == "Yes") {
                amtTrackManager.trackMerged = false
                ProjectManager.deleteProject(amtTrackManager.currentProjectName)
                amtTrackManager.initTrackManager()
                self.tblTracks.reloadData()
            }
            else if (action.title == "No") {
                amtTrackManager.trackMerged = false
                amtTrackManager.initTrackManager()
                self.tblTracks.reloadData()
            }
            
            }, button: sender as! UIView, otherButtonTitles: ["Yes", "No", "Cancel"])
        self.presentViewController(alertController, animated: true, completion: { _ in })
    }
    
    @IBAction func actionSaveToGallery(sender: AnyObject) {
        amtTrackManager.playComposition()
        amtTrackManager.pauseComposition()
        if amtTrackManager.arrTracks!.count == 0 {
            let alertController = IVMAlertController.initWithTitle(kAppName, Message: "Please import an audio track.", LeftButton: "OK", RightButton: nil, leftBlock: nil, RightBlock: nil)
            self.presentViewController(alertController, animated: true, completion: { _ in })
            return
        }
        if amtTrackManager.player!.rate != 0 && amtTrackManager.player!.error == nil {
            let alertViewController = IVMAlertController.initWithTitle("Error", Message: "Unable to save multitrack audio file during playing", LeftButton: "OK", RightButton: nil, leftBlock: nil, RightBlock: nil)
            self.presentViewController(alertViewController, animated: true, completion: { _ in })
            return
        }

        
        DSBezelActivityView.newActivityViewForView(self.view!, withLabel: "Saving To Gallery", cancelTap: true)
        amtTrackManager.exportTracksToGallery({(outURL: NSURL) -> Void in
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                DSBezelActivityView.removeViewAnimated(true)
                let alertController: UIAlertController = IVMAlertController.initWithTitle("Success", Message: "Mutitrack Audio Files saved to Gallery!", LeftButton: "OK", RightButton: nil, leftBlock: nil, RightBlock: nil)
                self.presentViewController(alertController, animated: true, completion: { _ in })
            })
            }, failure: {(errorStr: String) -> Void in
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    let alertController: UIAlertController = IVMAlertController.initWithTitle("Error", Message: "Saving To Gallery Failed!", LeftButton: "OK", RightButton: nil, leftBlock: nil, RightBlock: nil)
                    self.presentViewController(alertController, animated: true, completion: { _ in })
                    DSBezelActivityView.removeViewAnimated(true)
                })
        })
    }
    
    func addAudio(track: AMTTrack) {
        self.isSavedToGallery = false
        amtTrackManager.trackMerged = false
        tblTracks.reloadData()
    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return amtTrackManager.arrTracks!.count
//    }
//    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    

    
    func tableView(tableView: UITableView, willDisplayCell cell: TrackCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let track: AMTTrack = amtTrackManager.arrTracks![indexPath.row] as! AMTTrack
        cell.lblAudioName.text = track.trackName
        cell.btnDelete.addTarget(self, action: #selector(TracksVC.actionDeleteTrack(_:)), forControlEvents: .TouchUpInside)
        //cell.btnPlay.addTarget(self, action: "actionPlayTrack:", forControlEvents: .TouchUpInside)
        cell.sliderVolume.addTarget(self, action: #selector(TracksVC.actionVolumeChanged(_:)), forControlEvents: .ValueChanged)
    }
    /*
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath {
        //    [self performSegueWithIdentifier:@"SG_EDIT_TRACK" sender:self];
        return indexPath
    }
    */
    
}

