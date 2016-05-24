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


class MediaPlayerViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, iCarouselDataSource,iCarouselDelegate{
    
    
    //AMTSoundPickerDelegate
    
    // MARK: Initialization
    
    @IBOutlet weak var RatingView: CosmosView!
    @IBOutlet weak var ratingSlider: UISlider!
    
    @IBOutlet weak var carouselView: iCarousel!
    
    
    //MARK: Album Slider
    var albums = [AMTTrack]()
    var albumList = [AMTTrack]()
    var albumTitle = [String]()
    var albumURL = [String]()
    var images: NSMutableArray = NSMutableArray()
    
    //var albums1: AMTTrack
    var audioURL = ""
    var strTitle = ""
    var selectedIndex: Int!
    private let startRating:Float = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib???")
    }
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    
    //@IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var fastForwardRewind: UISlider!
    
    @IBOutlet weak var titleName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = NSMutableArray(array:["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jpg","7.jpg","8.jpg","9.jpg","10.jpg"])
        
        carouselView.type = .TimeMachine
        carouselView.reloadData()
        
        RatingView.didTouchCosmos = didTouchCosmos
        RatingView.didFinishTouchingCosmos = didFinishTouchingCosmos
        

    }
    
    
    override func viewDidAppear(animated: Bool) {
        

        //carouselView.reloadData()
        //let file = self.navigationItem.title!
        //let s = self.navigationItem.title!.substringToIndex(self.navigationItem.title!.endIndex.advancedBy(-4))
        titleName.text = self.strTitle as String
        //let ext = file.substringWithRange(Range<String.Index>(start: file.endIndex.advancedBy(-4), end: file.endIndex))
        //let path = NSBundle.mainBundle().pathForResource(s, ofType: ext, inDirectory: "/Music")
        //let filelocation = NSString(string: path!)
        
        do {
            player = try AVAudioPlayer(contentsOfURL: NSURL(string: self.audioURL as String)!, fileTypeHint: AVFileTypeMPEGLayer3)
            player.play()
            fastForwardRewind.maximumValue = Float(player.duration)
            
            print("does it gets here first - viewDidAppear???")
            //albumList = albums

            print(albumList)
            print(albumTitle)
            print(albumList.count)

            
        } catch let error as NSError {
            print("AV Sound Error: \(error.localizedDescription)")
        }
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(MediaPlayerViewController.updateSlider), userInfo: nil, repeats: true)
    }
    

    
    private func updateRating() {
        let value = Double(ratingSlider.value)
        RatingView.rating = value
    }
    
    private func didTouchCosmos(rating: Double) {
        ratingSlider.value = Float(rating)

    }
    
    private func didFinishTouchingCosmos(rating: Double) {
        ratingSlider.value = Float(rating)
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        print(albumList.count)
        print("does it gets here???")
        return albums.count
    }
    
    

    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        selectedIndex = index
        if player.play() {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            } catch _ {
            }
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            }catch _ {
            }
            
            UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
            //player.stop()
            //player.prepareToPlay()
            titleName.text = albums[selectedIndex].trackName!
            player = try! AVAudioPlayer(contentsOfURL: albums[selectedIndex].audioURL!)
            fastForwardRewind.maximumValue = Float(player.duration)
            player.play()
            //CosmosDefaultSettings.rating = 0
            //player.delegate = self
        }
        else{
            player = try! AVAudioPlayer(contentsOfURL: albums[selectedIndex].audioURL!)
            fastForwardRewind.maximumValue = Float(player.duration)
            player.play()
            //CosmosDefaultSettings.rating = 0
            
        }
        //self.performSegueWithIdentifier("ListViewController", sender: self)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "ListViewController"){
//            //albumList = albums as [String]!
//            //audioURL = albums[selectedIndex] as String
//            //let newAlbum = NSIndexPath =
//            let newAlbum = segue.destinationViewController as! MediaPlayerViewController
//            newAlbum.audioURL = albums[selectedIndex].audioURL!.absoluteString
//            newAlbum.strTitle = albums[selectedIndex].trackName!
//            newProjectVC.audioURL = track.audioURL!.absoluteString
//            newProjectVC.strTitle = track.trackName!
//            newProjectVC.albums = amtTrackManager.arrTracks as! [AMTTrack]
//            let urlString = albums[selectedIndex].audioURL!.absoluteString
//            titleName.text = albums[selectedIndex].trackName
//            
//            do {
//                player = try AVAudioPlayer(contentsOfURL: NSURL(string: urlString)!, fileTypeHint: AVFileTypeMPEGLayer3)
//        
//            }catch let error as NSError {
//                print("AV Sound Error: \(error.localizedDescription)")
//            }
//        }
//    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if(segue.identifier == "ListViewController"){
//            //let indexPath: NSIndexPath = carouselView.indexOfItemView()
//            //let newProjectVC1 = segue.destinationViewController as! MediaPlayerViewController
//            player = try AVAudioPlayer(contentsOfURL: NSURL(string: self.audioURL as String)!, fileTypeHint: AVFileTypeMPEGLayer3)
//            //newProjectVC1.strTitle = self.albumList as! String
//        
//        }
//    }
    
//    func playTrack(index: Int) {
//        self.trackPlayer = nil
//        let track: AMTTrack = self.arrTracks![index] as! AMTTrack
//        do{
//            self.trackPlayer = try AVAudioPlayer(contentsOfURL: track.audioURL!, fileTypeHint: nil)
//            self.trackPlayer!.play()
//        }catch {
//            
//        }
//        
//    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
        let mainView = UIImageView(frame: CGRect(x:0, y:0, width: 244, height: 244))
        let Button = UIButton(frame: CGRect(x:0, y:0, width: 244, height: 244))
        
        
        Button.setTitle("\(albums[index].trackName)", forState: .Normal)
        Button.setTitleColor(UIColor.cyanColor(), forState: .Normal)
        mainView.image = UIImage(named: "\(images.objectAtIndex(index))")
        Button.backgroundColor = UIColor.clearColor()
        mainView.addSubview(Button)
        return mainView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.Spacing{
            return value * 1.0
        }
        return value
    }
    
//    func carouselWillBeginScrollingAnimation(carousel: iCarousel) {
//        <#code#>
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        player.stop()
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    // MARK: Properities
    // This override func will recognize the song lists and

    
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
