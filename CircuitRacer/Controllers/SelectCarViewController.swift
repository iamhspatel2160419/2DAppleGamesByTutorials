//
//  SelectCarViewController.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import UIKit

// MARK: SelectCarViewController: UIViewController

class SelectCarViewController: UIViewController {

    // MARK: View Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SKTAudio.sharedInstance().playSoundEffect("circuitracer.mp3")
    }
    
    // MARK: IB Actions
    
    @IBAction func carButtonPressed(_ sender: UIButton) {
        if let levelVC = storyboard?.instantiateViewController(withIdentifier: "SelectLevelViewController") as? SelectLevelViewController {
            SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
            levelVC.carType = CarType(rawValue: sender.tag)!
            navigationController?.pushViewController(levelVC, animated: false)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
    }

}
