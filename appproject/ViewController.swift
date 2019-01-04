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

class ViewController: UIViewController {
    
    @IBOutlet var imageClothes: UIImageView!
    
    @IBAction func buttonKakao(_ sender: Any) {
        // Location 타입 템플릿 오브젝트 생성
        let tempaler = KMTFeedTemplate { (templaterBuilder) in
            templaterBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "18도"
                contentBuilder.desc = "오늘의 날씨는 코트 입기 좋은 날입니다."
                contentBuilder.imageURL = URL(string: "https://images.unsplash.com/photo-1491998664548-0063bef7856c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80")!
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
        getWeather()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func settingImage(){
        imageClothes.layer.masksToBounds = true
        imageClothes.layer.cornerRadius = imageClothes.frame.width / 2
    }
    func getWeather(){
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?q=seoul&appid=acfacf92c83936ab9c235b7ea1e89a4e"
        
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
                var tempature = array["temp"] ?? 0
                let tempature = tempature as? Double
                tempature -= 273.15
                
            }
            
        }
        
        dataTask.resume()
    }

}


