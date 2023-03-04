//
//  CompanyReviewVC.swift
//  Hoom
//
//  Created by Anish on 07/10/2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class CompanyReviewVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heading : UILabel!
    var companyId = ""
    var companyName = ""
    var review = [Review]()
    var currentReview = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getReviews(companyId: companyId)
        self.heading.text = companyName.capitalized
    }
    

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitRating(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SubmitReviewVC")as! SubmitReviewVC
        vc.companyId = self.companyId
        vc.companyName = self.companyName
        self.present(vc, animated: true, completion: nil)
    }
    

}

extension CompanyReviewVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value = currentReview[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CompanyReviewCell
        cell.setValues(value: value)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}

extension CompanyReviewVC {
    func getReviews(companyId:String){
        KRProgressHUD.show()
        let params = ["company_id":companyId]
        Alamofire.request(BASE_URL+"/hoom/public/api/company-reviews", method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                let result:JSON = JSON(response.result.value!)
                print("******* REVIEWS *********")
                print(result)
                self.parseRating(json: result)
            }else {
                print(response.result.error!.localizedDescription)
                KRProgressHUD.dismiss()
            }
        }
    }
    func parseRating(json:JSON){
        for item in json {
            let name = item.1["name"].string ?? ""
            let userId = item.1["user_id"].int ?? 0
            let companyId = item.1["company_id"].int ?? 0
            let rating = item.1["rating"].int ?? 0
            let created_at = item.1["created_at"].string ?? ""
            
            let data = Review(name: name, userId: userId, companyId: companyId, rating: rating, createdAt: created_at)
            self.review.append(data)
        }
        self.currentReview = review
        self.tableView.reloadData()
        KRProgressHUD.dismiss()
    }
}
