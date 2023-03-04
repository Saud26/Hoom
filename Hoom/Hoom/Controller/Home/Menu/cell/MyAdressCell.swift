//
//  MyAdressCell.swift
//  Hoom
//
//  Created by Anish on 07/10/2020.
//

import UIKit

class MyAdressCell: UITableViewCell {

    @IBOutlet weak var addressCount : UILabel!
    @IBOutlet weak var address : UILabel!
    @IBOutlet weak var postCode : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValues(value:MyAddress){
        self.address.text = value.address.capitalizingFirstLetter()
        self.postCode.text = value.postCode.capitalizingFirstLetter()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
