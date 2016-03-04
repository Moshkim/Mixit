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
    var baseTrack: String?
    
    init(name: String, numberOfTracks: Int, baseTrack: String?) {
        self.name = name
        self.numberOfTracks = numberOfTracks
        self.baseTrack = baseTrack
    }
}
