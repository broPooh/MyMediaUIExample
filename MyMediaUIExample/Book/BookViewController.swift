//
//  BookViewController.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/06.
//

import UIKit
import Toast

class BookViewController: UIViewController {
    
    let tvShowInformation = TvShowInformation()
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationConfig()
        bookCollectionViewConfig()
            
    }
    
    func navigationConfig() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "MY MEDIA", style: .plain, target: self, action: #selector(leftBarButtonItemDidTap))
    }
    
    @objc func leftBarButtonItemDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func bookCollectionViewConfig() {
        let nibName = UINib(nibName: Const.CustomCell.BookCollectionViewCell, bundle: nil)
        bookCollectionView.register(nibName, forCellWithReuseIdentifier: Const.CustomCell.BookCollectionViewCell)
        
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - (spacing * 3)
        
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.scrollDirection = .vertical
        
        bookCollectionView.collectionViewLayout = layout
    }
    
    @objc func posterButtonClicked(button: UIButton) {
        self.view.makeToast("\(button.tag) Button Clicked!")
    }

}

// MARK: - CollectionView delegate, datasource
extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShowInformation.tvShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.CustomCell.BookCollectionViewCell, for: indexPath) as? BookCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //임시 데이터
        let tvShow = tvShowInformation.tvShow[indexPath.row]
        let imageName = tvShow.title.lowercased().replacingOccurrences(of: " ", with: "_")
        
        cell.titleLabel.text = tvShow.title
        cell.rateLabel.text = "\(tvShow.rate)"
        cell.posterImageView.image = UIImage(named: imageName)
        
        cell.posterButton.tag = indexPath.row
        cell.posterButton.addTarget(self, action: #selector(posterButtonClicked(button:)), for: .touchUpInside)
        
        return cell
    }
    
    
}
