//
//  SubmitReviewVC.swift
//  Hoom
//
//  Created by Anish on 20/10/2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import FloatRatingView

class SubmitReviewVC: UIViewController ,FloatRatingViewDelegate{

    @IBOutlet weak var rating: FloatRatingView!
    
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var companyId = ""
    var companyName = ""
    var ratingValue = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blurView.alpha = 0.70
        rating.delegate = self
        self.name1.text = companyName
        self.name2.text = companyName
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        self.ratingValue = rating
    }

    @IBAction func send(_ sender: Any) {
        if self.ratingValue == 0.0 {
            simpleAlert("Please rate")
        }else {
            let intRating = Int(ratingValue)
            submitReview(comanyId: companyId, rating: "\(intRating)")
        }
    }
    
}

extension SubmitReviewVC {
    func submitReview(comanyId:String,rating:String){
        let params = ["company_id":comanyId,"user_id":USER_ID,"rating":rating]
        Alamofire.request(BASE_URL+"/hoom/public/api/review-create", method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess{
                let result:JSON = JSON(response.result.value!)
                print(result)
                self.simpleAlert("Review Submited")
                let alert = UIAlertController(title:APP_NAME, message: "Review Submited", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }else {
                print(response.result.error!.localizedDescription)
            }
        }
    }
}
