//
//  SearchViewController.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/04.
//

import UIKit

class SearchViewController: UIViewController {
    
    let tvShowInformation = TvShowInformation()    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationConfig()
        searchTableViewConfig()
    }

    // MARK: -  View Config
    func setUIConfig() {
        navigationConfig()
        searchTableViewConfig()
    }
    
    func navigationConfig() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftBarButtonItemDidTap))
    }

    func searchTableViewConfig() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    @objc func leftBarButtonItemDidTap() {
        dismissViewController()
    }
    
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - TableView delegate, datasource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShowInformation.tvShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        //임시 데이터
        let tvShow = tvShowInformation.tvShow[indexPath.row]
        
        let imageName = tvShow.title.lowercased().replacingOccurrences(of: " ", with: "_")
        
        cell.searchTitleLabel.text = tvShow.title
        cell.searchImageView.image = UIImage(named: imageName)
        cell.searchResultLabel.text = tvShow.genre
        cell.searchOverViewLabel.text = tvShow.overview
        
        return cell
    }
    
    
}
