//
//  recorderBrain.swift
//  Pitch-Perfect-iOS13
//
//  Created by Omer Ifrah on 3/31/23.
//

import Foundation
import AVFoundation

var recordingSession: AVAudioSession!
var permission = false

func requestRecordPermission() {
    recordingSession = AVAudioSession.sharedInstance()
    do {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("permission granted")
                permission = true
            } else {
                print("permission isn't granted")
                // Present message to user indicating that recording
                // can't be performed until they change their preference
                // under Settings -> Privacy -> Microphone
            }
        }
    }
}
