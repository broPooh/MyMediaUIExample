//
//  BookCollectionViewCell.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/06.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BookCollectionViewCell"

    @IBOutlet weak var posterButton: UIButton!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewConfig()
        labelConfig()
        
    }
    
    func viewConfig() {
        cellBackgroundView.clipsToBounds = true
        cellBackgroundView.layer.cornerRadius = 15
        
        
        let rgb: (CGFloat, CGFloat, CGFloat) = (randomCGFloat(), randomCGFloat(), randomCGFloat())
        
        cellBackgroundView.backgroundColor = UIColor(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: 1)
    }
    
    
    func labelConfig() {
        titleLabel.textColor = .white
        rateLabel.textColor = .white
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(Int.random(in: 0 ... 255)) / 255
    }

}
