//
//  CastViewController.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/05.
//

import UIKit
import Kingfisher

class CastViewController: UIViewController {
    
    let tvShowInformation = TvShowInformation()
    
    var tvShowData: TvShow?

    @IBOutlet weak var castTableView: UITableView!
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationConfig()
        castTableViewConfig()
        titleLabelConfig()
        posterImageViewConfig()
        
        initData(tvShowData: tvShowData)
    }
    
    func castTableViewConfig() {
        castTableView.delegate = self
        castTableView.dataSource = self
    }
    
    func initData(tvShowData: TvShow?) {
        guard let tvShow = tvShowData else {
            return showNonDataAlert()
        }
        
        let backdropUrl = URL(string: tvShow.backdropImage)
        backdropImageView.kf.setImage(with: backdropUrl)
        
        let imageName = tvShow.title.lowercased().replacingOccurrences(of: " ", with: "_")
        posterImageView.image = UIImage(named: imageName)
        titleLabel.text = tvShow.title
    }
    

    func navigationConfig() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "MY MEDIA", style: .plain, target: self, action: #selector(leftBarButtonItemDidTap))
    }
    
    func titleLabelConfig() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    func posterImageViewConfig() {
        posterImageView.layer.cornerRadius = 10
        posterImageView.contentMode = .scaleToFill
    }
    
    
    @objc func leftBarButtonItemDidTap() {
        popViewController()
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showNonDataAlert() {
        let alert = UIAlertController(title: "TvShow Error", message: "데이터를 가져오는데 실패하였습니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .default, handler: { _ in self.popViewController() })
        alert.addAction(cancel)
        present(alert, animated: true)
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

