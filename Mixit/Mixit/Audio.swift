//
//  Audio.swift
//  Mixit
//
//  Created by KWANIL KIM on 1/30/16.
//  Copyright © 2016 MixMusicProduction. All rights reserved.
//

import Foundation
import AVFoundation

//class GameSounds {
//    
//    static let filenameForIntroSong = "intro.mid"
//    static let filenameForMouseDown = "sword1.wav"
//    static let fileNameForRightMouseDown = "sword3.wav"
//    static let filenameForHover = "tick.wav"
//    
//    static var audioPlayer = AVAudioPlayer()
//    static var midiPlayer = AVMIDIPlayer()
//    
//    static func playIntroSong() {
//        GameSounds.playMidiFile(at: tryGettingPath(to: "load", within: "music"))
//    }
//    
//    static func playGameSong() {
//        GameSounds.playMidiFile(at: tryGettingPath(to: "game1", within: "music"))
//    }
//    
//    static func playMouseDownSound() {
//        GameSounds.playWavFile(at: tryGettingPath(to: "place", within: "misc"))
//    }
//    
//    static func playHoverSound() {
//        GameSounds.playWavFile(at: tryGettingPath(to: "tick", within: "misc"))
//    }
//    
//    static func playGoldMineSound() {
//        GameSounds.playWavFile(at: tryGettingPath(to: "gold-mine-selected", within: "buildings"))
//    }
//    
//    static func playPeasantSelect() {
//        let peasantSounds = DataManager.instance.gameSounds["peasant"]!
//        let randomNum = arc4random_uniform(UInt32(4)) + 1
//        let name = "peasant-selected\(randomNum)"
//        GameSounds.playWavFile(at: peasantSounds[name]!)
//    }
//    
//    static func playPeasantAcknowledge() {
//        let peasantSounds = DataManager.instance.gameSounds["peasant"]!
//        let randomNum = arc4random_uniform(UInt32(4)) + 1
//        let name = "peasant-acknowledge\(randomNum)"
//        GameSounds.playWavFile(at: peasantSounds[name]!)
//    }
//    
//    static func playWavFile(at url: NSURL) {
//        do {
//            self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
//            self.audioPlayer.play()
//        } catch {
//            print("Couldn't load wav named \(url)")
//        }
//    }
//    
//    static func playMidiFile(at url: NSURL) {
//        do {
//            self.midiPlayer = try AVMIDIPlayer(contentsOfURL: url, soundBankURL: nil)
//            self.midiPlayer.play(nil)
//        } catch {
//            print("Couldn't load midi named \(url)")
//        }
//    }
//    
//    static func tryGettingPath(to soundName: String, within soundDict: String) -> NSURL {
//        guard let soundDictionary = DataManager.instance.gameSounds[soundDict] else {
//            print("Could not find dictionary named \(soundDict)")
//            return NSURL(string: soundName)!
//        }
//        
//        guard let sound = soundDictionary[soundName] else {
//            print("Could not find sound named \(soundName)")
//            return NSURL(string: soundName)!
//        }
//        
//        return sound
//    }
//}