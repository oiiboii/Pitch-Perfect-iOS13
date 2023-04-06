//
//  ModulatorViewController.swift
//  Pitch-Perfect-iOS13
//
//  Created by Omer Ifrah on 3/31/23.
//

import UIKit

class ModulatorViewController: UIViewController {
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var ecoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var recordedAudioURL: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonSize()

        highPitchButton.contentMode = .center
        highPitchButton.imageView?.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
    }
    
    // looping through each button to set it's size and alignment so the images won't stretch
    func setButtonSize(){
        let buttons = [highPitchButton, lowPitchButton, ecoButton, reverbButton, fastButton, slowButton, stopButton]
        
        for button in buttons{
            if let button{
                button.contentMode = .center
                button.imageView?.contentMode = .scaleAspectFit
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
