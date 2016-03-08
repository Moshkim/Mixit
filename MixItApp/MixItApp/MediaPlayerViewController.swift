//
//  MediaPlayerViewController.swift
//  MixItApp
//
//  Created by KWANIL KIM on 2/21/16.
//  Copyright © 2016 MixMusicProduction. All rights reserved.
//

import UIKit
import AVFoundation

class MediaPlayerViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Initialization
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let file = self.navigationItem.title!
        let s = self.navigationItem.title!.substringToIndex(self.navigationItem.title!.endIndex.advancedBy(-4))
        let ext = file.substringWithRange(Range<String.Index>(start: file.endIndex.advancedBy(-4), end: file.endIndex))
        let path = NSBundle.mainBundle().pathForResource(s, ofType: ext, inDirectory: "/Music")
        let filelocation = NSString(string: path!)
        player = try! AVAudioPlayer(contentsOfURL: NSURL(string: filelocation as String)!, fileTypeHint: AVFileTypeMPEGLayer3)
        
        // Get duration of current sound track in seconds
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
        let minutes = String(format:"%02d", Int(floor((duration / 60) % 60)))
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
    
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    
    
    
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
    
    // MARK: Actions
    
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.

        
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    
}
