import UIKit

let apiCall = APICallBuilder()
    .baseUrl(url: "https://www.thecocktaildb.com/api/json/v1/1/search.php")
    .addQueryParameter(paramName: "s", paramValue: "Jack")
    .onDataReceived(dataHandler: {
        data in
        do {
            guard let drinks = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else {
                print("Error")
                return
            }
            
            print(drinks)
        }
        catch {
            print("Error parsing JSON")
        }
        
    })
    .build()

apiCall.execute()
