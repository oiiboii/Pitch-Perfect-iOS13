//
//  ViewController.swift
//  Pitch-Perfect-iOS13
//
//  Created by Omer Ifrah on 3/31/23.
//

import UIKit
import AVFoundation

//MARK: - RecorderViewController
class RecorderViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder! //delegate instance - think of it as an "intern".
    var permission: Bool = false
    var recordingSession: AVAudioSession!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingStatusLabel.text = K.preRecordingStatus
        stopButton.isEnabled = false //stop button is disabled on launch
        requestRecordPermission() //request poermission to access the mic
    }
    
    //MARK: - IBActions
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        // shortened if statement: if permission to access mic was granted - startRecording.
        permission ? startRecording(): askUserToChangePermission()
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self // designates the delegate for AVAudio
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        stopButton.isEnabled = false
        recordButton.isEnabled = true //change button status
        recordingStatusLabel.text = K.preRecordingStatus
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        print("stop Tapped")
    }
    
    //MARK: - UI Update Functions
    
    func startRecording(){
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        recordingStatusLabel.text = K.whileRecordingStatus //change label text
        print("rec Tapped") //debug statement
    }
    
    func askUserToChangePermission(){
        self.recordingStatusLabel.text = K.noPermissionRecordingStatus
        self.recordButton.isEnabled = false

        //THIS ISN'T IDEAL FEEDBACK. SHOULD USE NOTIFICATIONS.
        // resetting UI after 1.0 seconds so that app could continuously give the user feedback
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.recordButton.isEnabled = true
            self.recordingStatusLabel.text = K.preRecordingStatus
        }
    }
}

//MARK: - Delegate Extension
// assigns the AVAudioRecorderDelegate Protocol to the RecordViewController - this effectively designates the ViewController as the "boss" to the audioRecorder.
extension RecorderViewController: AVAudioRecorderDelegate{
    
    // defines the functions the delegate can perform. Think of it as the list of "tasks" the "boss" can ask the "intern" to perform.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            print("finishedRecording") //debug
            performSegue(withIdentifier: K.modulatorVC, sender: audioRecorder.url)
        } else {
            print("Something went wrong...")
        }
    }
    
    func requestRecordPermission() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                    print("permission granted")
                    self.permission = true
                } else {
                    print("permission isn't granted")
                    // Present message to user indicating that recording
                    // can't be performed until they change their preference
                    // under Settings -> Privacy -> Microphone
                }
            }
        }
    }
}

