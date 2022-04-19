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
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(FilmTableViewCell.self, forCellReuseIdentifier: FilmTableViewCell.identifier)
        return table
    }()
    
    private let searchController = UISearchController()
    
    private var searchString: String = ""
    
    private var isLoading = false
    
    private var filmModel: [FilmModel] = [FilmModel]()
    
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
        
        let group = DispatchGroup()
        
        for year in 1960..<2023 {
            group.enter()
            OMDBAPICalller.shared.fetchFilms(key: searchString, year: String(year)) { [weak self] result in
                
                switch result {
                case .success(let filmModel):
                    self?.filmModel.append(filmModel)
                    break
                case .failure(_):
                    break
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            PKLoader.shared.stopAnimating()
            strongSelf.imageView.removeFromSuperview()
            
            if strongSelf.filmModel.count > 0 {
                strongSelf.setTableView()
            } else {
                strongSelf.showAlert()
            }
        }
        
    }
    
    private func showAlert() {
        // MARK: - Alert here...
    }
    
    private func setTableView() {
        print(filmModel.count)
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 100,
                                 width: view.frame.width,
                                 height: view.frame.height)
        
        
        tableView.delegate = self
        tableView.dataSource = self
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

extension HomepageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmModel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = filmModel[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.identifier,
                                                       for: indexPath) as? FilmTableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = cellModel.Title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // MARK: - Present datailview in here
    }
    
    
    
    
}
