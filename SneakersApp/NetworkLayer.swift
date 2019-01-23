//
//  NetworkLayer.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-19.
//  Copyright © 2018 Rafae. All rights reserved.
//

import Foundation

class NetworkLayer {
    
    static let shared = NetworkLayer()
    let imageUrl = "https://sneakers-bucket.s3.us-east-2.amazonaws.com/jordan1chi_side_image3.jpg"
    
    let cSneakers = [CodableSneaker]()
    let baseURL = "https://yawndry-heroku.herokuapp.com/sneakers"
    
    
    func postSneaker(sneaker: Sneaker) -> Void{
        
        guard let url = URL(string: "https://yawndry-heroku.herokuapp.com/sneakers") else {return}
        guard let localhostUrl = URL(string: "http://localhost:3000/sneakers") else {return}
        
        var sneakerData = CodableSneaker()
        sneakerData.name = sneaker.name
        sneakerData.imageUrls = sneaker.imageUrls
        sneakerData.condition = sneaker.condition
        sneakerData.price = sneaker.price
        sneakerData.year = sneaker.year
        sneakerData.size = sneaker.size
        sneakerData.image_url = sneaker.image_url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(sneakerData)
        
        
        print("This is the jsonData ", jsonData)
        print("\(sneakerData.imageUrls)")
        
        let stringData = String(data: jsonData, encoding: .utf8)
        
        request.httpBody = jsonData
        
        print("this is what your jsonData looks like in a string format", stringData)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "could not make a connection to the /sneakers endpoint")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String  : Any] {
                print("Success! Made conection to localhost:3000")
                print(responseJSON)
            }
        }
        task.resume()
        
        
    }
    
    func fetchSneakers(completionHandler: @escaping([CodableSneaker]) -> ()) {
        
        guard let url = URL(string: "https://yawndry-heroku.herokuapp.com/sneakers") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let decoder = JSONDecoder()
            
            guard let returnedData = data else {return}
           
//            guard let jsonData = try? decoder.decode([CodableSneaker].self, from: returnedData) else {
//                print("Couldnt parse the json sneakers")
//                return
//
//            }
            
            guard let jsonData = try? decoder.decode([CodableSneaker].self, from: returnedData) else {
                print("Couldnt parse the json sneakers")
                return
            }
            
            completionHandler(jsonData)
            
//            print(jsonData)
        }
        task.resume()
    }
    
    //Return an array of CodableSneakerImages
    //Easier to parse makes your life hella easier
    func fetchSneakerImages(sneakerId: Int, completionHandler: @escaping([CodableSneakerImage]) ->()) {
        
        let sID = String(sneakerId)
        
        
        let imageUrl = "https://yawndry-heroku.herokuapp.com/sneakers/\(sID)/images"
        
        guard let url = URL(string: imageUrl) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let decoder = JSONDecoder()
            guard let returnedData = data else {return print("The sneaker image data parsed incorrectly")}
            
            

            if let imageJsonData = try? decoder.decode([CodableSneakerImage].self, from: returnedData) {
                
                
                completionHandler(imageJsonData)
                
                return
            }
            
            guard let error = error else {return}
            print("Error: \(error)")
            
            
            
        }
        task.resume()
    }
    
    func searchSneakers(searchText: String, completionHandler: @escaping([CodableSneaker]?) -> ()) {
        
        let data : [String: String]
        data = ["name" : searchText]
        
        let parameters = ["name" : searchText]
        
        
        let stringUrl = "https://yawndry-heroku.herokuapp.com/sneakers/\(searchText)"
        
        print(stringUrl)
        
        guard let percentEncodedString = stringUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {return}
        
        guard let url = URL(string: percentEncodedString) else {return}
        
    
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let sneakersData = data else {
                print("Could not make the connection to the url") 
                print(error?.localizedDescription)
                return}
            
            let decoder = JSONDecoder()
            if let jsonData = try? decoder.decode([CodableSneaker].self, from: sneakersData) {
//                print("Could not parse the sneakers")
            
                completionHandler(jsonData)


                return
            }
            
            guard let error = error else {return}
            print(error)

        }
        task.resume()
        

        
        
    }
}
