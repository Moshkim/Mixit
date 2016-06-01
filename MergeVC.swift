//
//  MergeVC.swift
//  MixItApp
//
//  Created by Andrew Kaufman on 5/31/16.
//  Copyright © 2016 MixItApp. All rights reserved.
//

import Foundation

class MergeVC : UIViewController {
    
    static let sharedInstance = MergeVC()
    @IBOutlet weak var textField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }

}