//
//  ViewController.swift
//  MomentupCase
//
//  Created by Hasan Onur Can on 8/6/22.
//

import UIKit
import SwiftUI


class ProductListViewController: UIViewController {
    
    let insets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    let spacing = CGSize(width: 5, height: 15)
    var viewModel = ProductListViewModel()
    
    @IBOutlet weak var productListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.productService()
        setupUi()
        startApp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.arrangeBag()
        viewModel.arrangeFavorite()
        productListCollectionView.reloadData()
    }
    
    func startApp (){
        viewModel.sortedProducts.bind(observer: { products in
            
            self.productListCollectionView.reloadData()
            
        })
    }
    
    func setupUi(){
        self.title = "Product List"
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width:40, height: 40))
        addButton.setImage(UIImage(systemName: "bag"), for: .normal)
        addButton.addTarget(self, action: #selector(bagTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(viewModel.favoriteProducts)
        print(viewModel.bagProducts)
        
        viewModel.saveChangesToLocal()
    }
    
    // MARK: - Buttons Func.
    
    @IBAction func sortValueChanged(_ sender: UISegmentedControl) {
        viewModel.sortProducts(index: sender.selectedSegmentIndex)
        productListCollectionView.reloadData()
    }
    
    @objc func bagTapped (){
        let destinationVC = self.storyboard?.instantiateViewController(identifier: "BagViewController") as! BagViewController
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    @IBAction func showBagButtonTapped(_ sender: UIButton) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "BagViewController") as! BagViewController
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    @objc func buttonClicked(sender: UIButton?) {
        let tag = sender!.tag
        viewModel.addFavorite(index: tag)
        productListCollectionView.reloadData()
    }
    
    @objc func addBagButtonClicked(sender: UIButton?) {
        let tag = sender!.tag
        viewModel.addBag(index: tag)
        productListCollectionView.reloadData()
        
    }
}

extension ProductListViewController :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.sortedProducts.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productListCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! CollectionViewCell
        
        cell.productImage.image = UIImage(named: viewModel.sortedProducts.value![indexPath.row].imageName)
        cell.productDescription.text = "\(viewModel.sortedProducts.value![indexPath.row].name)\n\(viewModel.sortedProducts.value![indexPath.row].price) \(viewModel.sortedProducts.value![indexPath.row].currency)"
        
        if viewModel.sortedProducts.value![indexPath.row].isFavorite == true{
            cell.likeButton.setImage(UIImage(named: "Group 52"), for: .normal)
        }else{
            cell.likeButton.setImage(UIImage(named: "Group 51"), for: .normal)
            
        }
        if viewModel.sortedProducts.value![indexPath.row].isInBag == true{
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
        print(viewModel.sortedProducts.value![indexPath.row])
        viewModel.selectedProduct = viewModel.sortedProducts.value![indexPath.row]
        viewModel.selectedItemNumber = indexPath.row
        
        let destinationVC = self.storyboard?.instantiateViewController(identifier: "ProductDetailViewController") as! ProductDetailViewController
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
