//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet var searchController: UITextField!
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    var weatherManager = WeatherManager()

    @IBAction func searchPressed(_ sender: Any) {
        searchController.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchController.delegate = self // to access textfielddelegate
    }
}

// MARK: - weather manager delegate

// instead of extending class with weather delegate we added class extension to use the delegate
extension WeatherViewController: WeatherManagerDelegate { // created weathermanagerdelagate in weathermanager file as protocol with methods (delegate)
    func didWeatherUpdate(weather: WeatherModel, _ weatherManager: WeatherManager) {
        DispatchQueue.main.async { // << Clousure -- this process might take a long time
            self.temperatureLabel.text = weather.tempatureString // added self due to its used in delegate
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }

    func didFailWithError(error: Error?) {
        print(error ?? "")
       // showToast(message: error?.localizedDescription ?? "an error occurred", font: .systemFont(ofSize: 16))
    }
}

extension WeatherViewController : UITextFieldDelegate{
    // cannot access this method without uitextfielddelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text ?? "")
        searchController.endEditing(true) // to close the keyboard
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchController.text { // if city is not empty
            var e = weatherManager.getWeather(cityName: city)
            weatherManager.performRequest(urlString: e)
        }
        searchController.text?.removeAll()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            return false
        } else {
            return true
        }
    }
}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
