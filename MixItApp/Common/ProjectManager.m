//
//  ProjectManager.m
//  Aacmultitrack
//
//  Created by LMAN on 1/31/16.
//  Copyright © 2016 idragon. All rights reserved.
//

#import "ProjectManager.h"
#import "Common.h"
#import "AMTTrackManager.h"

@implementation ProjectManager

+ (NSString*)newProject {
    
    NSString * newProjectPath = [Common createNewProjectDocumentPath];
    return newProjectPath;
}

+ (NSMutableArray*)getProjectList {
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * fileList = [fileManager contentsOfDirectoryAtPath:[Common getProjectsDocumentPath] error:nil];

    NSMutableArray * projectArray = [[NSMutableArray alloc] init];
    for (NSString * fileName in fileList) {
        
        BOOL isDirectory;
        NSString * projectDirPath = [[Common getProjectsDocumentPath] stringByAppendingPathComponent:fileName];
        BOOL isFileExist = [fileManager fileExistsAtPath:projectDirPath isDirectory:&isDirectory];
        
        if (isDirectory && isFileExist) {
            [projectArray addObject:fileName];
        }
    }
    
    return projectArray;
}

+ (NSMutableArray*)openProject:(NSString*)projectName {
    
    NSString * projectPath = [Common getProjectPath:projectName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * fileList = [fileManager contentsOfDirectoryAtPath:projectPath error:nil];
    
    NSMutableArray * trackArray = [[NSMutableArray alloc] init];
    for (NSString * fileName in fileList) {
        
        BOOL isDirectory;
        NSString * audioDirectoryPath = [projectPath stringByAppendingPathComponent:fileName];
        BOOL isFileExist = [fileManager fileExistsAtPath:audioDirectoryPath isDirectory:&isDirectory];
        
        if (isDirectory && isFileExist) {
            
            AMTTrack * track = [[AMTTrack alloc] init];
            NSArray * trackFileList = [fileManager contentsOfDirectoryAtPath:audioDirectoryPath error:nil];
            if (trackFileList.count > 0) {
                
                NSString * trackFileName = trackFileList[0];
                track.trackName = trackFileName;
                track.audioURL = [NSURL fileURLWithPath:[audioDirectoryPath stringByAppendingPathComponent:trackFileName]];
                track.trackVolume = 1.0f;
                [trackArray addObject:track];
            }
        }
    }
    
    return trackArray;
}

+ (void)deleteProject:(NSString*)projectName {
    
    NSString * projectPath = [Common getProjectPath:projectName];
    [[NSFileManager defaultManager] removeItemAtPath:projectPath error:nil];
}

@end
