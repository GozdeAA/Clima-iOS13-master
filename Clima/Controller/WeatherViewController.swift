//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import CoreLocation
import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet var searchController: UITextField!
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()

    @IBAction func searchPressed(_ sender: Any) {
        searchController.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        searchController.delegate = self // to access textfielddelegate
    }
  
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
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

extension WeatherViewController: UITextFieldDelegate {
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

// MARK: - location manager delegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways {
            locationManager.requestLocation()
        } else if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            // inform user
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var coordinate = locations.last?.coordinate
        getWeatherWithLocation(location: coordinate)
    }
    
    func getWeatherWithLocation(location: CLLocationCoordinate2D?){
        if let coor = location {
            print(coor)
            var url = weatherManager.getWeather(lat: String(coor.latitude), lon: String(coor.longitude))
            print(url)
            weatherManager.performRequest(urlString: url)
        }
    }
}

extension UIViewController {
    func showToast(message: String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width / 2 - 75, y: view.frame.size.height - 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
