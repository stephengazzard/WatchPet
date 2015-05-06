//
//  FirstViewController.swift
//  WatchPet
//
//  Created by Stephen Gazzard on 2015-05-05.
//  Copyright (c) 2015 Broken Kings. All rights reserved.
//

import UIKit

let WPPetHungerKey = "PetHunger"

class FirstViewController: UIViewController {

    var pet : WPPet = WPPet()
    var timer : NSTimer? = nil;

    @IBOutlet weak var hungerWidthConstraint : NSLayoutConstraint?
    @IBOutlet weak var hungerBackground : UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pet.hunger = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey(WPPetHungerKey))

        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "increaseHunger", userInfo: nil, repeats: true)
        updateHungerBar()
    }

    func increaseHunger() {
        if (pet.hunger >= 1.0) { return; }

        pet.hunger += 0.01
        NSUserDefaults.standardUserDefaults().setFloat(Float(pet.hunger), forKey: WPPetHungerKey)
        showAlertIfPetHungry()
        updateHungerBar()
    }

    func updateHungerBar() {
        if let hungerWidthConstraint = hungerWidthConstraint, let hungerBackground = hungerBackground {
            hungerWidthConstraint.constant = -CGRectGetWidth(hungerBackground.frame) * (1 - pet.hunger)
        }
    }

    func showAlertIfPetHungry() {
        if (pet.hunger >= 1.0) {
            pet.hunger = 1.0
            let alert = UIAlertController(title: "Your pet is hungry!", message: nil, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    @IBAction func feedPet() {
        pet.hunger = max(0, pet.hunger - 0.25)
        updateHungerBar()
    }

    @IBAction func debugStarvePet() {
        pet.hunger = min(1, pet.hunger + 0.25)
        updateHungerBar()
        showAlertIfPetHungry()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

