//
//  MyOdersCell.swift
//  Hoom
//
//  Created by Anish on 14/10/2020.
//

import UIKit

class MyOdersCell: UITableViewCell {
    @IBOutlet weak var company : UILabel!
    @IBOutlet weak var price : UILabel!
    @IBOutlet weak var dateTime : UILabel!
    @IBOutlet weak var service : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValues(value:MyOrders){
        self.company.text = value.order_details 
        self.price.text = "\(value.order_total)"
        self.dateTime.text = value.order_date
        self.service.text = value.service_title
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
