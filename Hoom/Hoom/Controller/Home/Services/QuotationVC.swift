//
//  QuotationVC.swift
//  Hoom
//
//  Created by Anish on 06/10/2020.
//

import UIKit
import BonsaiController
import Alamofire
import SwiftyJSON
import KRProgressHUD
import FloatRatingView

class QuotationVC: UIViewController,MyAddressDelegate,SelectDateDelegate {
  
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var rating: FloatRatingView!
    
    @IBOutlet weak var timeDateBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderDetailText: UITextView!
    
    var companyId = 0
    var companyName = ""
    var companyRate = ""
    var isBoxClicked: Bool!
    var checkImage = UIImage(named: "check")
    var uncheckImage = UIImage(named: "uncheck")
    var selectedServiceArray = [Int]()
    var selectedServiceIds = [Int]()
    var selectedServicePrice = [Int]()
    var services = [CompanyServices]()
    var currentServices = [CompanyServices]()
    var myProfileAdress = ""
    var quotationAddress = ""
    var quotationDateAndTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.name.text = self.companyName
        self.price.text = self.companyRate
        self.getServices(companyId: "\(companyId)")
        self.tableView.tableFooterView = UIView()
        
        if let addressId = UserDefaults.standard.object(forKey: "addressId"){
            self.myProfileAdress = addressId as! String
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.rating.rating = Double(RATING)!
    }
    //DELEGATE METHOD FOR MY ADDRESS
    func mySelectedAddress(address: String, townId: String, adressId: String) {
        self.addBtn.setTitle(address, for: .normal)
        self.quotationAddress = adressId
    }
   
    //DELEGATE METHOD FOR MY DATE
    func dateAndtime(date: String, time: String) {
        self.timeDateBtn.setTitle("\(date)\(",")\(time)", for: .normal)
        self.quotationDateAndTime = "\(date)\(",")\(time)"
    }
    
