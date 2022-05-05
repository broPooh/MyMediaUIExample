//
//  MainTableViewCell.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/04.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    static let identifier = "MainTableViewCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var linkButton: UIButton!
    
    var delegate: ComponentMainCellDelegate?
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewConfigure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func viewConfigure() {
        self.selectionStyle = .none
        
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowRadius = 7
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = .zero
    }

    
    @IBAction func lickButtonClicked(_ sender: UIButton) {
        self.delegate?.clickedLinkButton(index: index)
    }
    
}

protocol ComponentMainCellDelegate {
    func clickedLinkButton(index: Int)
}
