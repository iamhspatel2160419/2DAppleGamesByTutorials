//
//  Audio.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/26/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import AVFoundation

/**
 * Audio player that uses AVFoundation to play looping background music and
 * short sound effects. For when using SKActions just isn't good enough.
 */
class SKTAudio {
  var backgroundMusicPlayer: AVAudioPlayer?
  var soundEffectPlayer: AVAudioPlayer?

  class func sharedInstance() -> SKTAudio {
    return SKTAudioInstance
  }

  func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
    if (url == nil) {
      println("Could not find file: \(filename)")
      return
    }

    var error: NSError? = nil
    backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
    if let player = backgroundMusicPlayer {
      player.numberOfLoops = -1
      player.prepareToPlay()
      player.play()
    } else {
      println("Could not create audio player: \(error!)")
    }
  }

  func pauseBackgroundMusic() {
    if let player = backgroundMusicPlayer {
      if player.playing {
        player.pause()
      }
    }
  }

  func resumeBackgroundMusic() {
    if let player = backgroundMusicPlayer {
      if !player.playing {
        player.play()
      }
    }
  }

  func playSoundEffect(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
    if (url == nil) {
      println("Could not find file: \(filename)")
      return
    }

    var error: NSError? = nil
    soundEffectPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
    if let player = soundEffectPlayer {
      player.numberOfLoops = 0
      player.prepareToPlay()
      player.play()
    } else {
      println("Could not create audio player: \(error!)")
    }
  }
}

let SKTAudioInstance = SKTAudio()
