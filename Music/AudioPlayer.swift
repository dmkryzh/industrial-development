//
//  AudioPlayer.swift
//  Navigation
//
//  Created by Dmitrii KRY on 26.04.2021.
//

import Foundation
import UIKit
import AVFoundation

class AudioPlayer {
    
    let songsList: Array<String> = ["Master", "Queen", "Electric", "Alpha", "Guano"]
    
    let youTubeList: [String] = ["https://www.youtube.com/watch?v=dQw4w9WgXcQ", "https://www.youtube.com/watch?v=HCfPhZQz2CE", "https://www.youtube.com/watch?v=L1Snj1Pt-Hs"]
    
    var currentSongIndex = 0
    
    var audioPlayer: AVAudioPlayer!
    
    func prepareAudioPlayer() {
        let url = Bundle.main.url(forResource: songsList[currentSongIndex], withExtension: "mp3")!
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer.prepareToPlay()
    }
    
    func playButtonAction() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
        else {
            audioPlayer.play()
        }
    }
    
    func stopButtonAction() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
    
    func pauseButtonAction() {
        audioPlayer.pause()
    }
    
    func backButtonAction() -> String {
        if currentSongIndex == 0 {
            currentSongIndex = songsList.count - 1
        } else {
            currentSongIndex -= 1
        }
        let url = Bundle.main.url(forResource: songsList[currentSongIndex], withExtension: "mp3")!
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        return songsList[currentSongIndex]
    }
    
    func forwardButtonAction() -> String  {
        if currentSongIndex == songsList.count - 1 {
            currentSongIndex = 0
        } else {
            currentSongIndex += 1 % songsList.count
        }
        let url = Bundle.main.url(forResource: songsList[currentSongIndex], withExtension: "mp3")!
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        return songsList[currentSongIndex]
    }
}

