//
//  ViewController.swift
//  CocoapodsTest
//

import UIKit
import Paystack

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Paystack.setDefaultPublishableKey("test")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

