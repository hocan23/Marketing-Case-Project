//
//  PurchaseViewController.swift
//  MomentupCase
//
//  Created by Hasan Onur Can on 8/7/22.
//

import UIKit

class PurchaseViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    var feeText : String?
    var amounthText : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        // Do any additional setup after loading the view.
    }
    func setupUi(){
        self.title = "Order Confirmation"
        feeLabel.text = feeText
        amountLabel.text = amounthText
        self.navigationItem.setHidesBackButton(true, animated: true)
        closeButton.layer.cornerRadius = closeButton.frame.height*0.5
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        let destinationVC = self.storyboard?.instantiateViewController(identifier: "ProductListViewController") as! ProductListViewController
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
