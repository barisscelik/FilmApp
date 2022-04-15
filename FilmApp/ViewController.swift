//
//  ViewController.swift
//  FilmApp
//
//  Created by barış çelik on 15.04.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        // Checking Internet Connetion
        
        NetworkChecker.shared.getConnetctionStatus { [weak self] isConnected in
            DispatchQueue.main.sync {
                self?.view.backgroundColor = isConnected ? .systemCyan : .systemPink
            }
            
        }
     }
    


}

