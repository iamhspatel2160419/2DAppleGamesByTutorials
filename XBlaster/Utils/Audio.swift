//
//  Audio.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/28/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import AVFoundation

/**
 * Audio player that uses AVFoundation to play looping background music and
 * short sound effects. For when using SKActions just isn't good enough.
 */
class GameAudioPlayer {
    var backgroundMusicPlayer: AVAudioPlayer?
    var soundEffectPlayer: AVAudioPlayer?
    
    class func sharedInstance() -> GameAudioPlayer {
        return GameAudioPlayerInstance
    }
    
    func playBackgroundMusic(filename: String) {
        if let path = Bundle.main.path(forResource: filename, ofType:nil) {
            let url = URL(fileURLWithPath: path)
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                let player = backgroundMusicPlayer
                player?.numberOfLoops = -1
                player?.prepareToPlay()
                player?.play()
            } catch {
                print("Could not create audio player.")
            }
        }  
    }
    
    func pauseBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if player.isPlaying {
                player.pause()
            }
        }
    }
    
    func resumeBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if !player.isPlaying {
                player.play()
            }
        }
    }
    
    func playSoundEffect(filename: String) {
        if let path = Bundle.main.path(forResource: filename, ofType:nil) {
            let url = URL(fileURLWithPath: path)
            do {
                soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
                let player = soundEffectPlayer
                player?.numberOfLoops = 0
                player?.prepareToPlay()
                player?.play()
            } catch {
                print("Could not create audio player.")
            }
        }
    }
}

let GameAudioPlayerInstance = GameAudioPlayer()
