//
//  HomepageViewController.swift
//  FilmApp
//
//  Created by barış çelik on 16.04.2022.
//

import UIKit
import PKLoader

final class HomepageViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        view.backgroundColor = .systemMint
        return view
    }()
    
    private let searchController = UISearchController()
    
    private var searchString: String = ""
    
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.center = view.center
        view.backgroundColor = .white
        title = "HomePage"
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(searchAction))
        
        
    }
    
    @objc private func searchAction() {
        
        OMDBAPICalller.shared.fetchFilms(key: searchString) {[weak self] result in
            PKLoader.shared.stopAnimating()
            self?.imageView.removeFromSuperview()
//            self?.isLoading = false
            
            switch result {
            case .success(let filmModel):
                print("Model Size : \(filmModel.count)")
                break
            case .failure(let error):
                // MARK: - Alert here...
                print(error)
                break
            }
        }
    }

}

extension HomepageViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if !isLoading {
            view.addSubview(imageView)
            PKLoader.shared.startAnimating(onView: imageView)
            isLoading = true
        }
        
        guard let text = searchController.searchBar.text else {
            return
        }
        
        searchString = text
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        PKLoader.shared.stopAnimating()
        imageView.removeFromSuperview()
        isLoading = false
    }
}
