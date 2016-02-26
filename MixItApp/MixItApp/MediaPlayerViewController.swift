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
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.definesPresentationContext = true
        //self.tabBarController?.tabBar.hidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
//        print(self.navigationItem.title!)
        let s = self.navigationItem.title!.substringToIndex(self.navigationItem.title!.endIndex.advancedBy(-4))
        NSLog(s)
        let path = NSBundle.mainBundle().pathForResource(s, ofType: "mp3", inDirectory: "/Music")
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
