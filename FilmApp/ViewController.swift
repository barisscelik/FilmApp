//
//  ViewController.swift
//  FilmApp
//
//  Created by barış çelik on 15.04.2022.
//

import UIKit
import FirebaseRemoteConfig

final class ViewController: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 32)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let remoteConfig = RemoteConfig.remoteConfig()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        view.addSubview(label)
        fetchText()
        checkInternetConnection()
        
     }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        label.center = view.center
    }
    
    private func checkInternetConnection() {
        NetworkChecker.shared.getConnetctionStatus { [weak self] isConnected in
            DispatchQueue.main.async {
                if !isConnected {
                    let alert = UIAlertController(title: "Internet Status",
                                                  message: "There is no internet!!",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    private func fetchText() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] status, error in
            if status == .success, error == nil {
                self?.remoteConfig.activate(completion: { _, error in
                    if error == nil {
                        DispatchQueue.main.sync {
                            self?.label.text = self?.remoteConfig.configValue(forKey: "text_view").stringValue
                            self?.fireTimer()
                        }
                    }
                })
            } else {
                print("Something went wrong")
            }
        }
    }
    
    private func fireTimer() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { timer in
            timer.invalidate()
            // MARK: - Present here
        }
    }

}

