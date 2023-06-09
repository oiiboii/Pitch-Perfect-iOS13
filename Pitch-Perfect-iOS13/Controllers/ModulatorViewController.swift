//
//  ModulatorViewController.swift
//  Pitch-Perfect-iOS13
//
//  Created by Omer Ifrah on 3/31/23.
//


import UIKit
import AVFAudio

class ModulatorViewController: UIViewController {
    
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var recordedAudioURL: URL!
    
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    //stops audio if user goes back to the recorder screen before the audio finished playing
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAudio()
    }
    
    //MARK: - IBActions
    @IBAction func playSoundButtonPressed(_ sender: UIButton){
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }

        configureUI(.playing)
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        stopAudio()
    }
}
    
    //MARK: - UI Functions
    extension ModulatorViewController: AVAudioPlayerDelegate {
        
        // MARK: Alerts
  
        // MARK: PlayingState (raw values correspond to sender tags)
        
        enum PlayingState { case playing, notPlaying }
        
        // MARK: Audio Functions
        
        func setupAudio() {
            // initialize (recording) audio file
            do {
                audioFile = try AVAudioFile(forReading: recordedAudioURL as URL)
            } catch {
                showAlert(K.Alerts.AudioFileError, message: String(describing: error))
            }
        }
        
        func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
            
            // initialize audio engine components
            audioEngine = AVAudioEngine()
            
            // node for playing audio
            audioPlayerNode = AVAudioPlayerNode()
            audioEngine.attach(audioPlayerNode)
            
            // node for adjusting rate/pitch
            let changeRatePitchNode = AVAudioUnitTimePitch()
            if let pitch = pitch {
                changeRatePitchNode.pitch = pitch
            }
            if let rate = rate {
                changeRatePitchNode.rate = rate
            }
            audioEngine.attach(changeRatePitchNode)
            
            // node for echo
            let echoNode = AVAudioUnitDistortion()
            echoNode.loadFactoryPreset(.multiEcho1)
            audioEngine.attach(echoNode)
            
            // node for reverb
            let reverbNode = AVAudioUnitReverb()
            reverbNode.loadFactoryPreset(.cathedral)
            reverbNode.wetDryMix = 50
            audioEngine.attach(reverbNode)
            
            // connect nodes
            if echo == true && reverb == true {
                connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioEngine.outputNode)
            } else if echo == true {
                connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, audioEngine.outputNode)
            } else if reverb == true {
                connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
            } else {
                connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
            }
            
            // schedule to play and start the engine!
            audioPlayerNode.stop()
            audioPlayerNode.scheduleFile(audioFile, at: nil) {
                
                var delayInSeconds: Double = 0
                
                if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                    
                    if let rate = rate {
                        delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                    } else {
                        delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                    }
                }
                
                // schedule a stop timer for when audio finishes playing
                self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(ModulatorViewController.stopAudio), userInfo: nil, repeats: false)
                RunLoop.main.add(self.stopTimer!, forMode: RunLoop.Mode.default)
            }
            
            do {
                try audioEngine.start()
            } catch {
                showAlert(K.Alerts.AudioEngineError, message: String(describing: error))
                return
            }
            
            // play the recording!
            audioPlayerNode.play()
        }
        
        @objc func stopAudio() {
            
            if let audioPlayerNode = audioPlayerNode {
                audioPlayerNode.stop()
            }
            
            if let stopTimer = stopTimer {
                stopTimer.invalidate()
            }
            
            configureUI(.notPlaying)
                            
            if let audioEngine = audioEngine {
                audioEngine.stop()
                audioEngine.reset()
            }
        }
        
        // MARK: Connect List of Audio Nodes
        
        func connectAudioNodes(_ nodes: AVAudioNode...) {
            for x in 0..<nodes.count-1 {
                audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
            }
        }
        
        // MARK: UI Functions

        func configureUI(_ playState: PlayingState) {
            switch(playState) {
            case .playing:
                setPlayButtonsEnabled(false)
                stopButton.isEnabled = true
            case .notPlaying:
                setPlayButtonsEnabled(true)
                stopButton.isEnabled = false
            }
        }
        
        func setPlayButtonsEnabled(_ enabled: Bool) {
            highPitchButton.isEnabled = enabled
            lowPitchButton.isEnabled = enabled
            fastButton.isEnabled = enabled
            slowButton.isEnabled = enabled
            echoButton.isEnabled = enabled
            reverbButton.isEnabled = enabled
        }

        func showAlert(_ title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: K.Alerts.DismissAlert, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

