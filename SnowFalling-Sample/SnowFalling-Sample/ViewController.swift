//
//  ViewController.swift
//  SnowFalling-Sample
//
//  Created by pixyzehn on 2/13/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sfv: SnowFallingView?
    
    enum State {
        case Snowing
        case Stoping
    }
    
    var currentState: State = .Snowing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sfv = SnowFallingView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width * 2, height: view.frame.size.height * 2))
        sfv?.flakesCount = 100
        view.addSubview(sfv!)
        sfv?.startSnow()
        
        // Triple tap action
        let tripleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTripleTap))
        tripleTap.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTap)
    }
    
    @objc func handleTripleTap() {
        if currentState == .Snowing {
            sfv?.stopSnow()
            currentState = .Stoping
        } else {
            sfv?.startSnow()
            currentState = .Snowing
        }
    }
    
}
