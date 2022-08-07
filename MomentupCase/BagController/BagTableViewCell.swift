//
//  BagTableViewCell.swift
//  MomentupCase
//
//  Created by Hasan Onur Can on 8/7/22.
//

import UIKit

class BagTableViewCell: UITableViewCell {

    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        removeButton.clipsToBounds = true
            removeButton.layer.cornerRadius = 10
        removeButton.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        // Initialization code
    }
    override func layoutSubviews() {
          super.layoutSubviews()
          let bottomSpace: CGFloat = 10.0 // Let's assume the space you want is 10
          self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: bottomSpace, right: 10))
     }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
