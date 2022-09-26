//
//  NextViewController.swift
//  IOSTraining
//
//  Created by ERT_Macbook_112 on 5/20/22.
//

import UIKit

class DetailViewController: UIViewController {
    let headerView = StretchyTableHeaderView()
    @IBOutlet var superTableView: UITableView!
    var imageInfo: ImageInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height*513/812)
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        superTableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        superTableView.dataSource = self
        superTableView.delegate = self

        if let imageInfo = imageInfo {
            loadData(url: imageInfo.urls.regularUrl)
        }
        superTableView.tableHeaderView = headerView
        superTableView.separatorStyle = .none
        superTableView.allowsSelection = false
    }

    func loadData(url: URL) {
        let queueImage = DispatchQueue(label: "loadImage", attributes: .concurrent)
        queueImage.async {
            do {
                let data =  try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.headerView.imageView.image =  UIImage(data: data)
                }
            } catch {}
        }
    }

    internal  override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = superTableView.dequeueReusableCell(
            withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.namePersonLable.text = imageInfo?.user.name ?? "No Value"
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height*299/812
    }
}

extension DetailViewController {
    @IBAction func backToViewControler(_ sender: Any) {
        _ = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = self.superTableView.tableHeaderView as? StretchyTableHeaderView else {return  }
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}
