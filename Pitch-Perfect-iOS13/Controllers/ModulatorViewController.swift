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
    var recordedAudioURL: URL!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
