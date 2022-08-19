//
//  FavoriteViewController.swift
//  MomentupCase
//
//  Created by Hasan Onur Can on 8/6/22.
//

import UIKit
import SwiftUI

class ProductDetailViewController: UIViewController {
    //    var selectedProduct:Product?
    //    var favoriteProducts : [String] = []
    var selectedItemNumber : Int = 0
    //    var bagProducts : [String] = []
    
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    var viewModal = ProductDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startApp()
        //        setupUi()
        
    }
    
    
    func startApp (){
        
        setupUi(selectNumber: selectedItemNumber)
        viewModal.selectedProduct = viewModal.sortedProducts![self.selectedItemNumber]
        if viewModal.sortedProducts![selectedItemNumber].isFavorite == true{
            likeImage.image = UIImage(named: "Group 52")
        }else{
            likeImage.image = UIImage(named: "Group 51")
        }
        if viewModal.sortedProducts![selectedItemNumber].isInBag == true{
            addImage.image = UIImage(systemName: "bag.fill")
            
        }else{
            addImage.image = UIImage(systemName: "bag")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
    func setupUi(selectNumber:Int){
        
        self.title = "\(viewModal.sortedProducts![selectNumber].name)"
        productImage.image = UIImage(named: viewModal.sortedProducts![selectNumber].imageName)
        headerLabel.text = "\(viewModal.sortedProducts![selectNumber].category)\n\(viewModal.sortedProducts![selectNumber].name)/\(viewModal.sortedProducts![selectNumber].color)"
        bottomLabel.text = "\(viewModal.sortedProducts![selectNumber].price) \(viewModal.sortedProducts![selectNumber].currency)"
        rightView.layer.borderWidth = 1
        rightView.layer.borderColor = UIColor(named: "grey")?.cgColor
        rightView.layer.cornerRadius = rightView.frame.height*0.5
        leftView.layer.borderWidth = 1
        leftView.layer.borderColor = UIColor(named: "grey")?.cgColor
        leftView.layer.cornerRadius = leftView.frame.height*0.5
        leftView.isUserInteractionEnabled = true
        leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftViewTapped)))
        rightView.isUserInteractionEnabled = true
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightViewTapped)))
    }
    // MARK: - Buttons  Func.
    
    @objc func rightViewTapped() {
        viewModal.addTapped(addImage: addImage)
    }
    @objc func leftViewTapped() {
        viewModal.favoriteTapped(favoriteImage: likeImage)
    }
}
