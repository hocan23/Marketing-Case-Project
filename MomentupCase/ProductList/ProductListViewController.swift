//
//  ViewController.swift
//  MomentupCase
//
//  Created by Hasan Onur Can on 8/6/22.
//

import UIKit

class ProductListViewController: UIViewController {
    var products = [Product]()
    let insets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    let spacing = CGSize(width: 5, height: 15)
    var productList : [Product] = []
    var favoriteProducts : [String] = []
    var bagProducts : [String] = []
    var sortedProducts : [Product] = []
    @IBOutlet weak var productListCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteProducts = Utils.readLocal(key: "favProducts")
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        setupUi()
    }
    override func viewWillAppear(_ animated: Bool) {
        favoriteProducts = Utils.readLocal(key: "favProducts")
        bagProducts = Utils.readLocal(key: "bagProducts")
        productService()
        productListCollectionView.reloadData()
    }
    func setupUi(){
        self.title = "Product List"
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width:40, height: 40))
        addButton.setImage(UIImage(systemName: "bag"), for: .normal)
        addButton.addTarget(self, action: #selector(bagTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Utils.saveLocal(array: favoriteProducts, key: "favProducts")
        Utils.saveLocal(array: bagProducts, key: "bagProducts")
    }
    
    // MARK: - Buttons Func.

    @IBAction func sortValueChanged(_ sender: UISegmentedControl) {
        print(sender.tag)
        if sender.selectedSegmentIndex != 0{
            sortedProducts = sortedProducts.sorted(by: { $0.price < $1.price })
            productListCollectionView.reloadData()
        }else{
            sortedProducts = sortedProducts.shuffled()
            productListCollectionView.reloadData()
        }
    }
   
    @objc func bagTapped (){
        let destinationVC = self.storyboard?.instantiateViewController(identifier: "BagViewController") as! BagViewController
        destinationVC.allProductsList = sortedProducts
        print(bagProducts)
        destinationVC.bagProductsNumbers = bagProducts
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    @IBAction func showBagButtonTapped(_ sender: UIButton) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "BagViewController") as! BagViewController
        destinationVC.modalPresentationStyle = .fullScreen
        destinationVC.allProductsList = sortedProducts
        print(bagProducts)
        destinationVC.bagProductsNumbers = bagProducts
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    @objc func buttonClicked(sender: UIButton?) {
        let tag = sender!.tag
        if sortedProducts[tag].isFavorite != true{
            sortedProducts[tag].isFavorite = true
            favoriteProducts.append(String(tag))
            productListCollectionView.reloadData()
            
        }else{
            favoriteProducts = favoriteProducts.filter({$0 != "\(tag)" })
            sortedProducts[tag].isFavorite = false
            productListCollectionView.reloadData()
        }
    }
    
    @objc func addBagButtonClicked(sender: UIButton?) {
        let tag = sender!.tag
        print(tag)
        if sortedProducts[tag].isInBag != true{
            sortedProducts[tag].isInBag = true
            bagProducts.append(sortedProducts[tag].name)
            productListCollectionView.reloadData()
            
        }else{
            bagProducts = bagProducts.filter({$0 != "\(tag)" })
            sortedProducts[tag].isInBag = false
            productListCollectionView.reloadData()
        }
    }
    
    // MARK: - Service Prosesses

    func productService(){
        let service = Service(urlString: "https://www.momentup.co/challange/ProductsWithFilter.json")
        service.performRequest{(result: Result<Welcome,ServiceError>) in
            switch result {
            case .success(let products):
                print(products.products[0])
                DispatchQueue.main.async{
                    self.productList=products.products
                    for a in self.favoriteProducts{
                        
                        self.productList[Int(a)!].isFavorite = true
                    }
                    for b in self.bagProducts{
                        if let row = self.productList.firstIndex(where: {$0.name == b}) {
                            self.productList[row].isInBag = true
                            print(self.productList[row].isInBag)
                            
                        }
                    }
                    self.sortedProducts = self.productList
                    self.productListCollectionView!.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

// MARK: - CollectionView Design

extension ProductListViewController :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sortedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productListCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! CollectionViewCell
        cell.productImage.image = UIImage(named: sortedProducts[indexPath.row].imageName)
        cell.productDescription.text = "\(sortedProducts[indexPath.row].name)\n\(sortedProducts[indexPath.row].price) \(sortedProducts[indexPath.row].currency)"
       
        if sortedProducts[indexPath.row].isFavorite == true{
            cell.likeButton.setImage(UIImage(named: "Group 52"), for: .normal)
        }else{
            cell.likeButton.setImage(UIImage(named: "Group 51"), for: .normal)
            
        }
        if sortedProducts[indexPath.row].isInBag == true{
            cell.addBagButton.setImage(UIImage(systemName: "bag.fill"), for: .normal)
        }else{
            cell.addBagButton.setImage(UIImage(systemName: "bag"), for: .normal)
            
        }
        cell.likeButton.tag = indexPath.row
        cell.addBagButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        cell.addBagButton.addTarget(self, action: #selector(addBagButtonClicked), for: UIControl.Event.touchUpInside)
       
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = self.storyboard?.instantiateViewController(identifier: "ProductDetailViewController") as! ProductDetailViewController
       
        destinationVC.selectedProduct = sortedProducts[indexPath.row]
        destinationVC.favoriteProducts = favoriteProducts
        destinationVC.bagProducts = bagProducts
        destinationVC.selectedItemNumber = indexPath.row
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing.width
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            
            let numberOfVisibleCellHorizontal: CGFloat = 2
            let horizontalOtherValues = insets.right + insets.left + (spacing.width * numberOfVisibleCellHorizontal)
            let width = (collectionView.bounds.width - horizontalOtherValues) / numberOfVisibleCellHorizontal
            
            return CGSize(width: width, height: width*1.4)
            
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad  {
            
            let numberOfVisibleCellHorizontal: CGFloat = 3
            let horizontalOtherValues = insets.right + insets.left + (spacing.width * numberOfVisibleCellHorizontal)
            let width = (collectionView.bounds.width - horizontalOtherValues) / numberOfVisibleCellHorizontal
            
            return CGSize(width: width, height: width)
            
        }
        
        let numberOfVisibleCellHorizontal: CGFloat = 2
        let horizontalOtherValues = insets.right + insets.left + (spacing.width * numberOfVisibleCellHorizontal)
        let width = (collectionView.bounds.width - horizontalOtherValues) / numberOfVisibleCellHorizontal
        
        return CGSize(width: width, height: width)
        
    }
}
