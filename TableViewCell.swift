//
//  TableViewCell.swift
//  IOSTraining
//
//  Created by ERT_Macbook_112 on 5/19/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var namePersonLable: UILabel!
    @IBOutlet var imageLine: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
