//
//  LawnMovingVC.swift
//  Hoom
//
//  Created by Anish on 06/10/2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class LawnMovingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heading: UILabel!
    
    var companies = [Companies]()
    var currentCompanies = [Companies]()
    var serviceId = ""
    var companyId = ""
    var companyName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.heading.text = "\(companyName)\(" ")Companies"
        self.getReviews(companyId: serviceId)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
extension LawnMovingVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company  = currentCompanies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LawnMovieCell
        
        cell.setValues(value: company)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "quotation") as! QuotationVC
        vc.companyName = currentCompanies[indexPath.row].name
        vc.companyRate = currentCompanies[indexPath.row].price
        vc.companyId = currentCompanies[indexPath.row].id
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 243
    }
}

extension LawnMovingVC {
    
    func getReviews(companyId:String){
        let params = ["company_id":companyId]
        Alamofire.request(BASE_URL+"/hoom/public/api/get-review", method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                let result:JSON = JSON(response.result.value!)
                print("******* REVIEWS *********")
                print(result)
                self.parseRating(json: result)
            }else {
                print(response.result.error!.localizedDescription)
            }
        }
    }
    func parseRating(json:JSON){
        for item in json {
            let rating = item.1["average_rating"].string ?? "0"
            RATING = rating
        }
        self.getCompanies(serviceId: serviceId)
    }
    
    func getCompanies(serviceId:String){
        KRProgressHUD.show()
        let param = ["service_id":serviceId]
        Alamofire.request(BASE_URL+"/hoom/public/api/companies?service_id=\(serviceId)", method: .post, parameters: param,headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                print("*******COMPANIES LIST*******")
                let result:JSON = JSON(response.result.value!)
                print(result)
                self.parseCompanies(json: result)
            }else {
                print(response.result.error!.localizedDescription)
                KRProgressHUD.dismiss()
            }
        }
    }
    func parseCompanies(json:JSON) {
        for item in json {
            let id = item.1["id"].int ?? 0
            let serviceId = item.1["service_id"].int ?? 0
            let name = item.1["name"].string ?? ""
            let price = item.1["estimated_price"].string ?? ""
            
            let data = Companies(id: id, serviceId: serviceId, name: name, price: price)
            self.companies.append(data)
        }
        self.currentCompanies = self.companies
        self.tableView.reloadData()
        KRProgressHUD.dismiss()
    }
    
  
}
