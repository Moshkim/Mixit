//
//  Common.h


import Foundation
import AVFoundation
class Common: NSObject {
    class func getClipAudioPath(assetURL : NSURL?, project projectName: String, trackName: String) -> NSURL? {
        var ext: String?
        if assetURL != nil {
            ext = TSLibraryImport.extensionForAssetURL(assetURL!)
        }
        else {
            return nil
        }
        if ext == nil {
            ext = ""
        }
        
        if ext == "mp3" {
            ext = "m4a"
        }
        
        let projectPath: String = Common.getProjectPath(projectName)
        let timeStamp: String = "\(NSDate().timeIntervalSince1970)"
        let audioDir: String = (projectPath as NSString).stringByAppendingPathComponent("amt_audio_\(timeStamp)")
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(audioDir, withIntermediateDirectories: false, attributes: nil)
        }
        catch{
            
        }
        
        let outURL: NSURL = NSURL.fileURLWithPath((audioDir as NSString).stringByAppendingPathComponent(trackName)).URLByAppendingPathExtension(ext!)
        return outURL
    }
    /**
     * Get multitrack audio path to store track merged aac file.
     */
    
    class func getMultitrackAudioPath() -> NSURL {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0]
        let audioFileOutput: NSURL = NSURL.fileURLWithPath((documentsDirectory as NSString).stringByAppendingPathComponent("multitrack.aac"))
        return audioFileOutput
    }
    /**
     * Get project path by project name
     * @param: projectName The project name
     */
    
    class func getProjectPath(projectName: String) -> String {
        let documentsDir: String = (Common.getProjectsDocumentPath() as NSString).stringByAppendingPathComponent(projectName)
        return documentsDir
    }
    /**
     * Get directory path of projects
     */
    
    class func getProjectsDocumentPath() -> String {
        var documentPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDir: String = (documentPaths[0] as NSString).stringByAppendingPathComponent("Projects")
        if !NSFileManager.defaultManager().fileExistsAtPath(documentsDir) {
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(documentsDir, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                
            }
            
        }
        return documentsDir
    }
    /**
     * Create new project directory
     */
    
    class func createNewProjectDocumentPath() -> NSString {
        let timeStamp: String = "\(NSDate().timeIntervalSince1970)"
        let documentsDir: String = Common.getProjectPath("project-\(timeStamp)")
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(documentsDir, withIntermediateDirectories: false, attributes: nil)
        }
        catch{
            
        }
        
        return documentsDir
    }
    /**
     * Get singletone instance of Utility class
     */
    private static let amtutility = Utility()
    class func utility() -> Utility {
        return amtutility
    }
    /**
     * Get singletone instance of AMTTrackManager class
     */
    private static var trackManger : AMTTrackManager?
    class func amtTrackManager() -> AMTTrackManager {
        if trackManger == nil {
            trackManger = AMTTrackManager(trackManager: true)
        }
        return trackManger!
    }
}