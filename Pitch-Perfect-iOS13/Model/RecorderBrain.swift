//
//  RecorderBrain.swift
//  Pitch-Perfect-iOS13
//
//  Created by Omer Ifrah on 4/6/23.
//

import Foundation
import AVFoundation


//the recorder brain struct provides the functionality of the recorder view controller that isn't related to the UI
struct RecorderBrain{
    
    var audioRecorder: AVAudioRecorder! //delegate instance - think of it as an "intern".
    var recordingSession: AVAudioSession!
    
    mutating func requestRecordPermission() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                    print("permission granted")
                } else {
                    print("permission isn't granted")
                    // Present message to user indicating that recording
                    // can't be performed until they change their preference
                    // under Settings -> Privacy -> Microphone
                }
            }
        }
    }
    
    // returns a true if the user granted mic access and false if the user denied it.
    func isMicrophonePermissionGranted() -> Bool {
        return AVAudioSession.sharedInstance().recordPermission == .granted
    }
}
