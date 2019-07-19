//
//  ValueCell.swift
//  Demo
//
//  Created by 王 きん on 2019/07/18.
//

import UIKit

class ValueCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(by label: String) {
        self.label.text = label
    }
    
}
