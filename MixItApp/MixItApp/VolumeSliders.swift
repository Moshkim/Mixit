//
//  VolumeSliders.swift
//  MixItApp
//
//  Created by Michael Li on 3/31/16.
//  Copyright © 2016 MixMusicProduction. All rights reserved.
//

import UIKit

class VolumeSliders: UIViewController {

    @IBOutlet weak var slider1: UISlider!{
        didSet{
            slider1.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        }
    }
    @IBOutlet weak var slider2: UISlider!{
        didSet{
            slider2.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        }
    }
    @IBOutlet weak var slider3: UISlider!{
        didSet{
            slider3.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        }
    }
    @IBOutlet weak var slider4: UISlider!{
        didSet{
            slider4.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        }
    }
    @IBOutlet weak var slider5: UISlider!{
        didSet{
            slider5.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        }
    }
    @IBOutlet weak var slider6: UISlider!{
        didSet{
            slider6.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        }
    }
    @IBOutlet weak var slider7: UISlider!{
        didSet{
            slider7.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        }
    }
    @IBOutlet weak var slider8: UISlider!{
        didSet{
            slider8.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
