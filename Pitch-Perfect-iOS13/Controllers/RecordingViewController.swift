//
//  ViewController.swift
//  Pitch-Perfect-iOS13
//
//  Created by Omer Ifrah on 3/31/23.
//

import UIKit

class RecordingViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
    }


    @IBAction func recordButtonTapped(_ sender: UIButton) {
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        recordingStatusLabel.text = "Recording in progress..."
        print("recTapped")
        
    }

    @IBAction func stopButtonTapped(_ sender: UIButton) {
        stopButton.isEnabled = false
        print("stopTapped")

    }
}

