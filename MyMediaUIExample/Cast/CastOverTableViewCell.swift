//
//  CastOverTableViewCell.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/06.
//

import UIKit

class CastOverTableViewCell: UITableViewCell {
    
    static let identifier = "CastOverTableViewCell"

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        viewConfigure()
    }
    
    func viewConfigure() {
        selectionStyle = .none
    }
    
}
