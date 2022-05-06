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
    
    var isOverState = true
    
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
        
        connectOverviewCell()
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
    
    func connectOverviewCell() {
        //XIB 파일 연결
        let nibName = UINib(nibName: CastOverTableViewCell.identifier, bundle: nil)
        castTableView.register(nibName, forCellReuseIdentifier: CastOverTableViewCell.identifier)
    }
    
    @objc func showMoreOverView(moreButton: UIButton) {
        
        isOverState = !isOverState
        
        let image = isOverState ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
        moreButton.setImage(image, for: .normal)
//        if overviewLabel.numberOfLines == 1 {
//            overviewLabel.numberOfLines = 0
//            moreButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
//        } else {
//            overviewLabel.numberOfLines = 1
//            moreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
//        }
        castTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }


}


// MARK: - TableView delegate, datasource
extension CastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CastCell.allCases.count
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == CastCell.overview.rawValue {
            return 1
        } else {
            return tvShowInformation.tvShow.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //임시 데이터
        let tvShow = tvShowInformation.tvShow[indexPath.row]
        
        if indexPath.section == CastCell.overview.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastOverTableViewCell.identifier) as? CastOverTableViewCell else {
                print("error")
                return UITableViewCell()
            }
           
            cell.overviewLabel.text = tvShow.overview
            cell.overviewLabel.numberOfLines = isOverState ? 1 : 0
            
            let image = isOverState ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
            cell.moreButton.setImage(image, for: .normal)
            cell.moreButton.addTarget(self, action: #selector(showMoreOverView(moreButton:)), for: .touchUpInside)
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier) as? CastTableViewCell else {
                return UITableViewCell()
            }
            
            //임시 데이터
            //let tvShow = tvShowInformation.tvShow[indexPath.row]
            
            let imageName = tvShow.title.lowercased().replacingOccurrences(of: " ", with: "_")
            
            cell.castImageView.image = UIImage(named: imageName)
            cell.castFirstLabel.text = tvShow.title
            cell.castSecondLabel.text = tvShow.genre
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

enum CastCell: Int, CaseIterable {
    case overview = 0
    case tvshow = 1
}
