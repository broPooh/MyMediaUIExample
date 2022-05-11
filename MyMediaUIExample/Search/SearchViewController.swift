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

class SearchViewController: BaseViewController {
    
    let tvShowInformation = TvShowInformation()
    
    var movieData: [MovieModel] = []

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var startPage = 1
    var totalCount = 2000
    var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationConfig()
        searchTableViewConfig()
        searchBarConfig()
        
    }
    
    func fetchMovieData(queryText: String, startPage: Int) {
        if let query = queryText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            self.query = queryText
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
                    
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                    
                    
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
    
    func searchBarConfig() {
        searchBar.delegate = self
        
    }

}

// MARK: - TableView UITableViewDataSourcePrefetching
extension SearchViewController: UITableViewDataSourcePrefetching {
    
    //셀이 화면에 보이기 전에 필요한 리소스를 미리 다운 받는 기능
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if movieData.count - 1 == indexPath.row && movieData.count < totalCount{
                startPage += 10
                if let text = searchBar.text {
                    fetchMovieData(queryText: text, startPage: startPage)
                }
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
        
        return cell
    }
    
    
}

// MARK: - SearchBar
extension SearchViewController: UISearchBarDelegate {
    
    
    //검색 버튼(키보드 리턴키)를 눌렀을 때 실행
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            startPage = 1
            movieData.removeAll()
            fetchMovieData(queryText: text, startPage: startPage)
        }

    }
    
    //취소 버튼 눌렀을 때 실행
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movieData.removeAll()
        searchTableView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //서치바에서 커서가 깜빡이기 시작했을 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
}
