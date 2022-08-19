//
//  ProductDetailViewModal.swift
//  MomentupCase
//
//  Created by Hasan onur Can on 18.08.2022.
//

import Foundation
import UIKit

class ProductDetailViewModel{
    func arrangeItems(selectedItem: Product, selectedItemNumber: Int) {
        self.selectedProduct = selectedItem
        self.selectedItemNumber = selectedItemNumber
    }
    
    var sortedProducts = Utils.sortedProducts
    var selectedProduct = ProductListViewModel().selectedProduct
    var favoriteProducts : [String] = []
    var selectedItemNumber : Int = 0
    var bagProducts : [String] = []
    
    
    func addTapped (addImage:UIImageView){
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
    func favoriteTapped (favoriteImage:UIImageView){
        if selectedProduct?.isFavorite != true{
            selectedProduct?.isFavorite = true
            favoriteProducts.append(String(selectedItemNumber))
            favoriteImage.image = UIImage(named: "Group 52")
            Utils.saveLocal(array: favoriteProducts, key: "favProducts")
            
            
        }else{
            favoriteProducts = favoriteProducts.filter({$0 != "\(selectedItemNumber)" })
            selectedProduct?.isFavorite = false
            favoriteImage.image = UIImage(named: "Group 51")
            Utils.saveLocal(array: favoriteProducts, key: "favProducts")
            
        }
    }
}
