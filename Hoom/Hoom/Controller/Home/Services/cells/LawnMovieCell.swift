//
//  LawnMovieCell.swift
//  Hoom
//
//  Created by Anish on 06/10/2020.
//

import UIKit

class LawnMovieCell: UITableViewCell {

    
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var price:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValues(value:Companies){
        self.name.text = value.name
        self.price.text = value.price
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
