//
//  ViewController.swift
//  Pitch-Perfect-iOS13
//
//  Created by Omer Ifrah on 3/31/23.
//

/* Outlets
 Variables/Constants
 Lifecycle methods
 Private methods
 Delegate methods
 Extensions
 */

import UIKit
import AVFoundation

class RecorderViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    //MARK: - Variables
    var recorderBrain = RecorderBrain()
    
    //MARK: - lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI(isRecording: false)
        recorderBrain.requestRecordPermission() //request poermission to access the mic
    }
    
    //MARK: - IBAction functions
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        // shortened if statement: UI functionality and feedback dependant on whether user granted permission.
        recorderBrain.isMicrophonePermissionGranted() ? configureUI(isRecording: true) : requestMicrophoneAccess()
        recorderBrain.prepareForAudioRecording() // sets filepath+name and initiates audio session
        recorderBrain.audioRecorder.delegate = self //initializes viewcontroller as the delegate. the audioRecorder is the "intern" and it waits to be told what to do by the ViewController.
        recorderBrain.startRecording() //starts recording
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        configureUI(isRecording: false)
        recorderBrain.stopRecoding()
        print("stop Tapped")
    }
    
    //MARK: - UI Update Functions
    func configureUI(isRecording: Bool) {
        stopButton.isEnabled = isRecording // to disable the button
        recordButton.isEnabled = !isRecording // to enable the button
        recordingStatusLabel.text = isRecording ? K.TextLabels.whileRecordingStatus : K.TextLabels.preRecordingStatus
    }
    
    func requestMicrophoneAccess() {
        let alert = UIAlertController(
            title: "Microphone Access Required",
            message: "Please grant microphone access to use this app.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Delegate Extension
// assigns the AVAudioRecorderDelegate Protocol to the RecordViewController - this effectively designates the ViewController as the "boss" to the audioRecorder.
extension RecorderViewController: AVAudioRecorderDelegate{
    
    // defines the functions the delegate can perform. Think of it as the list of "tasks" the "boss" can ask the "intern" to perform.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            print("finishedRecording") //debug
            performSegue(withIdentifier: K.Views.modulatorVC, sender: recorderBrain.audioRecorder.url)
        } else {
            print("Something went wrong...")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Views.modulatorVC{
            let modulatorVC = segue.destination as! ModulatorViewController
            let recordedAudioURL = sender as! URL
            modulatorVC.recordedAudioURL = recordedAudioURL
        }
    }
}
