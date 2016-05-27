//
//  ProjectManager.h
//  Aacmultitrack
//
//  Created by LMAN on 1/31/16.
//  Copyright © 2016 idragon. All rights reserved.
//
//  Project manager class for multitrack audio file.
//

#import <Foundation/Foundation.h>

@interface ProjectManager : NSObject

+ (NSString*)newProject;
+ (NSMutableArray*)openProject:(NSString*)projectName;
+ (void)deleteProject:(NSString*)projectName;
+ (NSMutableArray*)getProjectList;

@end
