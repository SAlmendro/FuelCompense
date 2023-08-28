//
//  UserModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 4/5/23.
//

import Foundation

struct User : Codable {

    var userName : String
    
}

class UserModel : ObservableObject {
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    @Published var user : User {
        didSet {
            do {
                let data = try encoder.encode(user)
                UserDefaults.standard.set(data, forKey: "user")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var notLoggedUser : Bool = false
    
    var userDef : UserDefaults
    let urlBase = "http://localhost:8080"
    let userAPI = "/users/"
    let registerAPI = "/users/new/"
    let session = URLSession.shared
    
    init(){
        userDef = UserDefaults.standard
        if let userUserDefData = (userDef.object(forKey: "user") as? Data) {
            do {
                let userUserDef = try decoder.decode(User.self, from: userUserDefData)
                self.user = userUserDef
                if (self.user.userName == "mock") {
                    notLoggedUser = true
                }
                print("User recovered")
            } catch {
                user = User(userName: "mock")
                notLoggedUser = true
            }
        } else {
            print("There was no user logged")
            user = User(userName: "mock")
            notLoggedUser = true
        }
        // retrieve the user data from the mobile, if not, retrieve it from the API, asking the userName. If not, create a user
    }
    
    func login(userName: String) -> Bool {
        let escapedLogin = "\(self.urlBase)\(self.userAPI)\(userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedLogin!) else {
            print("Error creando la URL")
            return false
        }
        
        var loginCorrect = true
        
        let task = self.session.dataTask(with: url) { (data, res, error) in
            
            guard error == nil else {
                print("Se recibió un error al hacer login: \(error!)")
                loginCorrect = false
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al hacer login. Respuesta: \(respuesta)")
                loginCorrect = false
                return
            }
            
        }
        
        task.resume()
        
        return loginCorrect
    }
    
    func register(userName: String) -> Bool {
        let escapedLogin = "\(self.urlBase)\(self.registerAPI)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedLogin!) else {
            print("Error creando la URL")
            return false
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: String] = [
            "userName": userName
        ]
        var dataParameters = Data()
        do {
            dataParameters = try encoder.encode(parameters)
        } catch {
            print(error.localizedDescription)
        }
        request.httpBody = dataParameters
        
        var registerCorrect = true
        
        let task = self.session.dataTask(with: request) { (data, res, error) in
            
            guard error == nil else {
                print("Se recibió un error al hacer el registro: \(error!)")
                registerCorrect = false
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al hacer el registro. Respuesta: \(respuesta)")
                registerCorrect = false
                return
            }
            
        }
        
        task.resume()
        
        if (registerCorrect) {
            user = User(userName: userName)
        }
        
        return registerCorrect
    }
    
    func delete(userName: String) -> Bool {
        if (userName == user.userName) {
            // call the API to delete the user, returns true if delete was succesfull
        }
        return false;
    }
    
}
