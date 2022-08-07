//
//  BagViewController.swift
//  MomentupCase
//
//  Created by Hasan Onur Can on 8/6/22.
//

import UIKit
import AVFAudio
import Lottie
class BagViewController: UIViewController, AVAudioPlayerDelegate {
    var allProductsList : [Product] = []
    var bagProductList : [Product] = []
    var bagProductsNumbers : [String] = []
    var sumofFeeText = ""
    var bagProductCountText = ""
    var player : AVAudioPlayer?
    let animationView = AnimationView()
    
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var feeofAllProducts: UILabel!
    @IBOutlet weak var amountofProducts: UILabel!
    @IBOutlet weak var bagTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        for a in bagProductsNumbers{
            print(a)
            let product = allProductsList.filter({$0.name == a })
            print(product)
            bagProductList.append(product[0])
        }
        bagTableview.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        amountofProducts.text = ":  \(bagProductList.count)"
        feeofAllProducts.text = ":  \(calculatePrice(products: bagProductList))"
        sumofFeeText = ":  \(calculatePrice(products: bagProductList))"
        bagProductCountText = ":  \(bagProductList.count)"
        purchaseButton.layer.cornerRadius = purchaseButton.frame.height*0.5
        if bagProductList.count == 0{
            purchaseButton.isEnabled = false
            purchaseButton.backgroundColor = .lightGray
        }else{
            purchaseButton.isEnabled = true
            purchaseButton.backgroundColor = .systemGreen
        }
    }
    
    func setupUi(){
        self.title = "Bag"
        bagTableview.delegate = self
        bagTableview.dataSource = self
        bagTableview.separatorStyle = .none
    }
    
    func calculatePrice(products:[Product])->String{
        let sum0fFee = bagProductList.map({$0.price}).reduce(0, +)
        let roundedPrice = Double(round(1000 * sum0fFee) / 1000)
        return String(roundedPrice)
    }
    // MARK: - Buttons Func.
    
    @objc func removeButtonClicked(sender: UIButton?) {
        let tag = sender!.tag
        print(bagProductsNumbers)
        bagProductsNumbers = bagProductsNumbers.filter({$0 != bagProductList[tag].name })
        
        bagProductList = bagProductList.filter({$0.name != bagProductList[tag].name })
        
        feeofAllProducts.text = ":  \(calculatePrice(products: bagProductList))"
        sumofFeeText = ":  \(calculatePrice(products: bagProductList))"
        
        
        amountofProducts.text = ":  \(bagProductList.count)"
        print(bagProductsNumbers)
        Utils.saveLocal(array: bagProductsNumbers, key: "bagProducts")
        
        bagTableview.reloadData()
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        successAnimation()
        
        playMusic(name: "correctSound", type: "mp3")
        let destinationVC = self.storyboard?.instantiateViewController(identifier: "PurchaseViewController") as! PurchaseViewController
        destinationVC.feeText = sumofFeeText
        destinationVC.amounthText = bagProductCountText
        Utils.saveLocal(array: [], key: "bagProducts")
        Utils.saveLocal(array: [], key: "favProducts")
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
    }
    // MARK: - Animation Func.
    
    func successAnimation () {
        animationView.animation = Animation.named("download")
        animationView.frame = CGRect(x: 0, y: view.frame.height*0.03, width: view.frame.width, height: view.frame.height)
        animationView.loopMode = .playOnce
        self.animationView.isHidden = false
        
        animationView.play()
        
        view.addSubview(animationView)
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.animationView.isHidden = true
            
        }
        
    }
    // MARK: - Play Musics Functions
    
    
    public func playMusic (name:String,type:String){
        
        if let player = player, player.isPlaying{
            player.stop()
        }else{
            
            let urlString = Bundle.main.path(forResource: name, ofType: type)
            
            
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                guard let urlString = urlString else{
                    return
                }
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                player?.delegate = self
                
                guard let player = player else{
                    return
                }
                
                player.play()
            }
            catch{
                print("not work")
            }
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
extension BagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bagProductList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bagCell", for: indexPath) as! BagTableViewCell
        cell.imageProduct.image = UIImage(named: bagProductList[indexPath.row].imageName)
        cell.headerLabel.text = "\(bagProductList[indexPath.row].name)-\(bagProductList[indexPath.row].color) \(bagProductList[indexPath.row].category)"
        cell.descriptionLabel.text = "\(bagProductList[indexPath.row].price) \(bagProductList[indexPath.row].currency)"
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(removeButtonClicked), for: UIControl.Event.touchUpInside)
        cell.selectionStyle = .none;
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
}

