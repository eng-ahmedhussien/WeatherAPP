

import UIKit

//Write the protocol declaration here:
protocol ChangeCityDelegate
{
    func userEnteredANewCityName(city: String)
}

class SecondViewController: UIViewController
{
    var delegate1 : ChangeCityDelegate?
   // var changeCity : ((String)->Void)?
    
    @IBOutlet weak var cityNmaetext: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    @IBAction func getWeatherButton(_ sender: Any)
    {
        let cityName = cityNmaetext .text!
        delegate1?.userEnteredANewCityName(city: cityName)
       // changeCity?(cityName)
        self.dismiss(animated: true, completion: nil)
    
        
    }

    @IBAction func backButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    


}
