//
//  CompanyServicesCell.swift
//  Hoom
//
//  Created by Anish on 15/10/2020.
//

import UIKit

class CompanyServicesCell: UITableViewCell {

    @IBOutlet weak var serviceName : UILabel!
    @IBOutlet weak var price : UILabel!
    @IBOutlet weak var checkUncheckBtn : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setsvalue(values:CompanyServices){
        self.serviceName.text = values.serviceDetail
        self.price.text = "\("$")\(values.price)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
