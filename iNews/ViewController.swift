//
//  ViewController.swift
//  iNews
//
//  Created by Volodymyr on 7/27/18.
//  Copyright © 2018 Volodymyr. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    static let dataManager = DataManager()
    static let network = Network()
    var array = [Articles]()
    let limitForPagination = 3
    var arrayForPagination = [Articles]()
    var fetchingMore = false
    @IBOutlet weak var newsTableView: UITableView!

    lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()

    override func awakeFromNib() {
        Network.network.getNews()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.newsTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getArray()
        newsTableView.refreshControl = refresh
    }

    @objc func refreshData() {
        refresh.beginRefreshing()
        Network.network.getNews()
        self.newsTableView.reloadData()
        refresh.endRefreshing()
    }

    func getArray() {
        let deadline = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.array = DataManager.dataManager.getCurrentArray(array: DataManager.dataManager.newsArray)
            for i in 0...self.limitForPagination - 1 {
                self.arrayForPagination.append(self.array[i])
            }
            self.newsTableView.reloadData()
        }
    }


    //MARK:- UITableViewMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayForPagination.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototypeCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsCell
        guard let cell = prototypeCell else { return UITableViewCell() }
        let item = arrayForPagination[indexPath.row]
        guard
            let sourceId = item.source?.id,
            let sourceName = item.source?.name,
            let author = item.author,
            let title = item.title,
            let description = item.description,
            let urlToImage = item.urlToImage
        else { return UITableViewCell() }
        let urlKey = URL(string: urlToImage)
        let data = try? Data(contentsOf: urlKey!)
        let image = UIImage(data: data!)
        cell.sourceLabel.text = sourceId + ": " + sourceName
        cell.authorLabel.text = author
        cell.titleLabel.text = title
        cell.descriptionLabel.text = description
        cell.newsImage.image = image

        return cell
    }

    //MARK:- SFSafariViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = array[indexPath.row].url else { return }
        showUrlInSafari(url: url)
    }

    func showUrlInSafari(url: String) {
        guard let safariUrl = URL(string: url) else { return }
        let webView = SFSafariViewController(url: safariUrl)
        present(webView, animated: true, completion: nil)
    }

    //MARK:- Pagination (Not working correctly)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = arrayForPagination.count - 1
        if indexPath.row == lastItem {
            loadMoreData()
        }
    }

    func loadMoreData() {
            let arrayIndex = self.arrayForPagination.count
            for index in arrayIndex...arrayIndex + self.limitForPagination {
                if index <= self.array.count - 1 {
                    self.arrayForPagination.append(self.array[index])
                } else {
                    break
                }
            self.newsTableView.reloadData()
        }

    }



}



