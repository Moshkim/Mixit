//
//  SettingsList.swift
//  MixItApp
//
//  Created by Michael Li on 3/3/16.
//  Copyright © 2016 MixMusicProduction. All rights reserved.
//

import Foundation
import UIKit

struct SettingsList {
    var name: String
    var setting: String?
    
    init(name: String, setting: String?) {
        self.name = name
        self.setting = setting
    }
}

let settings = [
    SettingsList(name: "About", setting: nil),
    SettingsList(name: "Another setting", setting: nil)
]