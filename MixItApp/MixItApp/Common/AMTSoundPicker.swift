//
//  AMTSoundPicker.h

//  Track Picker class for seleting invdividual tracks from gallery
import Foundation
import MediaPlayer


let utility = Common.utility()
let amtTrackManager = Common.amtTrackManager()

// The delegate protocol to control sound picker events(selected, cancelled)
protocol AMTSoundPickerDelegate {
    func addAudio(track: AMTTrack)
}

class AMTSoundPicker: NSObject, MPMediaPickerControllerDelegate {
    var parentVC: UIViewController?
    var delegate : AMTSoundPickerDelegate?
    /**
     * Get singletone instance of this class
     */
    private static let soundPicker = AMTSoundPicker()
    class func sharedInstance() -> AMTSoundPicker {
        return soundPicker
    }
    /**
     * Present audio picker to select tracks to be used in multitrack file generation.
     *
     * @param: delegate The delegate to control sound picker events(selected, cancelled)
     * imported file.
     */
    
    func presentAudioPicker(parentVC: UIViewController, delegate: AMTSoundPickerDelegate) {
        self.parentVC = parentVC
        self.delegate = delegate
        let soundPicker: MPMediaPickerController = MPMediaPickerController(mediaTypes: .AnyAudio)
        soundPicker.delegate = self
        soundPicker.allowsPickingMultipleItems = false
        parentVC.presentViewController(soundPicker, animated: true, completion: { _ in })
    }
    
    func addSong(strOutpath: AnyObject, trackName: String) -> Void {
        DSBezelActivityView.removeViewAnimated(true)
        let track: AMTTrack = AMTTrack()
        track.trackName = trackName
        track.audioURL = strOutpath as? NSURL
        track.trackVolume = 1.0
        amtTrackManager.arrTracks?.append(track)
        
        if self.delegate != nil {
            self.delegate?.addAudio(track)
        }
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        let item = mediaItemCollection.items[0]
        let assetURL = item.assetURL
        let assetTitle = item.title
        let assetArtist = item.artist
        let title: String = (assetTitle == nil) ? "Unknown Title" : assetTitle!.uppercaseString
        let artist: String = (assetArtist == nil) ? "Unknown Artist" : assetArtist!.uppercaseString
        let trackName: String = "\(title) by \(artist)"
        if assetURL != nil {
            DSBezelActivityView.newActivityViewForView(parentVC!.view!)
            if amtTrackManager.currentProjectName.characters.count == 0 {
                amtTrackManager.currentProjectName = ProjectManager.newProject().lastPathComponent
            }
            let outputURL: NSURL = Common.getClipAudioPath(assetURL, project: amtTrackManager.currentProjectName, trackName: trackName)!
            utility.exportAudioAtURL(assetURL!, outputURL: outputURL,
                completionBlock: {(strOutpath: AnyObject) -> Void in
                    self.addSong(strOutpath, trackName: trackName)
                    
                    ///
                    //
                    // create separate file for each channel and import them
                    //
                    
                    let ch = utility.splitFile(strOutpath.absoluteString)
                    
                    for i in 0...(ch-1) {
                        var channelFilePath =  strOutpath.absoluteString.stringByReplacingOccurrencesOfString(".m4a", withString: "_" + String(i) + ".m4a") // TODO: refactor to getChannelFileURL or sth like that
                        channelFilePath =  channelFilePath.stringByReplacingOccurrencesOfString("file://", withString:  "") // TODO: refactor to getChannelFileURL or sth like that

                        channelFilePath = channelFilePath.stringByRemovingPercentEncoding!
                        self.addSong(NSURL(fileURLWithPath:channelFilePath), trackName: "ch " + String(i) + ": " + trackName)
                        
                    }
                    
                },
                WithFailure: {(errorStr: String) -> Void in
                    DSBezelActivityView.removeViewAnimated(true)
            })
            parentVC!.dismissViewControllerAnimated(true, completion: { _ in })
        }
        else {
            parentVC!.dismissViewControllerAnimated(true, completion: { _ in })
            IVMAlertController.showNoAudioExistAlert(parentVC!)
        }
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        parentVC!.dismissViewControllerAnimated(true, completion: { _ in })
    }
}