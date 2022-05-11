//
//  CastViewController.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/05.
//

import UIKit
import Kingfisher
import JGProgressHUD

class CastViewController: UIViewController {
    
    let tvShowInformation = TvShowInformation()
    
    var tvShowData: TvShow?
    var trendingData: TmdbTrendingData?

    @IBOutlet weak var castTableView: UITableView!
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isOverState = true
    
    var casts: [Cast] = []
    var crews: [Crew] = []
    
    var progress = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationConfig()
        castTableViewConfig()
        titleLabelConfig()
        posterImageViewConfig()
        
        initData(trendingData: trendingData)
    }
    
    func castTableViewConfig() {
        castTableView.delegate = self
        castTableView.dataSource = self
        
        connectOverviewCell()
    }
    
    func initData(trendingData: TmdbTrendingData?) {
        guard let trendingData = trendingData else {
            return showNonDataAlert()
        }
        backdropImageView.kf.setImage(with: URL(string: trendingData.backdropPath))
        posterImageView.kf.setImage(with: URL(string: trendingData.posterPath))
        titleLabel.text = trendingData.title
        
        fetchCreditData(movieId: trendingData.id)
    }
    
    func fetchCreditData(movieId: Int) {
        progress.show(in: view, animated: true)
        TmdbAPIManager.shared.fetchCeditData(movieId: movieId) { statusCode, creditData in
            self.casts = creditData.casts
            self.crews = creditData.crews
            
            self.castTableView.reloadData()
            self.progress.dismiss(animated: true)
        }
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
        let alert = UIAlertController(title: "Data Error", message: "데이터를 가져오는데 실패하였습니다.", preferredStyle: .alert)
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

        castTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }

}


// MARK: - TableView delegate, datasource
extension CastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CastCell.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case CastCell.overview.rawValue: return ""
        case CastCell.cast.rawValue: return "Cast"
        case CastCell.crew.rawValue: return "Crew"
        default: return ""
        }
    }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == CastCell.overview.rawValue {
            return 1
        } else if section == CastCell.cast.rawValue {
            return casts.count
        } else {
            return crews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                       
        
        if indexPath.section == CastCell.overview.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastOverTableViewCell.identifier) as? CastOverTableViewCell else {
                print("error")
                return UITableViewCell()
            }
           
            cell.overviewLabel.text = self.trendingData?.overview
            cell.overviewLabel.numberOfLines = isOverState ? 1 : 0
            
            let image = isOverState ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
            cell.moreButton.setImage(image, for: .normal)
            cell.moreButton.addTarget(self, action: #selector(showMoreOverView(moreButton:)), for: .touchUpInside)
            return cell
            
        } else if indexPath.section == CastCell.cast.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier) as? CastTableViewCell else {
                return UITableViewCell()
            }
            
            let cast = casts[indexPath.row]
            
            cell.castImageView.kf.setImage(with: URL(string: cast.profilePath ?? ""), placeholder: UIImage(systemName: "star"))
            cell.castFirstLabel.text = cast.name
            cell.castSecondLabel.text = cast.character
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier) as? CastTableViewCell else {
                return UITableViewCell()
            }
            
            let crew = crews[indexPath.row]
            
            cell.castImageView.kf.setImage(with: URL(string: crew.profilePath ?? ""), placeholder: UIImage(systemName: "star"))
            cell.castFirstLabel.text = crew.name
            cell.castSecondLabel.text = crew.job
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

enum CastCell: Int, CaseIterable {
    case overview = 0
    case cast = 1
    case crew = 2
}
