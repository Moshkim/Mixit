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
    
    var player: AVAudioPlayer = AVAudioPlayer()
    
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBAction func volumeController(sender: UISlider) {
        player.volume = volumeSlider.value
    }
    @IBAction func stopButton(sender: AnyObject) {
        player.stop()
    }
    @IBAction func playButton(sender: AnyObject) {
        player.play()
    }
    @IBAction func pauseButton(sender: AnyObject) {
        player.pause()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
//        
//        var filelocation = NSString(string: NSBundle().pathForResource(self.navigationItem.title, ofType: "mp3")!)
//        var error: NSError? = nil
        
        //        player = AVAudioPlayer(contentsOfURL: NSURL(string: filelocation as String)!)
        //        init() {
        //            do {
        //                try player = AVAudioPlayer(contentsOfURL: NSURL(string: filelocation), fileTypeHint: nil)
        //            } catch {
        //                print(error)
        //            }
        //        
        
        
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


