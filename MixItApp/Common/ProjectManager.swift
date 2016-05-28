//
//  ProjectManager.h

//  Project manager class for multitrack audio file.
//
import Foundation
class ProjectManager: NSObject {
    class func newProject() -> NSString {
        let newProjectPath = Common.createNewProjectDocumentPath()
        return newProjectPath
    }
    
    class func openProject(projectName: String) -> [AnyObject] {
        let projectPath: String = Common.getProjectPath(projectName)
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        var trackArray: [AnyObject] = [AnyObject]()
        do {
            let fileList = try fileManager.contentsOfDirectoryAtPath(projectPath)
            
            for fileName: String in fileList {
                let audioDirectoryPath: String = (projectPath as NSString).stringByAppendingPathComponent(fileName)
                let isFileExist: Bool = fileManager.fileExistsAtPath(audioDirectoryPath)
                if isFileExist {
                    let track = AMTTrack()
                    do {
                        let trackFileList = try fileManager.contentsOfDirectoryAtPath(audioDirectoryPath)
                        if trackFileList.count > 0 {
                            let trackFileName: String = trackFileList[0]
                            track.trackName = trackFileName
                            track.audioURL = NSURL.fileURLWithPath((audioDirectoryPath as NSString).stringByAppendingPathComponent(trackFileName))
                            track.trackVolume = 1.0
                            trackArray.append(track)
                        }
                    }
                    catch{
                        
                    }
                    
                }
            }
        }
        catch{
            
        }
        
        return trackArray
    }
    
    class func deleteProject(projectName: String) {
        let projectPath: String = Common.getProjectPath(projectName)
        do {
            try NSFileManager.defaultManager().removeItemAtPath(projectPath)
        }
        catch{
            
        }
        
    }
    
    class func getProjectList() -> [AnyObject] {
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        do {
            let fileList = try fileManager.contentsOfDirectoryAtPath(Common.getProjectsDocumentPath())
            var projectArray: [AnyObject] = [AnyObject]()
            for fileName: String in fileList {
                let projectDirPath: String = (Common.getProjectsDocumentPath() as NSString).stringByAppendingPathComponent(fileName)
                let isFileExist: Bool = fileManager.fileExistsAtPath(projectDirPath)
                if isFileExist {
                    projectArray.append(fileName)
                }
            }
            return projectArray
        }
        catch{
            return []
        }
        
    }
}