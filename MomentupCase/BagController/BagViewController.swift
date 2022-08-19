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
    
    var player : AVAudioPlayer?
    let animationView = AnimationView()
    let viewModel = BagViewModel()
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var feeofAllProducts: UILabel!
    @IBOutlet weak var amountofProducts: UILabel!
    @IBOutlet weak var bagTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        viewModel.arrangeArray()
        viewModel.calculatePrice()
        
        bagTableview.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        amountofProducts.text = ":  \(viewModel.bagProductList.count)"
        feeofAllProducts.text = ":  \(viewModel.totalPrice)"
        
        purchaseButton.layer.cornerRadius = purchaseButton.frame.height*0.5
        if viewModel.bagProductList.count == 0{
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
    
    
    // MARK: - Buttons Func.
    
    @objc func removeButtonClicked(sender: UIButton?) {
        
        viewModel.removeProduct(index: sender!.tag)
        
        amountofProducts.text = ":  \(viewModel.bagProductList.count)"
        feeofAllProducts.text = ":  \(viewModel.totalPrice)"
        bagTableview.reloadData()
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        successAnimation()
        
        playMusic(name: "correctSound", type: "mp3")
        let destinationVC = self.storyboard?.instantiateViewController(identifier: "PurchaseViewController") as! PurchaseViewController
        
        Utils.saveLocal(array: [], key: "bagProducts")
        Utils.saveLocal(array: [], key: "favProducts")
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [self] in
            destinationVC.feeText = viewModel.totalPrice
            destinationVC.amounthText = String(viewModel.bagProductList.count)
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
    
}
extension BagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bagProductList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bagCell", for: indexPath) as! BagTableViewCell
        cell.imageProduct.image = UIImage(named: viewModel.bagProductList[indexPath.row].imageName)
        cell.headerLabel.text = "\(viewModel.bagProductList[indexPath.row].name)-\(viewModel.bagProductList[indexPath.row].color) \(viewModel.bagProductList[indexPath.row].category)"
        cell.descriptionLabel.text = "\(viewModel.bagProductList[indexPath.row].price) \(viewModel.bagProductList[indexPath.row].currency)"
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

