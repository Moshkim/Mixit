//
//  IVMAlertController.h
//  instavideomerge

import Foundation
import UIKit
class IVMAlertController: NSObject {
    
    class func initWithTitle(title: String, Message message: String, LeftButton leftButton: String?, RightButton rightButton: String?, leftBlock actionLeft: ((action: UIAlertAction) -> Void)?, RightBlock actionRight: ((action: UIAlertAction) -> Void)?) -> UIAlertController {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        if leftButton != nil {
            let cancelAction: UIAlertAction = UIAlertAction(title:leftButton, style: .Default, handler: {(action: UIAlertAction) -> Void in
                    if actionLeft != nil {
                        actionLeft!(action: action)
                    }
                })
            alertController.addAction(cancelAction)
        }
        if rightButton != nil {
            let okAction: UIAlertAction = UIAlertAction(title:rightButton, style: .Default, handler: {(action: UIAlertAction) -> Void in
                    if actionRight != nil {
                        actionRight!(action: action)
                    }
                })
            alertController.addAction(okAction)
        }
        return alertController
    }
    class func initWithTitle(title: String, message: String, cancelButtonTitle cancel: String, action actionBlock: (action: UIAlertAction) -> Void, button fromView: UIView, otherButtonTitles: [String]) -> UIAlertController {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        for (_,arg) in otherButtonTitles.enumerate() {
            let action: UIAlertAction = UIAlertAction(title: arg, style: .Default, handler: {(action: UIAlertAction) -> Void in
                    actionBlock(action: action)
                })
            alertController.addAction(action)
        }
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            alertController.popoverPresentationController!.sourceView = fromView
        }
        return alertController
    }
    /**
     * Show message that audio dose not exsit.
     * @param: parentVC The parent view controller of alertview
     */

    class func showNoAudioExistAlert(parentVC: UIViewController) {
        let alertController: UIAlertController = IVMAlertController.initWithTitle(kAppName, Message: "This song is only on your iCloud and needs to be downloaded to device to be added. Use the iTunes Music app to download your purchased music.", LeftButton: "OK", RightButton: "Cancel", leftBlock: nil, RightBlock: nil)
        parentVC.presentViewController(alertController, animated: true, completion: { _ in })
    }
}