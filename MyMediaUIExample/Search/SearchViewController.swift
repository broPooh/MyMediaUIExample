//
//  SearchViewController.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/04.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class SearchViewController: UIViewController {
    
    let tvShowInformation = TvShowInformation()
    
    var movieData: [MovieModel] = []

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var startPage = 1
    var totalCount = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationConfig()
        searchTableViewConfig()
        
        fetchMovieData()
    }
    
    func fetchMovieData() {
        if let query = "사랑".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    
            let url = "https://openapi.naver.com/v1/search/movie.json?query=\(query)&display=10&start=\(startPage)"
        
                        
            let header: HTTPHeaders = [
                "X-Naver-Client-Id": "XZYepFe6MOuORvgRH1Vx",
                "X-Naver-Client-Secret" : "fvD4rXIzfn"
            ]
            
            AF.request(url, method: .get, headers: header).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                     
                    for item in json["items"].arrayValue {
                        
                        let title = item["title"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                        
                        let image = item["image"].stringValue
                        let link = item["link"].stringValue
                        let userRating = item["userRating"].stringValue
                        let subtitle = item["subtitle"].stringValue
                        
                        let data = MovieModel(titleData: title, imageData: image, linkData: link, userRatingData: userRating, subtitle: subtitle)
                        
                        
                        self.movieData.append(data)
                    }
                    
                    self.searchTableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
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
        searchTableView.prefetchDataSource = self
    }
    
    @objc func leftBarButtonItemDidTap() {
        dismissViewController()
    }
    
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - TableView UITableViewDataSourcePrefetching
extension SearchViewController: UITableViewDataSourcePrefetching {
    
    //셀이 화면에 보이기 전에 필요한 리소스를 미리 다운 받는 기능
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if movieData.count - 1 == indexPath.row && movieData.count < totalCount{
                startPage += 10
                fetchMovieData()
                print("prefetch: \(indexPaths)")
            }
        }
    }
    
    //취소
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("취소:\(indexPaths)")
    }
        
}

// MARK: - TableView delegate, datasource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let movieData = movieData[indexPath.row]
        cell.searchTitleLabel.text = movieData.titleData
        cell.searchOverViewLabel.text = movieData.linkData
        cell.searchResultLabel.text = movieData.subtitle
        
        if let url = URL(string: movieData.imageData) {
            cell.searchImageView.kf.setImage(with: url)
        } else {
            cell.searchImageView.image = UIImage(systemName: "star")
        }
        
        
        //임시 데이터
        //let tvShow = tvShowInformation.tvShow[indexPath.row]
        
        //let imageName = tvShow.title.lowercased().replacingOccurrences(of: " ", with: "_")
        
        //cell.searchTitleLabel.text = tvShow.title
        //cell.searchImageView.image = UIImage(named: imageName)
        //cell.searchResultLabel.text = tvShow.genre
        //cell.searchOverViewLabel.text = tvShow.overview
        
        return cell
    }
    
    
}

// MARK: - SearchBar
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
    }
}
