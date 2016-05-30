//
//  VolumeSliders.swift
//  MixItApp
//
//  Created by Michael Li on 3/31/16.
//  Copyright © 2016 MixMusicProduction. All rights reserved.
//
//  Sources used:
//  - Creating sliders programmatically: http://rkiosdev.blogspot.com/2014/07/programmatically-designing-user.html
//  - Scrollview: https://www.youtube.com/watch?v=PGAHR2Ji7jc

import UIKit

var scrollView: UIScrollView!

var sliderlabel = UILabel()
let maxSliders = 40
//var sliderCount = amtTrackManager.arrTracks!.count    // number of sliders created

class VolumeSliders: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var sliderCount = amtTrackManager.arrTracks!.count // number of sliders created
        
        // for debugging purposes
        let width = UIScreen.mainScreen().bounds.width
        //print("Width: \(width)")
        let height = UIScreen.mainScreen().bounds.height
        //print("Height: \(height)")
        
        // Create a scrollView that will hold all of the sliders.
        // This does not include the toolbar on the bottom of the same screen.
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.height, 0)  // was 0 0 self.view.frame.width 0
        //print("Testing \(self.view.frame.width)")
        //print("Testing2 \(self.view.frame.height)")
        //let scrollViewWidth = self.scrollView.frame.width
        //let scrollViewHeight = self.scrollView.frame.height
        
        
        //scrollView = UIScrollView(frame: view.bounds)
        //scrollView.contentSize = CGSize(width: 9999,height: 9999)
        //view.addSubview(scrollView)
        // Code to add sliders for adjusting volume
        var slider = [UISlider!](count: maxSliders, repeatedValue: nil)
        var label = [UILabel!](count: maxSliders, repeatedValue: nil)
        var val = [UILabel!](count:maxSliders, repeatedValue: nil)
        
        if sliderCount > 40 {
            sliderCount = 40
        }
        
        // default number of sliders to create is 7
        for i in 0...sliderCount-1 {    // was 0...6
            print("Testing again \(amtTrackManager.arrTracks!.count)")
            print("Creating slider: \(i)")
            if i % 2 == 0 { // odd numbered slider
                //func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect
                // first parameter of CGRectMake is the offset of the slider which depends on the (i+1)th slider being created. the label requires adding a value to the offset so that the label is right next to the slider.
                slider[i] = UISlider(frame:CGRectMake(20+CGFloat(i)*70.0, 0, (width/2)*0.7, 190))    // was 167 190
                label[i] = UILabel(frame: CGRectMake(20+CGFloat(i)*70.0+20, 0, (width/2)*0.7, 190))
                label[i].text = String(i+1)
                //slider[i].maximumValueImage = UIImage(named: "settings-32")
            } else {    // even numbered slider
                slider[i] = UISlider(frame:CGRectMake(20+CGFloat(i-1)*70.0, (width/2)*0.8, (width/2)*0.7, 190))
                label[i] = UILabel(frame: CGRectMake(20+CGFloat(i-1)*70.0+20, (width/2)*0.8, (width/2)*0.7, 190))
                label[i].text = String(i+1)
                //slider[i].maximumValueImage = UIImage(named: "settings-32")
            }
            
            // may want to store this in a different Swift file
            //slider[i].audioPlayer
            slider[i].minimumValue = 0
            slider[i].maximumValue = 1
            slider[i].continuous = true
            slider[i].value = 1
            amtTrackManager.setTrackVolume(slider[i].value, index: i)
            if(i == 0) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange0(_:)), forControlEvents: .ValueChanged)
            } else if(i == 1) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange1(_:)), forControlEvents: .ValueChanged)
            } else if(i == 2) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange2(_:)), forControlEvents: .ValueChanged)
            } else if(i == 3) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange3(_:)), forControlEvents: .ValueChanged)
            } else if(i == 4) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange4(_:)), forControlEvents: .ValueChanged)
            } else if(i == 5) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange5(_:)), forControlEvents: .ValueChanged)
            } else if(i == 6) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange6(_:)), forControlEvents: .ValueChanged)
            } else if(i == 7) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange7(_:)), forControlEvents: .ValueChanged)
            } else if(i == 8) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange8(_:)), forControlEvents: .ValueChanged)
            } else if(i == 9) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange9(_:)), forControlEvents: .ValueChanged)
            } else if(i == 10) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange10(_:)), forControlEvents: .ValueChanged)
            } else if(i == 11) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange11(_:)), forControlEvents: .ValueChanged)
            } else if(i == 12) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange12(_:)), forControlEvents: .ValueChanged)
            } else if(i == 13) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange13(_:)), forControlEvents: .ValueChanged)
            } else if(i == 14) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange14(_:)), forControlEvents: .ValueChanged)
            } else if(i == 15) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange15(_:)), forControlEvents: .ValueChanged)
            } else if(i == 16) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange16(_:)), forControlEvents: .ValueChanged)
            } else if(i == 17) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange17(_:)), forControlEvents: .ValueChanged)
            } else if(i == 18) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange18(_:)), forControlEvents: .ValueChanged)
            } else if(i == 19) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange19(_:)), forControlEvents: .ValueChanged)
            } else if(i == 20) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange20(_:)), forControlEvents: .ValueChanged)
            } else if(i == 21) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange21(_:)), forControlEvents: .ValueChanged)
            } else if(i == 22) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange22(_:)), forControlEvents: .ValueChanged)
            } else if(i == 23) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange23(_:)), forControlEvents: .ValueChanged)
            } else if(i == 24) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange24(_:)), forControlEvents: .ValueChanged)
            } else if(i == 25) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange25(_:)), forControlEvents: .ValueChanged)
            } else if(i == 26) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange26(_:)), forControlEvents: .ValueChanged)
            } else if(i == 27) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange27(_:)), forControlEvents: .ValueChanged)
            } else if(i == 28) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange28(_:)), forControlEvents: .ValueChanged)
            } else if(i == 29) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange29(_:)), forControlEvents: .ValueChanged)
            } else if(i == 30) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange30(_:)), forControlEvents: .ValueChanged)
            } else if(i == 31) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange31(_:)), forControlEvents: .ValueChanged)
            } else if(i == 32) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange32(_:)), forControlEvents: .ValueChanged)
            } else if(i == 33) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange33(_:)), forControlEvents: .ValueChanged)
            } else if(i == 34) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange34(_:)), forControlEvents: .ValueChanged)
            } else if(i == 35) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange35(_:)), forControlEvents: .ValueChanged)
            } else if(i == 36) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange36(_:)), forControlEvents: .ValueChanged)
            } else if(i == 37) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange37(_:)), forControlEvents: .ValueChanged)
            } else if(i == 38) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange38(_:)), forControlEvents: .ValueChanged)
            } else if(i == 39) {
                slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange39(_:)), forControlEvents: .ValueChanged)
            }
            slider[i].transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
            
            self.scrollView.addSubview(slider[i])
            self.scrollView.addSubview(label[i])
            
        }
        /*
         // after 7 sliders are created, check to see if more sliders are needed.
         if sliderCount > 7 {
         for i in 1...sliderCount-1 {    // was 1...sliderCount-1
         print("Creating slider: \(i)")
         if i % 2 == 0 {
         //func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect
         slider[i] = UISlider(frame:CGRectMake(20+CGFloat(i)*70.0, 0, (width/2)*0.7, 190))
         label[i] = UILabel(frame: CGRectMake(20+CGFloat(i)*70.0+20, 0, (width/2)*0.7, 190))
         label[i].text = String(i+1)
         //slider[i].maximumValueImage = UIImage(named: "settings-32")
         } else {    // y coord was 225
         slider[i] = UISlider(frame:CGRectMake(20+CGFloat(i-1)*70.0, (width/2)*0.8, (width/2)*0.7, 190))
         label[i] = UILabel(frame: CGRectMake(20+CGFloat(i-1)*70.0+20, (width/2)*0.8, (width/2)*0.7, 190))
         label[i].text = String(i+1)
         //slider[i].maximumValueImage = UIImage(named: "settings-32")
         }
         slider[i].minimumValue = 0
         slider[i].maximumValue = 1
         slider[i].continuous = true
         slider[i].value = 1
         slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange(_:)), forControlEvents: .ValueChanged)
         slider[i].transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
         
         self.scrollView.addSubview(slider[i])
         self.scrollView.addSubview(label[i])
         
         }
         }
         */
        // set the size of the scrollview
        if(sliderCount % 2 != 0) {
            self.scrollView.contentSize = CGSizeMake(ceil(CGFloat((sliderCount+1)/2+1))*135, self.scrollView.frame.height)
        } else {
            self.scrollView.contentSize = CGSizeMake(ceil(CGFloat(sliderCount/2+1))*135, self.scrollView.frame.height)
        }
        //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width*5, self.scrollView.frame.height)
        
        /*
         slider[0] = UISlider(frame:CGRectMake(20, 260, 167, 178))
         slider[0].minimumValue = 0
         slider[0].maximumValue = 100
         slider[0].continuous = true
         slider[0].value = 50
         slider[0].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange(_:)), forControlEvents: .ValueChanged)
         
         self.view.addSubview(slider[0])
         slider[0].transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
         
         slider[1] = UISlider(frame:CGRectMake(-20, 0, self.view.frame.width-40, 20))
         slider[1].minimumValue = 0
         slider[1].maximumValue = 100
         slider[1].continuous = true
         slider[1].value = 50
         slider[1].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange(_:)), forControlEvents: .ValueChanged)
         
         self.view.addSubview(slider[1])
         slider[1].transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
         */
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    // Make sure the screen is in landscape view when this screen is reached.
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // Here are all of the sliderValueDidChange functions.
    func sliderValueDidChange0(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 0)
    }
    func sliderValueDidChange1(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 1)
    }
    func sliderValueDidChange2(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 2)
    }
    func sliderValueDidChange3(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 3)
    }
    func sliderValueDidChange4(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 4)
    }
    func sliderValueDidChange5(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 5)
    }
    func sliderValueDidChange6(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 6)
    }
    func sliderValueDidChange7(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 7)
    }
    func sliderValueDidChange8(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 8)
    }
    func sliderValueDidChange9(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 9)
    }
    func sliderValueDidChange10(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 10)
    }
    func sliderValueDidChange11(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 11)
    }
    func sliderValueDidChange12(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 12)
    }
    func sliderValueDidChange13(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 13)
    }
    func sliderValueDidChange14(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 14)
    }
    func sliderValueDidChange15(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 15)
    }
    func sliderValueDidChange16(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 16)
    }
    func sliderValueDidChange17(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 17)
    }
    func sliderValueDidChange18(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 18)
    }
    func sliderValueDidChange19(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 19)
    }
    func sliderValueDidChange20(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 20)
    }
    func sliderValueDidChange21(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 21)
    }
    func sliderValueDidChange22(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 22)
    }
    func sliderValueDidChange23(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 23)
    }
    func sliderValueDidChange24(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 24)
    }
    func sliderValueDidChange25(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 25)
    }
    func sliderValueDidChange26(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 26)
    }
    func sliderValueDidChange27(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 27)
    }
    func sliderValueDidChange28(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 28)
    }
    func sliderValueDidChange29(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 29)
    }
    func sliderValueDidChange30(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 30)
    }
    func sliderValueDidChange31(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 31)
    }
    func sliderValueDidChange32(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 32)
    }
    func sliderValueDidChange33(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 33)
    }
    func sliderValueDidChange34(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 34)
    }
    func sliderValueDidChange35(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 35)
    }
    func sliderValueDidChange36(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 36)
    }
    func sliderValueDidChange37(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 37)
    }
    func sliderValueDidChange38(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 38)
    }
    func sliderValueDidChange39(slider: UISlider) {
        amtTrackManager.setTrackVolume(slider.value, index: 39)
    }
    
    
}
