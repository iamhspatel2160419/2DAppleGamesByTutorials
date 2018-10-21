//
//  SelectLevelViewController.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import UIKit

// MARK: SelectLevelViewController: UIViewController

class SelectLevelViewController: UIViewController {
    
    // MARK: Properties
    
    var carType: CarType!
    
    // MARK: IB Actions
    
    @IBAction func difficultyButtonPressed(_ sender: UIButton) {
        if let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            
            SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
            
            let levelType = LevelType(rawValue: sender.tag)!
            
            gameVC.carType = carType
            gameVC.levelType = levelType
            
            navigationController?.pushViewController(gameVC, animated: false)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
    }
    
}
