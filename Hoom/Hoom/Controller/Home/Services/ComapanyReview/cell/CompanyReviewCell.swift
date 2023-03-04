//
//  CompanyReviewCell.swift
//  Hoom
//
//  Created by Anish on 07/10/2020.
//

import UIKit
import FloatRatingView

class CompanyReviewCell: UITableViewCell {
    @IBOutlet weak var ratingView : FloatRatingView!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var date : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValues(value:Review){
        self.name.text = value.name
        let dateString = value.createdAt.components(separatedBy: "T")
        self.date.text = dateString[0]
        ratingView.rating = Double(value.rating)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
