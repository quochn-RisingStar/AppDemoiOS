//
//  PersonCollectionViewCell.swift
//  IOSTraining
//
//  Created by ERT_Macbook_112 on 5/16/22.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageLive: UIImageView!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var viewsLable: UILabel!
    @IBOutlet weak var activePersonLable: UILabel!
    @IBOutlet weak var personNameLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        personImageView.layer.cornerRadius = 12
        personImageView.layer.borderWidth = 2.0
        personImageView.layer.borderColor = UIColor.white.cgColor
        imageLive.layer.cornerRadius = 12
        imageLive.layer.masksToBounds = true
    }

    func setup(namePerson: String, activePerson: Int, views: Int) {
        self.personNameLable.text = namePerson
        self.activePersonLable.text = "\(activePerson) Active"
        self.viewsLable.text = "\(views) views"
    }
}

extension PersonCollectionViewCell {
    func loadData(url: URL) {
        let queueImage = DispatchQueue(label: "loadImage", attributes: .concurrent)
        queueImage.async {
            do {
                let data =  try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.personImageView.image = UIImage(data: data)
                }
            } catch {}
        }
    }
}
