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
    
    var recorderBrain = RecorderBrain()
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayPreRecordingUI()
        recorderBrain.requestRecordPermission() //request poermission to access the mic
    }
    
    //MARK: - IBActions
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        // shortened if statement: UI functionality and feedback dependant on whether user granted permission.
        recorderBrain.isMicrophonePermissionGranted() ? displayWhileRecordingUI(): displayNoPermissionUI()
        
        recorderBrain.prepareForAudioRecording() // sets filepath+name and initiates audio session
        recorderBrain.audioRecorder.delegate = self //initializes viewcontroller as the delegate. the audioRecorder is the "intern" and it waits to be told what to do by the ViewController.
        recorderBrain.startRecording() //starts recording
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        displayPreRecordingUI()
        recorderBrain.stopRecoding()
        print("stop Tapped")
    }
    
    //MARK: - UI Update Functions
    func displayPreRecordingUI(){
        stopButton.isEnabled = false
        recordButton.isEnabled = true //change button status
        recordingStatusLabel.text = K.TextLabels.preRecordingStatus
    }
    
    func displayWhileRecordingUI(){
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        recordingStatusLabel.text = K.TextLabels.whileRecordingStatus //change label text
        print("rec Tapped") //debug statement
    }
    
    func displayNoPermissionUI(){
        self.recordingStatusLabel.text = K.TextLabels.noPermissionRecordingStatus
        self.recordButton.isEnabled = false

        //THIS ISN'T IDEAL FEEDBACK. SHOULD USE NOTIFICATIONS.
        // resetting UI after 1.0 seconds so that app could continuously give the user feedback
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.displayPreRecordingUI()

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
