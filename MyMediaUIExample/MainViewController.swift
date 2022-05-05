//
//  MainViewController.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/04.
//

import UIKit

class MainViewController: UIViewController {
    
    let tvShowInformation = TvShowInformation()
    
    @IBOutlet weak var selectTableView: UIView!
    @IBOutlet weak var selctBackgroundView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContentTableViewConfig()
        setTableViewConfig()
    }
    
    
    // MARK: -  View Config
    func setContentTableViewConfig() {
        selectTableView.clipsToBounds = true
        selectTableView.layer.cornerRadius = 10
        
        
        selctBackgroundView.layer.cornerRadius = 10
        selctBackgroundView.layer.shadowColor = UIColor.gray.cgColor
        selctBackgroundView.layer.shadowRadius = 7
        selctBackgroundView.layer.shadowOpacity = 0.5
        selctBackgroundView.layer.shadowOffset = .zero
    }
    
    func setTableViewConfig() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    @IBAction func listBarButtonItemClicked(_ sender: UIBarButtonItem) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: "CastViewController") as! CastViewController
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
    
    @IBAction func searchBarButtonItemClicked(_ sender: UIBarButtonItem) {
        //let searchStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.modalPresentationStyle = .fullScreen
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - TableView delegate, datasource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShowInformation.tvShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("test")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier) as? MainTableViewCell else {
            print("error")
            return UITableViewCell()
        }
        
        let tvShow = tvShowInformation.tvShow[indexPath.row]
        print(tvShow)
        
        let imageName = tvShow.title.lowercased().replacingOccurrences(of: " ", with: "_")
            
        cell.dateLabel.text = tvShow.releaseDate
        cell.genreLabel.text = "#\(tvShow.genre)"
        cell.posterImageView.image = UIImage(named: imageName)
        cell.castLabel.text = tvShow.starring
        cell.titleLabel.text = tvShow.title
        cell.rateLabel.text = "\(tvShow.rate)"
        
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
