
//  Created by Ahmed Hussien on 10/8/20.
//  Copyright © 2020 Ahmed Hussien. All rights reserved.
//

import UIKit
import CoreLocation // gps
import Alamofire  // using in netowrk requsts and communication
import SwiftyJSON
  

@available(iOS 13.0, *)
@available(iOS 13.0, *)
class ViewController: UIViewController,CLLocationManagerDelegate{

    var dataFromSeconViewController = ""
    
    //1- constants
    let weatherUrl = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "a57be975e1c48b8183fdfb28046619b5"
  
    
    //2- The object that you use to start and stop the delivery of location-related events to your app.
    let locationManger = CLLocationManager()
    let weatherModle  = WeatherModle()
    
    //3- lables and  buttons
    @IBOutlet weak var temperaturLable: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLable: UILabel!
    
    @available(iOS 13.0, *)
    @IBAction func gotoChangeCity(_ sender: Any){
        if let toEnterCityName = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController{
            //MARK: protocole
            toEnterCityName.delegate1 = self
            //MARK: clouser
           /* toEnterCityName.changeCity = {
                let parm : [String:String] = ["q":$0,"appid":self.APP_ID]
                self.getWeatherData(url:self.weatherUrl,parametar:parm )
            }*/
            present((toEnterCityName), animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad(){
        //4-
        super.viewDidLoad()
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //Requests the user’s permission to use location services while the app is in use.
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        // print("data\(dataFromSeconViewController)")
       /* let al = UIAlertController(title: "alert", message:dataFromSeconViewController, preferredStyle: .alert)
        present(al, animated: true, completion: nil)*/
 
    }
    
    
    //MARK: 5-func locationManager :: tells the delegate that new loaction data is available
    //locations ده عبارة عن اري بيخزن فيه تحديثات الموقع اخر قيمة في الاري هي اخر تحديث
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let location = locations[locations.count-1]

        if location.horizontalAccuracy > 0{
            locationManger.stopUpdatingLocation()
            locationManger.delegate = nil
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            print ("latitude =\(latitude), longitude = \(longitude)")
            let parame : [String:String] = ["lat":latitude,"lon":longitude ,"appid":APP_ID]
            getWeatherData(url:weatherUrl,parametar:parame )
        }
    }
    //Tells the delegate that the location manager was unable to retrieve a location value.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("error")
        cityLable.text = "cannot find  your loaction "
    }
    
    //MARK: 6- netowrking
    //
    func getWeatherData(url:String,parametar:[String:String]){

      /*  //http recquest (if)
        Alamofire.request(url, method: .get, parameters:parametar).responseJSON{
            response in
            if response.result.isSuccess{
                print("success connection ")
                let weatherJOSN : JSON = JSON(response.result.value!)
                // print(weatherJOSN)
                self.updateWeatherData(josn:weatherJOSN)

            }
            else{
                print("error \(String(describing:response.result.error))")
                self.cityLable.text = ("connection error")
            }
        }*/
        
        //http recquest (switch)
        Alamofire.request(url, method: .get, parameters:parametar).responseJSON{
            response in
            switch response.result{
            case .success(_):
                print("success connection ")
                let weatherJOSN : JSON = JSON(response.result.value!)
                // print(weatherJOSN)
                self.updateWeatherData(josn:weatherJOSN)
            case .failure(_):
                print("error \(String(describing:response.result.error))")
                self.cityLable.text = ("connection error")
            }
        }
    }
    
    //MARK: 7-  JOSN parsing
    func updateWeatherData(josn:JSON){
        //u  بستخدم if علشان لو في مشكلة في البيانات الي راجعة اعرف
      /*  if let temperature = josn["main"]["temp"].double{
            weatherModle.temperature = Int(temperature - 273.15) // == weatherModle.temperature = Int(josn["main"]["temp"].double! - 273.15)
            weatherModle.condition = (josn["weather"][0]["id"]).intValue
            weatherModle.city = (josn["name"]).stringValue
            let  condition = (josn["weather"][0]["id"]).intValue
            weatherModle.weatherIconName = updateWeatherIcon(cond: condition)
            updateUI()
        }
        else{
            cityLable.text = "weather unavilable  "
        }*/
        
        guard let temperature = josn["main"]["temp"].double
        else {
            cityLable.text = "weather unavilable"
            return
        }
            weatherModle.temperature = Int(temperature - 273.15) // == weatherModle.temperature = Int(josn["main"]["temp"].double! - 273.15)
            weatherModle.condition = (josn["weather"][0]["id"]).intValue
            weatherModle.city = (josn["name"]).stringValue
            let  condition = (josn["weather"][0]["id"]).intValue
            weatherModle.weatherIconName = updateWeatherIcon(cond: condition)
            updateUI()
    }
    
    //-9
    func updateUI()
    {
        cityLable.text = weatherModle.city
        temperaturLable.text = String(weatherModle.temperature)+"℃";      weatherIcon.image = UIImage(named: weatherModle.weatherIconName)
    }
    
    //8-
    func updateWeatherIcon(cond: Int) -> String
    {
        
    switch (cond) {
    
        case 0...300 :
            return "tstorm1"
        
        case 301...500 :
            return "light_rain"
        
        case 501...600 :
            return "shower3"
        
        case 601...700 :
            return "snow4"
        
        case 701...771 :
            return "fog"
        
        case 772...799 :
            return "tstorm3"
        
        case 800 :
            return "sunny"
        
        case 801...804 :
            return "cloudy2"
        
        case 900...903, 905...1000  :
            return "tstorm3"
        
        case 903 :
            return "snow5"
        
        case 904 :
            return "sunny"
        
        default :
            return "dunno"
        }
    }
}
@available(iOS 13.0, *)
extension ViewController:ChangeCityDelegate{
    func userEnteredANewCityName(city:String)
    {
        let parm : [String:String] = ["q":city,"appid":APP_ID]
        getWeatherData(url:weatherUrl,parametar:parm )
    }
}

