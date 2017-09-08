//
//  changeCityViewController.swift
//  climate
//
//  Created by Vijay Adhikari on 08/09/2017.
//  Copyright © 2017 Vijay Adhikari. All rights reserved.
//

import UIKit


//create protocol 

protocol changeCityDelegate {
    func userEnteredNewCity(city: String)
}



class changeCityViewController: UIViewController {
    @IBOutlet weak var changeCityText: UITextField!

  
    var delegate : changeCityDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    
    
    
    
    @IBAction func getWeather(_ sender: UIButton) {
        
        let cityName = changeCityText.text
        
        delegate?.userEnteredNewCity(city: cityName!)
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
