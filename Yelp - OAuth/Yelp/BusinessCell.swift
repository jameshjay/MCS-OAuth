//
//  BusinessCell.swift
//  Yelp
//
//  Created by Zhaolong Zhong on 10/18/16.
//  
//

import UIKit
import Kingfisher

class BusinessCell: UITableViewCell {
    
    @IBOutlet var separatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet var seperatorView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var businessImageView: UIImageView!
    @IBOutlet var ratingImageView: UIImageView!
    @IBOutlet var categoriesLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var reviewsCountLabel: UILabel!
    @IBOutlet var snippetLabel: UILabel!
    
    var business: Business! {
        didSet {
            self.addressLabel.text = self.business.address
            self.categoriesLabel.text = self.business.categories
            self.distanceLabel.text = "\(self.business.distance!)"
            self.reviewsCountLabel.text = "\(self.business.reviewCount!) Reviews"
            self.snippetLabel.text = self.business.snippet!
            
            self.businessImageView.kf.indicatorType = .activity
            
            // Fade in loaded image
            // Set up round corner
            // Cache image after downloading
            if let imageURL = self.business.imageURL {
                let resource = ImageResource(downloadURL: imageURL, cacheKey: "\(imageURL)")
                self.businessImageView.kf.setImage(with: resource, placeholder: UIImage(named:"placeholder"), options: [.transition(.fade(0.2))])
            }
            
            let ratingResource = ImageResource(downloadURL: self.business.ratingImageURL!, cacheKey: "\(self.business.ratingImageURL)")
            self.ratingImageView.kf.setImage(with: ratingResource, options: [.transition(.fade(0.2))])
            self.ratingImageView.kf.setImage(with: self.business.ratingImageURL)
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initViews()
    }
    
    func initViews() {
        layoutMargins = .zero
        selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView?.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 0.8)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorHeightConstraint.constant = 0.5
        self.businessImageView.layer.cornerRadius = 4
        self.businessImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
