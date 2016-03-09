//
//  ProjectList.swift
//  MixItApp
//
//  Created by Michael Li on 3/3/16.
//  Copyright © 2016 MixMusicProduction. All rights reserved.
//

import Foundation
import UIKit

struct ProjectList {
    var name: String
    var numberOfTracks: Int
    var trackDuration: NSTimeInterval  // in seconds
    var baseTrack: String?
    
    init(name: String, numberOfTracks: Int, trackDuration: NSTimeInterval, baseTrack: String?) {
        self.name = name
        self.numberOfTracks = numberOfTracks
        self.trackDuration = trackDuration
        self.baseTrack = baseTrack
    }
}
