//
//  BagViewModel.swift
//  MomentupCase
//
//  Created by Hasan onur Can on 19.08.2022.
//

import Foundation

class BagViewModel{
    var bagProductList : [Product] = []
    var sortedProducts = Utils.sortedProducts
    var bagProductsNumbers = Utils.readLocal(key: "bagProducts")
    var totalPrice = ""
    func arrangeArray(){
        print(bagProductsNumbers)
        for a in bagProductsNumbers{
            print(a)
            let product = sortedProducts!.filter({$0.name == a })
            print(product)
            bagProductList.append(product[0])
        }
        print(bagProductList)
    }
   
    func removeProduct(index:Int){
        bagProductsNumbers = bagProductsNumbers.filter({$0 != bagProductList[index].name })
        bagProductList = bagProductList.filter({$0.name != bagProductList[index].name })
        calculatePrice()
        Utils.saveLocal(array: bagProductsNumbers, key: "bagProducts")
    }
    
    func calculatePrice(){
        let sum0fFee = bagProductList.map({$0.price}).reduce(0, +)
        let roundedPrice = Double(round(1000 * sum0fFee) / 1000)
       totalPrice = String(roundedPrice)
        print(totalPrice)
    }
}
