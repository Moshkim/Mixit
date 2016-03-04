//
//  MediaPlayerViewController.swift
//  MixItApp
//
//  Created by KWANIL KIM on 2/21/16.
//  Copyright © 2016 MixMusicProduction. All rights reserved.
//

import UIKit
import AVFoundation

class MediaPlayerViewController: UIViewController {
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderController(sender: UISlider) {
        player.volume = slider.value
        // print(player.currentTime)    // may be useful when we implement sliders and stuff
    }
    
    @IBAction func stopButton(sender: UIBarButtonItem) {
        player.stop()
    }
    
    @IBAction func playButton(sender: UIBarButtonItem) {
        player.play()
    }
    
    @IBAction func pauseButton(sender: UIBarButtonItem) {
        player.pause()
    }
    @IBOutlet weak var nameOfTrack: UILabel!
    @IBOutlet weak var fileType: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let file = self.navigationItem.title!
        let s = self.navigationItem.title!.substringToIndex(self.navigationItem.title!.endIndex.advancedBy(-4))
        let ext = file.substringWithRange(Range<String.Index>(start: file.endIndex.advancedBy(-4), end: file.endIndex))
        let path = NSBundle.mainBundle().pathForResource(s, ofType: ext, inDirectory: "/Music")
        let filelocation = NSString(string: path!)
        player = try! AVAudioPlayer(contentsOfURL: NSURL(string: filelocation as String)!, fileTypeHint: AVFileTypeMPEGLayer3)
        
        // Obtain duration of current sound track in seconds.
        var duration: NSTimeInterval {
            get {
                if let nameOfPlayer:AVAudioPlayer? = player {
                    return nameOfPlayer!.duration
                }
                return 0
            }
        }
        
        // Print info to screen
        nameOfTrack.text = s
        fileType.text = ext
        let hours = String(Int(floor(duration / 3600)))
        let minutes = String(format:"%02d", Int(floor(duration / 60)))
        let seconds = String(format:"%02d", Int(floor(duration % 60)))
        trackDuration.text = hours + ":" + minutes + ":" + seconds
        
        //self.definesPresentationContext = true
        //self.tabBarController?.tabBar.hidden = true
        // Do any additional setup after loading the view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func viewDidAppear(animated: Bool) {
//        print(self.navigationItem.title!)
        let file = self.navigationItem.title!
        let s = self.navigationItem.title!.substringToIndex(self.navigationItem.title!.endIndex.advancedBy(-4))
        let ext = file.substringWithRange(Range<String.Index>(start: file.endIndex.advancedBy(-4), end: file.endIndex))
        let path = NSBundle.mainBundle().pathForResource(s, ofType: ext, inDirectory: "/Music")
        let filelocation = NSString(string: path!)
        
        do {
            player = try AVAudioPlayer(contentsOfURL: NSURL(string: filelocation as String)!, fileTypeHint: AVFileTypeMPEGLayer3)
            player.play()
        } catch let error as NSError {
            print("AV Sound Error: \(error.localizedDescription)")
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
