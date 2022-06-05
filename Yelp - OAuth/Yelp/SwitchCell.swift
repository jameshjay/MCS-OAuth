//
//  SwitchCell.swift
//  Yelp
//
//  Created by Zhaolong Zhong on 10/19/16.
//  
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet var switchLabel: UILabel!
    @IBOutlet var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.onSwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged), for: .valueChanged)
        
        switchLabel.isHidden = true
        onSwitch.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged() {
        self.delegate?.switchCell!(switchCell: self, didChangeValue: onSwitch.isOn)
    }
    
}
