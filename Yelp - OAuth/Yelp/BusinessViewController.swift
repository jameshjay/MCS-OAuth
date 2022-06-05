//
//  ViewController.swift
//  Yelp
//
//  
//  
//

import UIKit

@objc protocol BusinessViewControllerDelegate {
    @objc optional func businessViewController(businessViewController: BusinessViewController, loadMoreData: Bool)
    func businessViewController(businessViewController: BusinessViewController, didSelect business: Business)
}

class BusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    static let TAG = NSStringFromClass(BusinessViewController.self)

    @IBOutlet var tableView: UITableView!
    
    let businessCell = "BusinessCell"
    var loadingMoreView:InfiniteScrollActivityView?
    var isMoreDataLoading = false
    var businesses: [Business]? {
        didSet {
            self.invalidateViews()
            // Update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
        }
    }
    
    var searchText = ""
    weak var delegate: BusinessViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: self.businessCell, bundle: nil), forCellReuseIdentifier: self.businessCell)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.keyboardDismissMode = .onDrag
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        self.loadingMoreView = InfiniteScrollActivityView(frame: frame)
        self.loadingMoreView!.isHidden = true
        self.tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    
    func invalidateViews() {
        if self.isViewLoaded {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.businessCell, for: indexPath) as! BusinessCell
        
        let business = self.businesses?[indexPath.row]
        cell.business = business
        cell.nameLabel.text = "\(indexPath.row + 1). \(business!.name!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? BusinessCell {
            self.delegate?.businessViewController(businessViewController: self, didSelect: cell.business)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height

            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true

                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                // Load more results
                self.delegate?.businessViewController!(businessViewController: self, loadMoreData: true)
            }
        }
    }

}

