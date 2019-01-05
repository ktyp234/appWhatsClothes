//
//  ViewController.swift
//  appproject
//
//  Created by 김지훈 on 04/01/2019.
//  Copyright © 2019 KimJihun. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import KakaoMessageTemplate
import CoreLocation

class ViewController: UIViewController{

    var locationManager : CLLocationManager!
    var lat : Double!
    var lot : Double!
    var descString : String!
    var titleString : String!
    var imageArray: [String] = [""]
    @IBOutlet var centerLabel: UILabel!
    
    @IBOutlet var temperatureLabel: UILabel!
    
    @IBOutlet var imageClothes: UIImageView!
    
    @IBAction func buttonKakao(_ sender: Any) {
        // Location 타입 템플릿 오브젝트 생성
        let tempaler = KMTFeedTemplate { (templaterBuilder) in
            templaterBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = self.titleString
                contentBuilder.desc = self.descString
                contentBuilder.imageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/clothes-55f79.appspot.com/o/photo-1541441181252-17e403fbbf5b.jpeg?alt=media&token=00f990cf-8ca4-47b7-9ce5-cbaced44ff48")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            })
        }
        
    
        // 서버에서 콜백으로 받을 정보
        let serverCallbackArgs = ["user_id": "abcd",
                                  "product_id": "1234"]
        
        // 카카오링크 실행
        KLKTalkLinkCenter.shared().sendDefault(with: tempaler, serverCallbackArgs: serverCallbackArgs, success: { (warningMsg, argumentMsg) in
            
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")
            
        }, failure: { (error) in
            
            // 실패
            
            print("error \(error)")
            
        })
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        settingImage()
        locationSetting()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func locationSetting(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    func settingImage(){
        imageClothes.layer.masksToBounds = true
        imageClothes.layer.cornerRadius = imageClothes.frame.width / 2
    }
    func checkTempature(temperature:Double) -> String {
        switch temperature {
        case _ where temperature < 5:
            return "오늘의 날씨는 야상, 패딩, 목도리 착용을 해야합니다."
        case _ where temperature < 5:
            return "오늘의 날씨는 야상, 패딩, 목도리 착용을 해야합니다."
        default:
            return ""
        }
        
        
    }
    func getWeather(){
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat!)&lon=\(lot!)&appid=acfacf92c83936ab9c235b7ea1e89a4e"
        
        let defaultSession = URLSession(configuration: .default)
        
        guard let url = URL(string: weatherURL) else {
            print("url is nil")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        
        
        
        let dataTask = defaultSession.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print(error)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                print(data,"D")
                guard let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] else {
                    print("json to any error")
                    return
                }
                let array = jsonArray["main"]! as! [String:Any]
                
                print(array["temp"] ?? 0)
                var tempature = array["temp"] as! Double
                tempature -= 273.15
                print(tempature)
                DispatchQueue.main.async {
                    self.temperatureLabel.text = "\(Int(tempature))도"
                    self.titleString = "\(Int(tempature))도"
                    self.centerLabel.text = self.checkTempature(temperature: tempature)
                    self.centerLabel.adjustsFontSizeToFitWidth = true
                    self.descString = self.checkTempature(temperature: tempature)
                }
            }
            
        }
        
        dataTask.resume()
    }

}



extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate{
            print("lat" + String(coor.latitude) + "lot" + String(coor.longitude))
            lat = coor.latitude
            print(lat)
            lot = coor.longitude
            getWeather()
        }
    }
}
