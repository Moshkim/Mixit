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
var sliderCount = 40    // number of sliders created

class VolumeSliders: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let scrollViewWidth = self.scrollView.frame.width
        let scrollViewHeight = self.scrollView.frame.height
        

        //scrollView = UIScrollView(frame: view.bounds)
        //scrollView.contentSize = CGSize(width: 9999,height: 9999)
        //view.addSubview(scrollView)
        // Code to add sliders for adjusting volume
        var slider = [UISlider!](count: maxSliders, repeatedValue: nil)
        
        if sliderCount > 40 {
            sliderCount = 40
        }
        
        for i in 0...sliderCount-1 {
            print("Creating slider \(i)")
            if i % 2 == 0 {
                //func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect
                slider[i] = UISlider(frame:CGRectMake(CGFloat(i)*50.0, 0, 167, 190))
                slider[i].maximumValueImage = UIImage(named: "settings-32")
            } else {
                slider[i] = UISlider(frame:CGRectMake(CGFloat(i-1)*50.0, 225, 167, 190))
                slider[i].maximumValueImage = UIImage(named: "settings-32")
            }
            slider[i].minimumValue = 0
            slider[i].maximumValue = 100
            slider[i].continuous = true
            slider[i].value = 50
            slider[i].addTarget(self, action: #selector(VolumeSliders.sliderValueDidChange(_:)), forControlEvents: .ValueChanged)
            slider[i].transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
            
            self.scrollView.addSubview(slider[i])
            
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width*5, self.scrollView.frame.height)
        
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
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func sliderValueDidChange(slider: UISlider) {
        sliderlabel.text = String(slider.value)
        print(sliderlabel.text)
    }

}
