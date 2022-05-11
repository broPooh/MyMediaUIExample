//
//  SearchTableViewCell.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/04.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"

    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var searchResultLabel: UILabel!
    @IBOutlet weak var searchOverViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    func viewConfig() {
        selectionStyle = .none
    }

}
