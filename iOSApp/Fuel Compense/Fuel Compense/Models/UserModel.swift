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
    
    var globalsModel : GlobalsModel
    
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
    @Published var following : [String] = []
    @Published var followers : [String] = []
    @Published var nFollowing : Int = 0
    @Published var nFollowers : Int = 0
    private let userAPI = "users/"
    private let registerAPI = "new/"
    private let getFollowersAPI = "followers/"
    private let getFollowingAPI = "following/"
    private let unfollowAPI = "unfollow/"
    private let followAPI = "follow/"
    private let searchUsersAPI = "search/"
    
    init(globalsModel: GlobalsModel){
        userDef = UserDefaults.standard
        self.globalsModel = globalsModel
        if let userUserDefData = (userDef.object(forKey: "user") as? Data) {
            do {
                let userUserDef = try decoder.decode(User.self, from: userUserDefData)
                self.user = userUserDef
                if (self.user.userName == "") {
                    notLoggedUser = true
                } else {
                    self.getFollowers()
                    self.getFollowing()
                }
                print("User recovered")
            } catch {
                user = User(userName: "")
                notLoggedUser = true
            }
        } else {
            print("There was no user logged")
            user = User(userName: "")
            notLoggedUser = true
        }
        // retrieve the user data from the mobile, if not, retrieve it from the API, asking the userName. If not, create a user
    }
    
    func login(userName: String, completion: @escaping (Bool) -> Void) {

        let escapedLogin = "\(globalsModel.urlBase)\(self.userAPI)\(userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedLogin!) else {
            print("Error creando la URL")
            completion(false) // Llamamos al bloque de finalización con valor false
            return
        }
        
        var loginCorrect = true
        
        let task = globalsModel.session.dataTask(with: url) { (data, res, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    loginCorrect = false
                    print("Se recibió un error al hacer login: \(error!)")
                    completion(false)
                    return
                }
                
                let respuesta = (res as! HTTPURLResponse).statusCode
                guard respuesta == 200 else {
                    loginCorrect = false
                    print("Se recibió una respuesta distinta a 200 al hacer login. Respuesta: \(respuesta)")
                    completion(false)
                    return
                }
                
                if loginCorrect {
                    self.user = User(userName: userName)
                    self.notLoggedUser = false
                    self.getFollowers()
                    self.getFollowing()
                }
                completion(loginCorrect)
            }
        }
        
        task.resume()
    }

    
    func register(userName: String, completion: @escaping (Bool) -> Void) {
        let escapedLogin = "\(globalsModel.urlBase)\(self.userAPI)\(self.registerAPI)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedLogin!) else {
            print("Error creando la URL")
            completion(false)
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
        
        let task = globalsModel.session.dataTask(with: request) { (data, res, error) in
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
                self.notLoggedUser = false
            }
            
            completion(registerCorrect) // Llamamos al bloque de finalización con el valor actual de registerCorrect
        }
        
        task.resume()
    }
    
    func getFollowers() {
        let escapedFollowers = "\(globalsModel.urlBase)\(self.userAPI)\(self.getFollowersAPI)\(self.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedFollowers!) else {
            print("Error creando la URL " + escapedFollowers!)
            return
        }
        
        var followers: [String] = []
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: url) { (data, res, error) in
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
        
        self.followers = followers
        self.nFollowers = followers.count
    }

    
    func getFollowing() {
        let escapedFollowing = "\(globalsModel.urlBase)\(self.userAPI)\(self.getFollowingAPI)\(self.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedFollowing!) else {
            print("Error creando la URL " + escapedFollowing!)
            return
        }
        
        var following: [String] = []
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: url) { (data, res, error) in
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
        
        self.following = following
        self.nFollowing = following.count
    }
    
    func unfollow(userName: String, completion: @escaping (Bool) -> Void) {
        let escapedUnfollow = "\(globalsModel.urlBase)\(self.userAPI)\(self.unfollowAPI)\(userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedUnfollow!) else {
            print("Error creando la URL de unfollow")
            completion(false) // Llamamos al bloque de finalización con valor false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        request.httpBody = self.user.userName.data(using: .utf8)
        
        var unfollowCorrect = true
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: request) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            
            guard error == nil else {
                unfollowCorrect = false
                print("Se recibió un error al hacer unfollow: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                unfollowCorrect = false
                print("Se recibió una respuesta distinta a 200 al hacer unfollow. Respuesta: \(respuesta)")
                completion(false) // Llamamos al bloque de finalización con valor false
                return
            }
            completion(unfollowCorrect) // Llamamos al bloque de finalización con el valor actual de loginCorrect (true)
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if (unfollowCorrect) {
            DispatchQueue.main.async {
                self.getFollowing()
            }
        }
    }

    func follow(userName: String, completion: @escaping (Bool) -> Void) {
        let escapedFollow = "\(globalsModel.urlBase)\(self.userAPI)\(self.followAPI)\(userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedFollow!) else {
            print("Error creando la URL de follow")
            completion(false) // Llamamos al bloque de finalización con valor false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = self.user.userName.data(using: .utf8)
        var followCorrect = true
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: request) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            
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
            completion(followCorrect) // Llamamos al bloque de finalización con el valor actual de loginCorrect (true)
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if (followCorrect) {
            DispatchQueue.main.async {
                self.getFollowing()
            }
        }
    }
    
    func searchUsers(keyword: String) -> [String] {
        let escapedSearch = "\(globalsModel.urlBase)\(self.userAPI)\(self.searchUsersAPI)\(keyword)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedSearch!) else {
            print("Error creando la URL " + escapedSearch!)
            return []
        }
        
        var results: [String] = []
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: url) { (data, res, error) in
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
        self.user = User(userName: "")
        self.followers = []
        self.following = []
        self.notLoggedUser = true
    }
    
    func delete(userName: String) -> Bool {
        let escapedDelete = "\(globalsModel.urlBase)\(self.userAPI)\(userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedDelete!) else {
            print("Error creando la URL de unfollow")
            return false
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        
        var deleteCorrect = true
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: request) { (data, res, error) in
            guard error == nil else {
                deleteCorrect = false
                print("Se recibió un error al hacer unfollow: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                deleteCorrect = false
                print("Se recibió una respuesta distinta a 200 al hacer unfollow. Respuesta: \(respuesta)")
                return
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        self.logout()
        
        return deleteCorrect
    }
    
}
