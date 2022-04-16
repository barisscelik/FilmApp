//
//  HomepageViewController.swift
//  FilmApp
//
//  Created by barış çelik on 16.04.2022.
//

import UIKit
import PKLoader

final class HomepageViewController: UIViewController {
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        view.backgroundColor = .systemMint
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        view.addSubview(imageView)
        imageView.center = view.center
        
        PKLoader.shared.startAnimating(onView: imageView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            PKLoader.shared.stopAnimating()
            self?.imageView.removeFromSuperview()
        }
    }

}
