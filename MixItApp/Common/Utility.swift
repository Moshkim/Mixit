//
//  Utility.swift


import Foundation

class Utility: NSObject {
    
    @IBOutlet weak var spliter:FileSpliter!;

    func splitFile(url: String!) -> Int {
        
        let s = FileSpliter(URL: url)
        return Int(s.splitFile());
        
    }
    
    func exportAudioAtURL(assetURL: NSURL, outputURL outURL: NSURL, completionBlock: (strExportedURL: AnyObject) -> Void, WithFailure failure: (errorStr: String) -> Void) {
        if NSFileManager.defaultManager().fileExistsAtPath(outURL.path!) {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(outURL)
            }
            catch {
                NSLog("removeItemAtURL failed %s", outURL);
            }
            
        }
        let imp = TSLibraryImport()
        imp.importAsset(assetURL, toURL: outURL) { (imp) -> Void in
            if imp.status != .Completed {
                NSLog("Not Completed : - %@", imp.error.localizedDescription)
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionBlock(strExportedURL: outURL)
                    NSLog("Completed")
                })
            }
        }
    }
}