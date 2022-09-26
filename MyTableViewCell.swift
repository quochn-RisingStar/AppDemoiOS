//
//  MyTableViewCell.swift
//  IOSTraining
//
//  Created by ERT_Macbook_112 on 5/18/22.
//

import UIKit

protocol    CollectionViewCellDelegate: AnyObject {
    func didSelectItem(_ imageInfo: ImageInfo)
}

class MyTableViewCell: UITableViewCell {
    weak var delegateColectionView: CollectionViewCellDelegate?
    @IBOutlet private var collectionView: UICollectionView!

    private var picturePersons: [ImageInfo] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    func loadData(imageInfos: [ImageInfo]) {
        picturePersons = imageInfos
        collectionView.reloadData()
    }

    func setupCollectionView() {
        let collectionViewNib = UINib(nibName: "PersonCollectionViewCell", bundle: nil)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(collectionViewNib, forCellWithReuseIdentifier: "PersonCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

// MARK: - UICollectionViewDataSource

extension MyTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picturePersons.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PersonCollectionViewCell", for: indexPath) as? PersonCollectionViewCell else {
            return UICollectionViewCell() }
        cell.loadData(url: picturePersons[indexPath.row].urls.smallUrl)
        cell.setup(namePerson: picturePersons[indexPath.row].user.name ?? "No Value",
                   activePerson: picturePersons[indexPath.row].height!, views: picturePersons[indexPath.row].width!)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateColectionView?.didSelectItem(picturePersons[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20.0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 296.0, height: 238.0)
    }
}
