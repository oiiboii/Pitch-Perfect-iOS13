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
    
    //MARK: - Variables
    var audioRecorder: AVAudioRecorder! //delegate instance - think of it as an "intern".
    var recordingSession: AVAudioSession!
    
    //MARK: - Private methods
    private func getFilePath(for fileName: String) -> URL{
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        return audioFilename
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //MARK: - Mutating methods
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
    
    mutating func prepareForAudioRecording(){
        let filePath = getFilePath(for: K.Files.recordingFileName)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
    }
    
    //MARK: - Public methods
    // returns a true if the user granted mic access and false if the user denied it.
    func isMicrophonePermissionGranted() -> Bool {
        return AVAudioSession.sharedInstance().recordPermission == .granted
    }
    
    func startRecording(){
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    func stopRecoding(){
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}
