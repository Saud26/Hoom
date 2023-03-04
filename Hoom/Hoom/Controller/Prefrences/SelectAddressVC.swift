//
//  SelectAddressVC.swift
//  Hoom
//
//  Created by Anish on 08/10/2020.
//

import UIKit
import SwiftyMenu
import Alamofire
import SwiftyJSON

//MARK:- Delegate of address
protocol UserAddressDelegate {
    func userSelectAAddress(address:String,townId:String)
}

class SelectAddressVC: UIViewController {

    @IBOutlet weak var dropDownMenu: SwiftyMenu!
    @IBOutlet weak var houseNumber: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    
    var fromSingUp = false
    var selectedTown = ""
    var selectedTownId = ""
    var townId = [String]()
    
    var items: [SwiftyMenuDisplayable] = []
    let dropDownColor = UIColor(hexString: "#D9B99B")
    var addressDelegate : UserAddressDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dropDownMenu.isUserInteractionEnabled = true
        self.getTowns()
      
    }
    

    @IBAction func save(_ sender: Any) {
        if houseNumber.text == "" || street.text == "" || zipcode.text == "" || selectedTown == "" {
            simpleAlert("Enter your complete address")
        }else {
            if fromSingUp == true {
                let address = "\(selectedTown)\(",")\(houseNumber.text!)\(",")\(street.text!)\(",")\(zipcode.text!)"
                addressDelegate?.userSelectAAddress(address: address, townId: self.selectedTownId)
                self.dismiss(animated: true, completion: nil)
            }else {
            let address = "\(selectedTown)\(",")\(houseNumber.text!)\(",")\(street.text!)\(",")\(zipcode.text!)"
            addressDelegate?.userSelectAAddress(address: address, townId: self.selectedTownId)
            self.createAddress(address: houseNumber.text!, townId: self.selectedTownId, postCode: zipcode.text!)
            }
        }
        
    }
    

}
extension SelectAddressVC: SwiftyMenuDelegate {
    // Get selected option from SwiftyMenu
    func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
        print("Selected item: \(item), at index: \(index)")
        self.selectedTown = items[index] as! String
        self.selectedTownId = self.townId[index]
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
extension SelectAddressVC {
    func getTowns(){
        let url = "https://digitalech.com/hoom/public/api/towns"
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                print("*******TOWNS LIST*******")
                let result:JSON = JSON(response.result.value!)
                print(result)
                self.parseTown(json: result)
            }else {
                print(response.result.error!.localizedDescription)
            }
        }
    }
    func parseTown(json:JSON){
        for item in json {
            let name = item.1["name"].string ?? ""
            let townId = item.1["id"].int ?? 0
            self.townId.append("\(townId)")
            self.items.append(name)
        }
        dropDownMenu.isUserInteractionEnabled = true
        dropDownMenu.delegate = self
        dropDownMenu.items = items
        dropDownMenu.rowHeight = 50
        dropDownMenu.rowBackgroundColor = dropDownColor
        dropDownMenu.layer.cornerRadius = 10
        dropDownMenu.itemTextColor = .black
    }
    
    //MARK:- upload your address
    
    
    func createAddress(address:String,townId:String,postCode:String){
        let params = ["user_id":"\(USER_ID)","address":address,"town_id":townId,"postcode":postCode]
        Alamofire.request(BASE_URL+"/hoom/public/api/create-address", method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                print("******* CREATE MY ADDRESSES *******")
                let result:JSON = JSON(response.result.value!)
                print(result)
                self.parseAdress(json: result)
            }else {
                print(response.result.error!.localizedDescription)
            }
        }
    }
    
    func parseAdress(json:JSON){
        let addressId = json["id"].int ?? 0
        UserDefaults.standard.set("\(addressId)", forKey: "addressId")
        self.dismiss(animated: true, completion: nil)

    }
    /*
     ******* CREATE MY ADDRESSES *******
     {
       "postcode" : "TX 7890",
       "user_id" : "2",
       "town_id" : "2",
       "updated_at" : "2020-10-09T18:14:47.000000Z",
       "address" : "254",
       "id" : 3,
       "created_at" : "2020-10-09T18:14:47.000000Z"
     }
     */
}


// Example on String. You can change it to what ever type you want ;)
// String extension to conform SwiftyMenuDisplayable Protocl
extension String: SwiftyMenuDisplayable {
    public var retrievableValue: Any {
        return self
    }
    
    public var displayableValue: String {
        return self
    }
}
