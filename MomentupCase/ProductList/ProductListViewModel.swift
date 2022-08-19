//
//  ProductListViewModel.swift
//  MomentupCase
//
//  Created by Hasan onur Can on 18.08.2022.
//

import Foundation
import UIKit
import CoreAudio

class ProductListViewModel:ObservableObject{
    @Published var sortedProducts = Binder<[Product]> ()
    @Published var favoriteProducts : [String] = []
    @Published var bagProducts : [String] = []
    @Published var selectedProduct : Product?
    @Published var selectedItemNumber : Int = 0
    func saveChangesToLocal (){
        Utils.saveLocal(array: favoriteProducts, key: "favProducts")
        Utils.saveLocal(array: bagProducts, key: "bagProducts")
        print(Utils.readLocal(key:  "bagProducts"))
    }
    
    
    
    
    func addBag (index: Int){
        if sortedProducts.value![index].isInBag != true{
            sortedProducts.value![index].isInBag = true
            bagProducts.append(sortedProducts.value![index].name)
            
        }else{
            bagProducts = bagProducts.filter({$0 != "\(index)" })
            sortedProducts.value![index].isInBag = false
        }
    }
    
    func sortProducts (index:Int){
        if index != 0{
            sortedProducts.value = sortedProducts.value!.sorted(by: { $0.price < $1.price })
        }else{
            sortedProducts.value = sortedProducts.value!.shuffled()
        }
    }
    

    
    func addFavorite (index: Int){
        if sortedProducts.value![index].isFavorite != true{
            sortedProducts.value![index].isFavorite = true
            favoriteProducts.append(String(index))
//            productListCollectionView.reloadData()
            
        }else{
            favoriteProducts = favoriteProducts.filter({$0 != "\(index)" })
            sortedProducts.value![index].isFavorite = false
//            productListCollectionView.reloadData()
        }
    }
    
    func arrangeFavorite (){
        favoriteProducts = Utils.readLocal(key: "favProducts")
        for a in self.favoriteProducts{

            self.sortedProducts.value![Int(a)!].isFavorite = true
        }
    }
    func arrangeBag (){
        bagProducts = Utils.readLocal(key: "bagProducts")
      
        for b in self.bagProducts{
            if let row = self.sortedProducts.value!.firstIndex(where: {$0.name == b}) {
                self.sortedProducts.value![row].isInBag = true

            }
        }
    }
    func productService(){
        let service = Service(urlString: "https://www.momentup.co/challange/ProductsWithFilter.json")
        service.performRequest{(result: Result<Welcome,ServiceError>) in
            switch result {
            case .success(let products):
                DispatchQueue.main.async{
                    Utils.sortedProducts = products.products
                    self.sortedProducts.value = products.products
                    self.arrangeBag()
                    self.arrangeFavorite()
       
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // ProductDetail View Models
    
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

