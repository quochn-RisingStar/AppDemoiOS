//
//  CustomTableViewCell.swift
//  IOSTraining
//
//  Created by ERT_Macbook_112 on 5/16/22.
//

import UIKit

class CustomerTableViewCell: UITableViewCell {
    @IBOutlet weak var viewsLable: UILabel!
    @IBOutlet weak var activePersonLable: UILabel!
    @IBOutlet weak var imagePerson: UIImageView!
    @IBOutlet weak var personNameLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imagePerson.layer.cornerRadius = 12
        layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0))
    }

    func setup(namePerson: String, activePerson: Int, views: Int) {
        self.personNameLable.text = namePerson
        self.activePersonLable.text = "\(activePerson) Active"
        self.viewsLable.text = "\(views) views"
    }
}

extension CustomerTableViewCell {
    func loadData(url: URL) {
        let queueImage = DispatchQueue(label: "loadImage", attributes: .concurrent)
        queueImage.async {
            do {
                let data =  try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.imagePerson.image = UIImage(data: data)
                }
            } catch {}
        }
    }
}