    @IBAction func viewRating(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CompanyReviewVC") as! CompanyReviewVC
        vc.companyId = "\(companyId)"
        vc.companyName = self.companyName
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func orderNow(_ sender: Any) {
        let regularCost = Int(price.text!)
        let priceArraySum = selectedServicePrice.sum()
        let finalPrice = regularCost! + priceArraySum
        let stringArray = selectedServiceIds.map{(String($0)) }
        //current date and time of order
        let currentDateTime = Date()
        let formatter = DateFormatter()
       // formatter.dateFormat = "MM-dd-yyyy,HH:mm"
        formatter.dateFormat = "yyyy-MM-dd,HH:mm"
       // formatter.timeStyle = .short
        
       // formatter.dateStyle = .short
        let myDate = formatter.string(from: currentDateTime)
        
        self.createOrder(orderDetail: self.companyName, address: self.myProfileAdress, date: myDate, total: "\(finalPrice)", services: stringArray)
    }
    
    @IBAction func selectDateAndTime(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SelectDateVC") as! SelectDateVC
        vc.dateDelegate = self
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func selectAddress(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "address") as! MyAdressVC
        
        vc.mySelectedAddressDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func requestYourQuotation(_ sender: Any) {
        if quotationAddress == "" || quotationDateAndTime == "" || orderDetailText.text == "" {
            simpleAlert("PLease fill all required fields")
        }else {
            // ADDRESS -> ID
            // SERVICES -> ID
           
            let regularCost = Int(price.text!)
            let priceArraySum = selectedServicePrice.sum()
            let finalPrice = regularCost! + priceArraySum
            let stringArray = selectedServiceIds.map{(String($0)) }
            self.sendQuotation(orderDetail: orderDetailText.text, address: quotationAddress, date: quotationDateAndTime, total: "\(finalPrice)", services: stringArray)
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension QuotationVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value = currentServices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CompanyServicesCell
        cell.setsvalue(values: value)
        cell.checkUncheckBtn.tag = indexPath.row
       
        if selectedServiceArray.contains(indexPath.row){
            cell.checkUncheckBtn.setImage(checkImage, for: .normal)
        }else{
            cell.checkUncheckBtn.setImage(uncheckImage, for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // save services id and price in array
        if let cell = tableView.cellForRow(at: indexPath) as? CompanyServicesCell
        {
            if selectedServiceArray.isEmpty{
                self.selectedServiceArray = [Int]()
                self.selectedServiceIds = [Int]()
                self.selectedServicePrice = [Int]()
            }
            if selectedServiceArray.contains(indexPath.row){
                if let indexElement = selectedServiceArray.firstIndex(of: indexPath.row){
                    cell.checkUncheckBtn.setImage(uncheckImage, for: .normal)
                    selectedServiceArray.remove(at: indexElement)
                    selectedServicePrice.remove(at: indexElement)
                    selectedServiceIds.remove(at: indexElement)
                }
            }else{
                cell.checkUncheckBtn.setImage(checkImage, for: .normal)
                selectedServiceArray.append(indexPath.row)
                self.selectedServicePrice.append(currentServices[indexPath.row].price)
                self.selectedServiceIds.append(currentServices[indexPath.row].id)
            }
        }
    }
   
    
    
}
extension QuotationVC {
    
    func createOrder(orderDetail:String,address:String,date:String,total:String,services:[String]){
        KRProgressHUD.show()
        let params : [String:Any] = ["order_details":orderDetail,"user_id":USER_ID,"order_address":address,"order_date":date,"order_status":" paid","order_total":total,"services": services]
       
        Alamofire.request("https://digitalech.com/hoom/public/api/orders", method: .post,parameters: params ,encoding:JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                let result:JSON = JSON(response.result.value!)
                print("********* Order Create *********")
                print(result)
                self.simpleAlert("Order Created")
               
                KRProgressHUD.dismiss()
            }else {
                print(response.result.error!.localizedDescription)
                KRProgressHUD.dismiss()
            }
        }
    }
    
    func getServices(companyId:String){
        KRProgressHUD.show()
        let params = ["company_id":companyId]
        Alamofire.request(BASE_URL+"/hoom/public/api/get-service", method: .post,parameters: params ,encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                let result:JSON = JSON(response.result.value!)
                print("********* COMPANY SERVICES *********")
                print(result)
                self.parseServices(json: result)
            }else {
                print(response.result.error!.localizedDescription)
                KRProgressHUD.dismiss()
            }
        }
    }
    func parseServices(json:JSON){
        for item in json {
            let id = item.1["id"].int ?? 0
            let status = item.1["status"].string ?? ""
            let price = item.1["price"].int ?? 0
            let companyId = item.1["company_id"].int ?? 0
            let serviceDetail = item.1["service_detail"].string ?? ""
            let data = CompanyServices(id: id, status: status, price: price, companyId: companyId, serviceDetail: serviceDetail)
            self.services.append(data)
        }
        self.currentServices = services
        self.tableView.reloadData()
        KRProgressHUD.dismiss()
    }
    
    func sendQuotation(orderDetail:String,address:String,date:String,total:String,services:[String]){
        KRProgressHUD.show()
        let params : [String:Any] = ["order_details":orderDetail,"user_id":USER_ID,"order_address":address,"order_date":date,"order_status":" quotation","order_total":total,"services": services]
        print(TOKEN)
        Alamofire.request("https://digitalech.com/hoom/public/api/quotation", method: .post,parameters: params ,encoding:JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                let result:JSON = JSON(response.result.value!)
                print("********* Quotation send *********")
                print(result)
                self.simpleAlert("Quotation Sent")
                self.orderDetailText.text = ""
                KRProgressHUD.dismiss()
            }else {
                print(response.result.error!.localizedDescription)
                KRProgressHUD.dismiss()
            }
        }
    }
    /*
     ********* Quotation send *********
     [
       {
         "order_address" : "3",
         "updated_at" : "2020-10-22T17:16:24.000000Z",
         "order_total" : "50",
         "user_id" : "2",
         "order_status" : "quotation",
         "order_date" : "2020-10-22,13:00",
         "id" : 4,
         "created_at" : "2020-10-22T17:16:24.000000Z",
         "order_details" : "ASasaSa"
       },
       {
         "service_id" : "3",
         "updated_at" : "2020-10-22T17:16:24.000000Z",
         "order_id" : 4,
         "service_title" : "Full Service",
         "id" : 1,
         "created_at" : "2020-10-22T17:16:24.000000Z",
         "estimated_price" : 10
       }
     ]
     */
}

extension QuotationVC: BonsaiControllerDelegate {
    
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 4), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (4/3)))
    }
    
    // return a Bonsai Controller with SlideIn or Bubble transition animator
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        // Slide animation from .left, .right, .top, .bottom
        return BonsaiController(fromDirection: .bottom, blurEffectStyle:.extraLight, presentedViewController: presented, delegate: self)
        
        // or Bubble animation initiated from a view
        //return BonsaiController(fromView: yourOriginView, blurEffectStyle: .dark,  presentedViewController: presented, delegate: self)
        
    }
}

