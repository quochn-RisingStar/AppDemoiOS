//
//  ViewController.swift
//  IOSTraining
//
//  Created by ERT_Macbook_112 on 5/16/22.
//

import UIKit

enum SectionType: Int {
    case collection
    case normal

    static var numberOfSections: Int {
        return 2
    }
}

class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    var offsetYNew: CGFloat = 0
    var offsetYOld: CGFloat = 0
    let key = "BGvKsB3Ax5HEnOew5wkd4eonF1GkEo4f469rN3uvC-Q"
    var pictureInfos: [ImageInfo] = []
    var picturePersons: [ImageInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchImage { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case let .failure(error):
                DispatchQueue.main.async {
                    print("Error : \(error)")
                }
            }
        }
    }
}

private extension ViewController {
    func setupTableView() {
        setBarButtonItem(sizeIcon: 40)

        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        let myTableViewCellNib = UINib(nibName: "MyTableViewCell", bundle: nil)

        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.register(myTableViewCellNib, forCellReuseIdentifier: "MyTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionType(rawValue: section) {
        case .collection:
            return 1
        case .normal:
            return pictureInfos.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch SectionType(rawValue: indexPath.section) {
        case .collection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell",
                                                           for: indexPath) as?
                    MyTableViewCell else { return UITableViewCell() }
            cell.loadData(imageInfos: pictureInfos)
            cell.delegateColectionView = self
            return cell
        case .normal:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomerTableViewCell else {
                return UITableViewCell()}
            cell.loadData(url: pictureInfos[indexPath.row].urls.smallUrl)
            cell.setup(namePerson: pictureInfos[indexPath.row].user.name ?? "No Value",
                       activePerson: pictureInfos[indexPath.row].height!,
                       views: pictureInfos[indexPath.row].width!)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch SectionType(rawValue: indexPath.section) {
        case .collection:
            return 296.0
        case .normal:
            return 102
        default :
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch SectionType(rawValue: indexPath.section) {
        case .collection:
            print("sellec row \(indexPath.row)")

        case .normal:
            let nextView = storyboard?.instantiateViewController(
                withIdentifier: "DetailViewController") as? DetailViewController
            self.navigationController?.pushViewController( nextView!, animated: true)
            nextView!.imageInfo = self.pictureInfos[indexPath.row]
        default :
            print("No thing")
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("\(offsetY)")

        if offsetY > 0 && offsetY < 400 {
                offsetYNew = 1 - (offsetY/1200)
                navigationItem.rightBarButtonItem?.customView?.transform = CGAffineTransform(
                    scaleX: offsetYNew, y: offsetYNew)
        }
        if offsetY < 0 && offsetY > -400 {
            offsetYNew = 1 - (offsetY/200)
            navigationItem.rightBarButtonItem?.customView?.transform = CGAffineTransform(
                scaleX: offsetYNew,
                y: offsetYNew)
    }
}
}

extension ViewController {
    func fetchImage(completion: @escaping (Result<Void, Error>) -> Void) {
        let address = "https://api.unsplash.com/photos/?client_id=\(key)&order_by=ORDER&per_page=40"
        if let url = URL(string: address) {
            URLSession.shared.dataTask(with: url) { [weak self] data, responds, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let responds = responds as? HTTPURLResponse, let data = data {
                    print("Status Code : \(responds.statusCode)")
                    do { let decoder = JSONDecoder()
                        let picInfo =  try decoder.decode([ImageInfo].self, from: data)
                        self?.pictureInfos.append(contentsOf: picInfo)
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}

extension ViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    func setBarButtonItem(sizeIcon: Double) {
        let menuBtnRight = UIButton(type: .custom)
        menuBtnRight.frame = CGRect(x: 0.0, y: 0.0, width: sizeIcon, height: sizeIcon)
        menuBtnRight.setImage(UIImage(named: "Icon-Person-3"), for: .normal)
        let menuBarItemRight = UIBarButtonItem(customView: menuBtnRight)
        let currWidthRight = menuBarItemRight.customView?.widthAnchor.constraint(equalToConstant: sizeIcon)
        currWidthRight?.priority = UILayoutPriority(999)
        currWidthRight?.isActive = true
        let currHeightRight = menuBarItemRight.customView?.heightAnchor.constraint(equalToConstant: sizeIcon)
        currHeightRight?.priority = UILayoutPriority(999)
        currHeightRight?.isActive = true
        navigationItem.rightBarButtonItem = menuBarItemRight

        let menuBtnLeft = UIButton(type: .custom)
        menuBtnLeft.frame = CGRect(x: 0.0, y: 0.0, width: sizeIcon, height: sizeIcon)
        menuBtnLeft.setImage(UIImage(named: "Icon-Menu-3"), for: .normal)
        let menuBarItemLeft = UIBarButtonItem(customView: menuBtnLeft)
        let currWidthLeft = menuBarItemLeft.customView?.widthAnchor.constraint(equalToConstant: sizeIcon)
        currWidthLeft?.priority = UILayoutPriority(999)
        currWidthLeft?.isActive = true
        let currHeightLeft = menuBarItemLeft.customView?.heightAnchor.constraint(equalToConstant: sizeIcon)
        currHeightLeft?.priority = UILayoutPriority(999)
        currHeightLeft?.isActive = true
        navigationItem.leftBarButtonItem = menuBarItemLeft

        self.title = "Get Connected"
    }
}

extension ViewController: CollectionViewCellDelegate {
    func didSelectItem(_ imageInfo: ImageInfo) {
        let nextView = storyboard?.instantiateViewController(withIdentifier: "DetailViewController")
        as? DetailViewController
        self.navigationController?.pushViewController( nextView!, animated: true)
        nextView!.imageInfo = imageInfo
    }
}
