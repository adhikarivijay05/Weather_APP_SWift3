//
//  ViewController.swift
//  climate
//
//  Created by Vijay Adhikari on 07/09/2017.
//  Copyright © 2017 Vijay Adhikari. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController , CLLocationManagerDelegate, changeCityDelegate{
    let WEATHER_URL  = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "a5f11e637e62072c7a4cae0745d00c16"
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    

    
    //Declare variables
    let locationManager = CLLocationManager()
    
    let weatherDataModel = WeatherDataModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Networking
    func getWeatherData(url: String, parameter : [String : String])  {
        
        
        Alamofire.request(url, method: .get, parameters: parameter).responseJSON { (response) in
            
            if response.result.isSuccess {
                print("success")
                
                let weatherJSON : JSON = JSON(response.result.value)
                print(weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
            }
            else{
                print("error")
            }
        }
    }
    
    
    //MARK: - JSON PARSING
    
    
    func updateWeatherData(json : JSON)  {
        
        if let tempResult = json["main"]["temp"].double {
            
            weatherDataModel.temperature = Int(tempResult - 273.15)
            
            weatherDataModel.city = json["name"].stringValue
            
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            
            updateUIWithWeatherData()
            
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
        //MARK- update UI
        
        
    func updateUIWithWeatherData(){
        
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
    }
    
        //MARK - location Manager Delegates
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let location = locations[locations.count - 1]
            
            if location.horizontalAccuracy > 0 {
                locationManager.stopUpdatingLocation()
                print("longitute ... \(location.coordinate.longitude) and latitude ..\(location.coordinate.latitude)")
                
                
                let lat = String(location.coordinate.latitude)
                let lon = String(location.coordinate.longitude)
                
                
                let params : [String : String] = ["lat" : lat, "lon" : lon, "appid" : APP_ID]
                
                getWeatherData(url: WEATHER_URL, parameter: params)
                
            }
            
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
            cityLabel.text = "Location unavailable"
        }
        
        
        
        //MARK:  Change City
    
    
    func userEnteredNewCity(city: String) {
        print("city...",city)
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameter: params)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityViewController" {
            
            let destination = segue.destination as! changeCityViewController
            destination.delegate = self
            
        }
    }
}


