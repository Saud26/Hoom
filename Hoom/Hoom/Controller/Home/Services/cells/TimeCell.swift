//
//  TimeCell.swift
//  Hoom
//
//  Created by Anish on 08/10/2020.
//

import UIKit

class TimeCell: UICollectionViewCell {
    @IBOutlet weak var selectedView : UIView!
    @IBOutlet weak var timeLbl : UILabel!
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                UIView.animate(withDuration: 0.3) { // for animation effect
                     self.backgroundColor = UIColor(hexString: "D9B89B")
                }
            }
            else {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    self.backgroundColor = UIColor.white
                }
            }
        }
    }
}
