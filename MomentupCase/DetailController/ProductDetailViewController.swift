//
//  FavoriteViewController.swift
//  MomentupCase
//
//  Created by Hasan Onur Can on 8/6/22.
//

import UIKit

class ProductDetailViewController: UIViewController {
    var selectedProduct:Product?
    var favoriteProducts : [String] = []
    var selectedItemNumber : Int = 0
    var bagProducts : [String] = []
    
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(selectedProduct)
        if selectedProduct!.isFavorite == true{
            likeImage.image = UIImage(named: "Group 52")
        }else{
            likeImage.image = UIImage(named: "Group 51")
        }
        if selectedProduct!.isInBag == true{
            addImage.image = UIImage(systemName: "bag.fill")
            
        }else{
            addImage.image = UIImage(systemName: "bag")
            
        }
    }
    
    func setupUi(){
        self.title = "\(selectedProduct!.name)"
        productImage.image = UIImage(named: selectedProduct!.imageName)
        headerLabel.text = "\(selectedProduct!.category)\n\(selectedProduct!.name)/\(selectedProduct!.color)"
        bottomLabel.text = "\(selectedProduct!.price) \(selectedProduct!.currency)"
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
        if selectedProduct?.isInBag != true{
            selectedProduct?.isInBag = true
            
            addImage.image = UIImage(systemName: "bag.fill")
            bagProducts.append(String(selectedItemNumber))
            Utils.saveLocal(array: bagProducts, key: "bagProducts")
            
        }else{
            selectedProduct?.isInBag = false
            
            addImage.image = UIImage(systemName: "bag")
            bagProducts = bagProducts.filter({$0 != "\(selectedItemNumber)" })
            Utils.saveLocal(array: bagProducts, key: "bagProducts")
            
        }
        
        
    }
    @objc func leftViewTapped() {
        if selectedProduct?.isFavorite != true{
            selectedProduct?.isFavorite = true
            favoriteProducts.append(String(selectedItemNumber))
            likeImage.image = UIImage(named: "Group 52")
            Utils.saveLocal(array: favoriteProducts, key: "favProducts")
            
            
        }else{
            favoriteProducts = favoriteProducts.filter({$0 != "\(selectedItemNumber)" })
            selectedProduct?.isFavorite = false
            likeImage.image = UIImage(named: "Group 51")
            Utils.saveLocal(array: favoriteProducts, key: "favProducts")
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
