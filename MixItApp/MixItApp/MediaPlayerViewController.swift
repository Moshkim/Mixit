//
//  MediaPlayerViewController.swift
//  MixItApp
//
//  Created by KWANIL KIM on 2/21/16.
//  Copyright © 2016 MixMusicProduction. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation


class MediaPlayerViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Initialization
    
    var audioURL = ""
    var strTitle = ""
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var fastForwardRewind: UISlider!
    
    @IBOutlet weak var titleName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    // MARK: Properities
    // This override func will recognize the song lists and
    override func viewDidAppear(animated: Bool) {
        //let file = self.navigationItem.title!
        //let s = self.navigationItem.title!.substringToIndex(self.navigationItem.title!.endIndex.advancedBy(-4))
        titleName.text = self.strTitle as String
        //let ext = file.substringWithRange(Range<String.Index>(start: file.endIndex.advancedBy(-4), end: file.endIndex))
        //let path = NSBundle.mainBundle().pathForResource(s, ofType: ext, inDirectory: "/Music")
        //let filelocation = NSString(string: path!)
        
        do {
            /*player = try AVAudioPlayer(contentsOfURL: NSURL(string: filelocation as String)!, fileTypeHint: AVFileTypeMPEGLayer3)
            player.play()
            */
            /*player = try AVAudioPlayer(contentsOfURL: NSURL(string: filelocation as String)!, fileTypeHint: AVFileTypeMPEGLayer3)
            
            player.play()*/
            player = try AVAudioPlayer(contentsOfURL: NSURL(string: self.audioURL as String)!, fileTypeHint: AVFileTypeMPEGLayer3)
            player.play()
            
        } catch let error as NSError {
            print("AV Sound Error: \(error.localizedDescription)")
        }
        fastForwardRewind.maximumValue = Float(player.duration)
        var Timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateSlider"), userInfo: nil, repeats: false)
    }
    
    
    
    //    func updateTime() {
    //        var currentTime = Int(player.currentTime)
    //        var minutes = currentTime/60
    //        var seconds = currentTime - minutes * 60
    //
    //        //.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    //    }
    
    
    //
    //    fastForwardRewind.maximumValue = CMTimeGetSeconds([player duration]);
    //    fastForwardRewind.value = CMTimeGetSeconds(player.currentTime);
    //    player.currentTime = CMTimeMakeWithSeconds((int)slider.value,1);
    //    func updateTime() {
    //        var currentTime = Int(player.currentTime)
    //        var minutes = currentTime/60
    //        var seconds = currentTime - minutes * 60
    //        playedTime.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    //    }
    
    
    // MARK: Actions
    
    @IBAction func sildeValue(sender: UISlider) {
        player.stop()
        player.currentTime = NSTimeInterval(fastForwardRewind.value)
        player.prepareToPlay()
        player.play()
        
    }
    func updateSlider() {
        
        fastForwardRewind.value = Float(player.currentTime)
    }
    
    @IBAction func pauseButton(sender: UIButton) {
        if player.play() == true {
            player.pause()
        }
    }
    
    @IBAction func playButton(sender: UIButton) {
        
        player.play()
    }
    


    
    @IBAction func stopButton(sender: UIButton) {
        player.stop()
        player.currentTime = 0.0
        fastForwardRewind.value = Float(player.currentTime)
        
    }
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info iinctionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
}
