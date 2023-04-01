//
//  ViewController.swift
//  Pitch-Perfect-iOS13
//
//  Created by Omer Ifrah on 3/31/23.
//

import UIKit
import AVFoundation
class RecorderViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder! // delegate instance - think of it as an "intern".
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        requestRecordPermission()
    }


    @IBAction func recordButtonTapped(_ sender: UIButton) {
        
        //        audioRecorder.delegate = self // designates the delegate for AVAudio
        if permission{
            recordButton.isEnabled = false
            stopButton.isEnabled = true
            recordingStatusLabel.text = "Recording in progress..."
            print("recTapped")
        } else {
            requestRecordPermission()
        }
        
    }

    @IBAction func stopButtonTapped(_ sender: UIButton) {
        stopButton.isEnabled = false
        print("stopTapped")

    }
}

// assigns the AVAudioRecorderDelegate Protocol to the RecordViewController - this effectively designates the ViewController as the "boss" to the audioRecorder.
extension RecorderViewController: AVAudioRecorderDelegate{
    
    // defines the functions the delegate can perform. Think of it as the list of "tasks" the "boss" can ask the "intern" to perform.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("finishedRecording")
    }
}
