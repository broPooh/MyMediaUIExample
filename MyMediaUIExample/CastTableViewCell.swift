//
//  CastTableViewCell.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/05.
//

import UIKit

class CastTableViewCell: UITableViewCell {
    
    static let identifier = "CastTableViewCell"

    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var castFirstLabel: UILabel!
    @IBOutlet weak var castSecondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        castImageViewConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func castImageViewConfig() {
        castImageView.layer.cornerRadius = 10
    }

}
