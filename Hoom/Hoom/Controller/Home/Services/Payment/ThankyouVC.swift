//
//  ThankyouVC.swift
//  Hoom
//
//  Created by Anish on 08/10/2020.
//

import UIKit

class ThankyouVC: UIViewController {

    @IBOutlet weak var blur: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.blur.alpha = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            let vc = self.storyboard?.instantiateViewController(identifier: "home")
            self.present(vc!, animated: true, completion: nil)
              })
    }

}
