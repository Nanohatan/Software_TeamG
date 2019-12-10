//
//  ViewController.swift
//  LoginDemo
//
//  Created by 本間ののか on 2019/11/16.
//  Copyright © 2019 本間ののか. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpBotton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setElements()
    }
    func setElements(){
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(signUpBotton)
    }
}

