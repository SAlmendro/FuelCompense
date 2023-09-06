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
    var following : [String] = []
    var followers : [String] = []
    private let urlBase = "http://localhost:8080"
    private let userAPI = "/users/"
    private let registerAPI = "/users/new/"
    private let getFollowersAPI = "/users/followers/"
    private let getFollowingAPI = "/users/following/"
    private let unfollowAPI = "/users/unfollow/"
    private let followAPI = "/users/follow/"
    private let searchUsersAPI = "/users/search/"
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
                self.followers = self.getFollowers()
                self.following = self.getFollowing()
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
    
    func login(userName: String, completion: @escaping (Bool) -> Void) {
        let escapedLogin = "\(self.urlBase)\(self.userAPI)\(userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedLogin!) else {
            print("Error creando la URL")
            completion(false) // Llamamos al bloque de finalización con valor false
            return
        }
        
        var loginCorrect = true
        
        let task = self.session.dataTask(with: url) { (data, res, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    loginCorrect = false
                    print("Se recibió un error al hacer login: \(error!)")
                    completion(false) // Llamamos al bloque de finalización con valor false
                    return
                }
                
                let respuesta = (res as! HTTPURLResponse).statusCode
                guard respuesta == 200 else {
                    loginCorrect = false
                    print("Se recibió una respuesta distinta a 200 al hacer login. Respuesta: \(respuesta)")
                    completion(false) // Llamamos al bloque de finalización con valor false
                    return
                }
                
                if loginCorrect {
                    self.user = User(userName: userName)
                    self.followers = self.getFollowers()
                    self.following = self.getFollowing()
                }
                
                completion(loginCorrect) // Llamamos al bloque de finalización con el valor actual de loginCorrect (true)
            }
        }
        
        task.resume()
    }

    
    func register(userName: String, completion: @escaping (Bool) -> Void) {
        let escapedLogin = "\(self.urlBase)\(self.registerAPI)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedLogin!) else {
            print("Error creando la URL")
            completion(false) // Llamamos al bloque de finalización con valor false
            return
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
                completion(false) // Llamamos al bloque de finalización con valor false
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al hacer el registro. Respuesta: \(respuesta)")
                registerCorrect = false
                completion(false) // Llamamos al bloque de finalización con valor false
                return
            }
            
            if registerCorrect {
                self.user = User(userName: userName)
            }
            
            completion(registerCorrect) // Llamamos al bloque de finalización con el valor actual de registerCorrect
        }
        
        task.resume()
    }
    
    func getFollowers() -> [String] {
        let escapedFollowers = "\(self.urlBase)\(self.getFollowersAPI)\(self.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedFollowers!) else {
            print("Error creando la URL " + escapedFollowers!)
            return []
        }
        
        var followers: [String] = []
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = self.session.dataTask(with: url) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            
            guard error == nil else {
                print("Se recibió un error al buscar los seguidores: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al hacer buscar los seguidores. Respuesta: \(respuesta)")
                return
            }
            
            do {
                followers = try JSONDecoder().decode([String].self, from: data!)
            } catch {
                print("Error al decodificar el JSON de seguidores: \(error)")
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return followers
    }

    
    func getFollowing() -> [String] {
        let escapedFollowing = "\(self.urlBase)\(self.getFollowingAPI)\(self.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedFollowing!) else {
            print("Error creando la URL " + escapedFollowing!)
            return []
        }
        
        var following: [String] = []
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = self.session.dataTask(with: url) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            
            guard error == nil else {
                print("Se recibió un error al buscar los seguidos: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al hacer buscar los seguidos. Respuesta: \(respuesta)")
                return
            }
            
            do {
                following = try JSONDecoder().decode([String].self, from: data!)
            } catch {
                print("Error al decodificar el JSON de seguidos: \(error)")
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return following
    }
    
    func unfollow(userName: String, completion: @escaping (Bool) -> Void) {
        let escapedUnfollow = "\(self.urlBase)\(self.unfollowAPI)\(userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedUnfollow!) else {
            print("Error creando la URL de unfollow")
            completion(false) // Llamamos al bloque de finalización con valor false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        let parameters: String = self.user.userName
        var dataParameters = Data()
        do {
            dataParameters = try encoder.encode(parameters)
        } catch {
            print(error.localizedDescription)
        }
        request.httpBody = dataParameters
        
        var unfollowCorrect = true
        
        let task = self.session.dataTask(with: request) { (data, res, error) in
            guard error == nil else {
                unfollowCorrect = false
                print("Se recibió un error al hacer unfollow: \(error!)")
                completion(false) // Llamamos al bloque de finalización con valor false
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                unfollowCorrect = false
                print("Se recibió una respuesta distinta a 200 al hacer unfollow. Respuesta: \(respuesta)")
                completion(false) // Llamamos al bloque de finalización con valor false
                return
            }
            self.followers = self.getFollowers()
            self.following = self.getFollowing()
            completion(unfollowCorrect) // Llamamos al bloque de finalización con el valor actual de loginCorrect (true)
        }
        
        task.resume()
    }

    func follow(userName: String, completion: @escaping (Bool) -> Void) {
        let escapedFollow = "\(self.urlBase)\(self.followAPI)\(userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedFollow!) else {
            print("Error creando la URL de follow")
            completion(false) // Llamamos al bloque de finalización con valor false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: String = self.user.userName
        var dataParameters = Data()
        do {
            dataParameters = try encoder.encode(parameters)
        } catch {
            print(error.localizedDescription)
        }
        request.httpBody = dataParameters
        
        var followCorrect = true
        
        let task = self.session.dataTask(with: request) { (data, res, error) in
            guard error == nil else {
                followCorrect = false
                print("Se recibió un error al hacer follow: \(error!)")
                completion(false) // Llamamos al bloque de finalización con valor false
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                followCorrect = false
                print("Se recibió una respuesta distinta a 200 al hacer follow. Respuesta: \(respuesta)")
                completion(false) // Llamamos al bloque de finalización con valor false
                return
            }
            self.followers = self.getFollowers()
            self.following = self.getFollowing()
            completion(followCorrect) // Llamamos al bloque de finalización con el valor actual de loginCorrect (true)
        }
        
        task.resume()
    }
    
    func searchUsers(keyword: String) -> [String] {
        let escapedSearch = "\(self.urlBase)\(self.searchUsersAPI)\(keyword)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedSearch!) else {
            print("Error creando la URL " + escapedSearch!)
            return []
        }
        
        var results: [String] = []
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = self.session.dataTask(with: url) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            
            guard error == nil else {
                print("Se recibió un error al buscar usuarios: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al buscar usuarios. Respuesta: \(respuesta)")
                return
            }
            
            do {
                results = try JSONDecoder().decode([String].self, from: data!)
            } catch {
                print("Error al decodificar el JSON de usuarios: \(error)")
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return results
    }

    func logout() {
        self.user = User(userName: "mock")
        self.followers = []
        self.following = []
        self.notLoggedUser = true
    }
    
    func delete(userName: String) -> Bool {
        if (userName == user.userName) {
            // call the API to delete the user, returns true if delete was succesfull
        }
        return false;
    }
    
}
