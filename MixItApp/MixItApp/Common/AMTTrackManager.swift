//
//  AMTTrackManager.h

import Foundation
import AVFoundation
import Photos
// Model for Track
class AMTTrack: NSObject {
    /**
     *  The track audio URL
     */
    var audioURL: NSURL?
    /**
     *  The track name
     */
    var trackName: String?
    /**
     *  The AVAssetTrack for track
     */
    var assetTrack: AVAssetTrack?
    /**
     *  The track volume
     */
    var trackVolume: CGFloat? 
    
    /**
     *  The track duration
     */
    var trackDuration: CMTime?
    /**
     *  The track ID
     */
    var trackID: CMPersistentTrackID?
    /**
     *  Initialize the track
     */
    
    func initAMTTrack() {
        
        self.audioURL = nil
        self.trackName = ""
        self.assetTrack = nil
        self.trackVolume = 0.0
        self.trackDuration = kCMTimeZero
        self.trackID = 0
    }
    
    override init() {
        super.init()
        self.initAMTTrack()
    }
}

// Track Manager
class AMTTrackManager: NSObject {
    /**
     *  The mutable composition for merge tracks
     */
    var amtMutableComposition: AVMutableComposition?
    /**
     *  The track audio URL
     */
    var arrTracks: [AnyObject]?
    /**
     *  The track audio URL
     */
    var player: AVPlayer?
    /**
     *  The track audio URL
     */
    var trackPlayer: AVAudioPlayer?
    /**
     *  The track audio URL
     */
    var currentProjectName = ""
    /**
     *  The track audio URL
     */
    var trackMerged = false
    /**
     *  The track audio URL
     */
    
    
    /**
     *  The track audio URL
     */
    
    func deleteTrack(index: Int) {
        let track: AMTTrack = self.arrTracks![index] as! AMTTrack
        arrTracks?.removeAtIndex(index)
        do {
            try NSFileManager.defaultManager().removeItemAtPath(track.audioURL!.path!)
        }
        catch {
            
        }
        
    }
    /**
     *  The track audio URL
     */
    
    func mergeTracks() {
        self.amtMutableComposition = nil
        self.amtMutableComposition = AVMutableComposition()
        for var i = 0; i < self.arrTracks!.count; i++ {
            let track: AMTTrack = self.arrTracks![i] as! AMTTrack
            let audioAsset: AVURLAsset = AVURLAsset(URL: track.audioURL!, options: nil)
            let audioTrack: AVMutableCompositionTrack = amtMutableComposition!.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
            do {
                try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: kCMTimeZero)
            }
            catch {
                
            }
            
            //        track.trackID = audioTrack.trackID;
            
        }
    }
    /**
     *  The track audio URL
     */
    
    func playComposition() {
        if self.trackMerged {
            player!.play()
            return
        }
        if trackPlayer != nil && trackPlayer!.playing {
            trackPlayer!.pause()
        }
        self.mergeTracks()
        self.trackMerged = true
        self.player = nil
        let playerItem: AVPlayerItem = AVPlayerItem(asset: amtMutableComposition!.copy() as! AVAsset)
        self.player = AVPlayer(playerItem: playerItem)
        self.applyAudioMix()
        player!.play()
    }
    /**
     *  The track audio URL
     */
    
    func pauseComposition() {
        
        if (player != nil) {
            player!.pause()
        }
    }
    /**
     *  The track audio URL
     */
    
    func playTrack(index: Int) {
        self.trackPlayer = nil
        let track: AMTTrack = self.arrTracks![index] as! AMTTrack
        do{
            self.trackPlayer = try AVAudioPlayer(contentsOfURL: track.audioURL!, fileTypeHint: nil)
            self.trackPlayer!.play()
        }catch {
            
        }
        
    }
    /**
     *  The track audio URL
     */
    
    func pauseTrack() {
        
        if (self.trackPlayer != nil) {
            self.trackPlayer!.pause()
        }
    }
    /**
     *  The track audio URL
     */
    
    func setTrackVolume(volume: Float, index: Int) {
        if self.trackPlayer?.playing == true {
            self.trackPlayer!.volume = volume
            return
        }
        ((arrTracks![index] as! AMTTrack)).trackVolume = CGFloat(volume)
        if self.player != nil && self.player!.rate != 0 && self.player!.error == nil {
            self.applyAudioMix()
        }
    }
    /**
     *  The track audio URL
     */
    
    func applyAudioMix() {
        let mix: AVMutableAudioMix = AVMutableAudioMix()
        var inputParameters = [AVAudioMixInputParameters]()
        for var i = 0; i < self.arrTracks!.count; i++ {
            let track: AMTTrack = self.arrTracks![i] as! AMTTrack
            let assetTrack: AVAssetTrack = amtMutableComposition!.tracks[i]
            let params = AVMutableAudioMixInputParameters(track: assetTrack)
            params.setVolume(Float(track.trackVolume!), atTime: kCMTimeZero)
            inputParameters.append(params)
        }
        mix.inputParameters = inputParameters
        self.player!.currentItem!.audioMix = mix
    }
    /**
     *  The track audio URL
     */
    
    func exportTracksToGallery(completionBlock: (outURL: NSURL) -> Void, failure failureBlock: (errorStr: String) -> Void) {
        let outputURL: NSURL = Common.getMultitrackAudioPath()
        if NSFileManager.defaultManager().fileExistsAtPath(outputURL.path!) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(outputURL.path!)
            }
            catch {
                
            }
            
        }
        self.exportTracks(outputURL, completionBlock: {(outURL: NSURL) -> Void in
            completionBlock(outURL: outURL)
            }, failure: {(errorStr: String) -> Void in
                failureBlock(errorStr: errorStr)
        })
    }
    convenience init(trackManager : Bool) {
        self.init()
        self.initTrackManager()
    }
    func initTrackManager(){
        self.amtMutableComposition = AVMutableComposition()
        self.arrTracks = [AnyObject]()
        self.currentProjectName = ""
        self.player = nil
        self.trackPlayer = nil
        self.trackMerged = false
    }
    func exportTracks(outputURL: NSURL, completionBlock: (outURL: NSURL) -> Void, failure failureBlock: (errorStr: String) -> Void) {
        self.mergeTracks()
        let exportSession: AVAssetExportSession = AVAssetExportSession(asset: amtMutableComposition!, presetName: AVAssetExportPresetAppleM4A)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileTypeAppleM4A
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronouslyWithCompletionHandler({() -> Void in
            var msgErr: String? = nil
            switch exportSession.status {
            case .Unknown, .Waiting, .Exporting, .Failed, .Cancelled:
                msgErr = exportSession.error!.localizedDescription
            default:
                NSLog("Merge Completed")
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionBlock(outURL: outputURL)
                })
            }
            
            if msgErr != nil {
                failureBlock(errorStr: msgErr!)
            }
        })
    }
}

