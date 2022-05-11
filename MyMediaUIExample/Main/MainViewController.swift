//
//  MainViewController.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/04.
//

import UIKit

import JGProgressHUD

class MainViewController: BaseViewController {
    
    let tvShowInformation = TvShowInformation()
    
    @IBOutlet weak var selectContainerView: UIView!
    @IBOutlet weak var selctBackgroundView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var bookButton: UIButton!
    
    var mediaType: TrendingMediaType = .movie
    var windowType: TrendingWindowType = .day
    
    var progress = JGProgressHUD()
    
    var currentPage = 1
    var totalPage = 0
        
    var trendingDatas: [TmdbTrendingData] = [] {
        didSet {
            mainTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContentTableViewConfig()
        setTableViewConfig()
        initTrendingData()
    }
    
    func initTrendingData() {
        fetchTrendData(mediaType: mediaType, windowType: windowType, page: currentPage)
    }
    
    
    // MARK: -  View Config
    func setContentTableViewConfig() {
        selectContainerView.clipsToBounds = true
        selectContainerView.layer.cornerRadius = 10
        
        
        selctBackgroundView.layer.cornerRadius = 10
        selctBackgroundView.layer.shadowColor = UIColor.gray.cgColor
        selctBackgroundView.layer.shadowRadius = 7
        selctBackgroundView.layer.shadowOpacity = 0.5
        selctBackgroundView.layer.shadowOffset = .zero
    }
    
    func setTableViewConfig() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.prefetchDataSource = self
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
    
    @IBAction func bookButtonClicked(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: Const.ViewController.BookViewController) as! BookViewController
        self.navigationController?.pushViewController(vc, animated: true )
        
    }
    
    @IBAction func locationBarButtonItemClicked(_ sender: UIBarButtonItem) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: Const.ViewController.MapViewController) as? MapViewController else {
            print("Error") // 에러 문구 혹은 얼럿으로 처리
            return
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchTrendData(mediaType: TrendingMediaType, windowType: TrendingWindowType, page: Int) {
        TmdbAPIManager.shared.fetchTrendingTmdbData(mediaType: mediaType, windowType: windowType, page: page) { code, trendingDatas, totalPage in
            self.currentPage = page
            self.totalPage = totalPage
            self.trendingDatas.append(contentsOf: trendingDatas)
        }
    }
    
}

// MARK: - TableView UITableViewDataSourcePrefetching
extension MainViewController: UITableViewDataSourcePrefetching {
    //셀이 화면에 보이기 전에 필요한 리소스를 미리 다운 받는 기능
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if trendingDatas.count - 1 == indexPath.row && trendingDatas.count < totalPage {
                currentPage += 1
                self.fetchTrendData(mediaType: self.mediaType, windowType: self.windowType, page: currentPage)
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
extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return tvShowInformation.tvShow.count
        return trendingDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("test")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier) as? MainTableViewCell else {
            print("error")
            return UITableViewCell()
        }
        
        
        let trendingData = trendingDatas[indexPath.row]
        
        cell.delegate = self
        cell.index = indexPath.row
                    
        cell.bindData(trendingData: trendingData)
        
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "CastViewController") as? CastViewController else {
            print("CastViewController not Found")
            return
        }
        
        //vc.tvShowData = tvShowInformation.tvShow[indexPath.row]
        vc.trendingData = trendingDatas[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
}


extension MainViewController: ComponentMainCellDelegate {

    func clickedLinkButton(index: Int) {
        progress.show(in: view, animated: true)
        
        TmdbAPIManager.shared.fetchVideoData(movieId: trendingDatas[index].id) { code, youtubeKey in
            guard let key = URL(string: Const.EndPoint.youtubeUrl(key: youtubeKey)) else { self.progress.dismiss(animated: true); return }
            
            guard UIApplication.shared.canOpenURL(key) else { self.progress.dismiss(animated: true); return }
            
            UIApplication.shared.open(key, options: [:], completionHandler: nil)
            self.progress.dismiss(animated: true)
        }
    }
}
