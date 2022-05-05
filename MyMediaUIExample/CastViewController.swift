//
//  CastViewController.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/05.
//

import UIKit

class CastViewController: UIViewController {
    
    let tvShowInformation = TvShowInformation()

    @IBOutlet weak var castTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationConfig()
        castTableViewConfig()
    }
    
    func castTableViewConfig() {
        castTableView.delegate = self
        castTableView.dataSource = self
    }
    

    func navigationConfig() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "MY MEDIA", style: .plain, target: self, action: #selector(leftBarButtonItemDidTap))
    }
    
    @objc func leftBarButtonItemDidTap() {
        self.navigationController?.popViewController(animated: true)
    }

}


// MARK: - TableView delegate, datasource
extension CastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShowInformation.tvShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier) as? CastTableViewCell else {
            return UITableViewCell()
        }
        
        //임시 데이터
        let tvShow = tvShowInformation.tvShow[indexPath.row]
        
        let imageName = tvShow.title.lowercased().replacingOccurrences(of: " ", with: "_")
        
        cell.castImageView.image = UIImage(named: imageName)
        cell.castFirstLabel.text = tvShow.title
        cell.castSecondLabel.text = tvShow.genre
        
        return cell
    }
    
    
}

