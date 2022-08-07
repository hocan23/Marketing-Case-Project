//
//  CollectionViewCell.swift
//  MomentupCase
//
//  Created by Hasan Onur Can on 8/6/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!

    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var addBagButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth=1
        contentView.layer.cornerRadius=10
        contentView.layer.borderColor = UIColor.lightGray.cgColor
       
    }
   
}
