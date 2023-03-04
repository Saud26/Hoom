//
//  SelectTownVC.swift
//  Hoom
//
//  Created by Anish on 05/10/2020.
//

import UIKit
import SwiftyMenu

class SelectTownVC: UIViewController {

    @IBOutlet weak var dropDownMenu: SwiftyMenu!
    let items: [SwiftyMenuDisplayable] = ["THE WOODLANDS", "SUGAR LAND", "KATY", "FRIENDSWOOD","CLEAR LAKE","PEAR LAND","LEAGUE CITY"]
    let dropDownColor = UIColor(hexString: "#D9B99B")
    override func viewDidLoad() {
        super.viewDidLoad()

        dropDownMenu.delegate = self
        dropDownMenu.items = items
        dropDownMenu.rowHeight = 50
        dropDownMenu.rowBackgroundColor = dropDownColor
        dropDownMenu.layer.cornerRadius = 10
        dropDownMenu.itemTextColor = .black
    }
    
}
extension SelectTownVC: SwiftyMenuDelegate {
    // Get selected option from SwiftyMenu
    func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
        print("Selected item: \(item), at index: \(index)")
        
    }
    
    // SwiftyMenu drop down menu will expand
    func swiftyMenu(willExpand swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu willExpand.")
    }

    // SwiftyMenu drop down menu did expand
    func swiftyMenu(didExpand swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu didExpand.")
    }

    // SwiftyMenu drop down menu will collapse
    func swiftyMenu(willCollapse swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu willCollapse.")
    }

    // SwiftyMenu drop down menu did collapse
    func swiftyMenu(didCollapse swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu didCollapse.")
    }
}

