//
//  ViewController.swift
//  MixItApp
//
//  Created by KWANIL KIM on 2/21/16.
//  Copyright © 2016 MixMusicProduction. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MPMediaPickerControllerDelegate, AVAudioPlayerDelegate  {
    
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
      /*  title = "Media picker..."
        
        buttonPickAndPlay = UIButton(type: .System)
        
        if let pickAndPlay = buttonPickAndPlay{
            pickAndPlay.frame = CGRect(x: 0, y: 0, width: 200, height: 37)
            pickAndPlay.center = CGPoint(x: view.center.x, y: view.center.y - 50)
            pickAndPlay.setTitle("Pick and Play", forState: .Normal)
            pickAndPlay.addTarget(self,
                action: "displayMediaPickerAndPlayItem",
                forControlEvents: .TouchUpInside)
            view.addSubview(pickAndPlay)
        }
        
        buttonStopPlaying = UIButton(type: .System)
        
        if let stopPlaying = buttonStopPlaying{
            stopPlaying.frame = CGRect(x: 0, y: 0, width: 200, height: 37)
            stopPlaying.center = CGPoint(x: view.center.x, y: view.center.y + 50)
            stopPlaying.setTitle("Stop Playing", forState: .Normal)
            stopPlaying.addTarget(self,
                action: "stopPlayingAudio",
                forControlEvents: .TouchUpInside)
            view.addSubview(stopPlaying)
        }*/
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
    
   /* var myMusicPlayer: MPMusicPlayerController?
    var buttonPickAndPlay: UIButton?
    var buttonStopPlaying: UIButton?
    var mediaPicker: MPMediaPickerController?
    
    func musicPlayerStateChanged(notification: NSNotification){
        
        print("Player State Changed")
        
        /* Let's get the state of the player */
        let stateAsObject =
        notification.userInfo!["MPMusicPlayerControllerPlaybackStateKey"]
            as? NSNumber
        
        if let state = stateAsObject{
            
            /* Make your decision based on the state of the player */
            switch MPMusicPlaybackState(rawValue: state.integerValue)!{
            case .Stopped:
                /* Here the media player has stopped playing the queue. */
                print("Stopped")
            case .Playing:
                /* The media player is playing the queue. Perhaps you
                can reduce some processing that your application
                that is using to give more processing power
                to the media player */
                print("Paused")
            case .Paused:
                /* The media playback is paused here. You might want
                to indicate by showing graphics to the user */
                print("Paused")
            case .Interrupted:
                /* An interruption stopped the playback of the media queue */
                print("Interrupted")
            case .SeekingForward:
                /* The user is seeking forward in the queue */
                print("Seeking Forward")
            case .SeekingBackward:
                /* The user is seeking backward in the queue */
                print("Seeking Backward")
            }
            
        }
    }
    
    func nowPlayingItemIsChanged(notification: NSNotification){
        
        print("Playing Item Is Changed")
        
        let key = "MPMusicPlayerControllerNowPlayingItemPersistentIDKey"
        
        let persistentID =
        notification.userInfo![key] as? NSString
        
        if let id = persistentID{
            /* Do something with Persistent ID */
            print("Persistent ID = \(id)")
        }
        
    }
    
    func volumeIsChanged(notification: NSNotification){
        print("Volume Is Changed")
        /* The userInfo dictionary of this notification is normally empty */
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController,
        didPickMediaItems mediaItemCollection: MPMediaItemCollection){
            
            print("Media Picker returned")
            
            /* Instantiate the music player */
            
            myMusicPlayer = MPMusicPlayerController()
            
            if let player = myMusicPlayer{
                player.beginGeneratingPlaybackNotifications()
                
                /* Get notified when the state of the playback changes */
                NSNotificationCenter.defaultCenter().addObserver(self,
                    selector: "musicPlayerStateChanged:",
                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification,
                    object: nil)
                
                /* Get notified when the playback moves from one item
                to the other. In this recipe, we are only going to allow
                our user to pick one music file */
                NSNotificationCenter.defaultCenter().addObserver(self,
                    selector: "nowPlayingItemIsChanged:",
                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
                    object: nil)
                
                /* And also get notified when the volume of the
                music player is changed */
                NSNotificationCenter.defaultCenter().addObserver(self,
                    selector: "volumeIsChanged:",
                    name: MPMusicPlayerControllerVolumeDidChangeNotification,
                    object: nil)
                
                /* Start playing the items in the collection */
                player.setQueueWithItemCollection(mediaItemCollection)
                player.play()
                
                /* Finally dismiss the media picker controller */
                mediaPicker.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        /* The media picker was cancelled */
        print("Media Picker was cancelled")
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func stopPlayingAudio(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if let player = myMusicPlayer{
            player.stop()
        }
        
    }
    
    func displayMediaPickerAndPlayItem(){
        
        mediaPicker = MPMediaPickerController(mediaTypes: .AnyAudio)
        
        if let picker = mediaPicker{
            
            
            print("Successfully instantiated a media picker")
            picker.delegate = self
            picker.allowsPickingMultipleItems = true
            picker.showsCloudItems = true
            picker.prompt = "Pick a song please..."
            view.addSubview(picker.view)
            
            presentViewController(picker, animated: true, completion: nil)
            
        } else {
            print("Could not instantiate a media picker")
        }
        
    }*/
    
    
    
}
