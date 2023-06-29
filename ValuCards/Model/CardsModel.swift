//
//  ValuCardsService.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import Foundation
import Alamofire

class CardsModel {
    // MARK: - Singleton pattern
    static let shared = CardsModel()
    
    private let apiKey = "v^1.1#i^1#f^0#I^3#r^0#p^1#t^H4sIAAAAAAAAAOVYe2wURRjv9UWaAgYEBcTkWI2x1N2b3bvb3q29I9cWwkHpgyuFItLM7s5el+7tXndnac+IXCAiDzUKiQkqSkKiYkyE8BcYNSBixCgJYuRhogSM4gNDIFI1gnN7R7lWAoVeYhPvn8vOfN833+8332NmQLq8Yua6uesuj3ONKd6eBulil4utBBXlZdXjS4qnlRWBPAHX9vSD6dI1JT/WWjChJYWFyEoauoXcfQlNtwRnMETZpi4Y0FItQYcJZAlYEmKRBY0CxwAhaRrYkAyNckcbQpRP5lgOiV4/r/jkGtFHRvVrNtuMEKVIAMoiK0oKEL2cVybzlmWjqG5hqOMQxQHOSwOe5oJtgBf8rAACjJ8NLqXc7ci0VEMnIgygwo67gqNr5vl6c1ehZSETEyNUOBqZE2uORBtmN7XVevJshXM8xDDEtjX4q96Qkbsdaja6+TKWIy3EbElClkV5wtkVBhsVItecuQP3HapZf0CRg1IAoqAUVDi+IFTOMcwExDf3IzOiyrTiiApIxypO3YpRwoa4Akk499VETEQb3Jm/VhtqqqIiM0TNrot0RFpaqHCjYUJdR/PoDNv10JTpWN0SAsSv8EogCGhO9gIgS2Juoay1HM1DVqo3dFnNkGa5mwxch4jXaCg3vjxuiFCz3mxGFJzxKF8ukOPQx3NLM5ua3UUbd+mZfUUJQoTb+bz1DgxoY2yqoo3RgIWhEw5FIQomk6pMDZ10YjEXPn1WiOrCOCl4PL29vUyvlzHMuIcDgPUsWdAYk7pQAlJENpPrWXn11gq06kCRENG0VAGnksSXPhKrxAE9ToV9wFfjBTneB7sVHjr6r4E8zJ7BGVGoDBElia/hkSTVQD5Qw/oKkSHhXJB6Mn4gEaboBDS7EU5qUEK0ROLMTiBTlQWvX+G8AQXRMh9UaF9QUWjRL/M0qyAEEBJFKRj4PyXKcEM9hiQT4YLEesHiXA6kYHWCC5rdvUl+kW9OT2tC1qIrm+ribRF7sdnQoT0xu8fb62G7oqHhZsMNwddrKmGmjaxfCAIyuV44EuYaFkbyiODFJCOJWgxNlVKja4O9ptwCTZyqs1PkO4Y0jfyNCGokmYwWpmIXDORtFos7w124TvUfdakborIygTu6UGX0LWIAJlWG9KFMrqcYyUh4DEgOIZnhTsdr9xDBGwp5RDvFxG1kYeKJTM6Bw1ZSSTFnSEuTh6+SbZgExPBVyCVDtiV8Rws5nZkhbKrxLmzd1pp9IyFFtLXu4avICGojClGVXDVGVYASpFnIqpy9IzAObsZaKTEmsgzbJNcjpjlzZG4zupFODiDYNDQNme3siEtvImFjKGpotNXgAtQileS6q3+UnZBYPhAAHOvjAyPCJjnnn87R1kEK3Tlv4ybkGfwuEy5yfuwa1/tgjWtvscsFagDNVoOq8pJFpSVjKYvUHsaCuiwafYwKFYaUPR1i20RMN0oloWoWl7vUk8ek/rwXoe2PgykDb0IVJWxl3gMRmH59poy9695xnBfwXBDwfhYEloIHrs+WsveUTmKrlDbfiYbTy+ef6lxbtq/z4bsX/Q7GDQi5XGVFJHyL0u9Mv3xxW/Wp2uVTS8St9tkDE3dM6H99fW3j1kuhTd8duHCYPfnxwn0d55d1zpiy4ZkrU19o3fNh6tBLs5afXp2Y+fcj8Vkrf5hG36++++lXh96++OSjc69sO2weLFvl8jy/Kn7+3KTqi9N3Hv3myy9+rY1v+iNSvWz3q2tjr5xNHxl7afPm56Dx2UOf9L54/NhPVff9tvHE/qk7tmz66+X417v6Y/smbK68OmPbLrHqVNEblfM+epofc3XvxL6fK4T2X0o3HO07/ubuksdW1O0/srGp9anVLZd2Vk52gQ8eeK2mOnho/WKq58L4Z6XJkc9nxCLRM+myy/7gloVX/jwzu/nb9+bND+zpiH1/5Nzi0MGeHW9lt/Ef4P5FGqsTAAA="
    
    
    // (Result<Reciplease, ErrorCase>)
    
    func searchCards(searchKeyword: String, completion: @escaping ([Card]?, Error?) -> Void) {
       guard let encodedSearchKeyword = searchKeyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(nil, NSError(domain: "EncodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Impossible d'encoder le terme de recherche"]))
            return
        }
        
        let urlString = "https://api.sandbox.ebay.com/buy/browse/v1/item_summary/search?q=\(encodedSearchKeyword)&limit=3"
        
        //"https://api.ebay.com/buy/browse/v1/item_summary/search?q=\(encodedSearchKeyword)&filter=category_ids:{183473}&limit=400"
      
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL invalide"]))
            return
        }
        print(url)
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(apiKey)"]
        
        AF.request(url, headers: headers)
            .validate(statusCode: 200..<600)
            .responseDecodable(of: [Card].self) { response in
                
                switch response.result {
                case .success(let cards):
                    print(cards)
                    completion(cards, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}

