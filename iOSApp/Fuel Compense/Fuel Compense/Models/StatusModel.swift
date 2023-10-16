//
//  SocialModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 11/5/22.
//

import Foundation
import SwiftUI

struct Status: Codable, Equatable {
    var id: Int
    var text: String
    var favs: [String]
    var authUserName: String
    var creationDate: Date
    
    private enum CodingKeys: String, CodingKey {
        case id, text, favs, authUserName, creationDate
    }
    
    static func == (lhs: Status, rhs: Status) -> Bool {
            return
                lhs.id == rhs.id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        favs = try container.decode([String].self, forKey: .favs)
        authUserName = try container.decode(String.self, forKey: .authUserName)
        
        let dateString = try container.decode(String.self, forKey: .creationDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let date = dateFormatter.date(from: dateString) {
            creationDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .creationDate, in: container, debugDescription: "Invalid date format")
        }
    }
}

class StatusModel : ObservableObject {
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    var userModel : UserModel
    var globalsModel : GlobalsModel
    private let statusAPI = "statuses/"
    private let subscribedAPI = "subscribed/"
    private let favAPI = "fav/"
    
    @Published var statuses : Array<Status>
    @Published var subscribedStatuses : Array<Status>
    
    init(userModel: UserModel, globalsModel: GlobalsModel){
        self.userModel = userModel
        self.globalsModel = globalsModel
        statuses = []
        subscribedStatuses = []
    }
    
    func getSubscribedStatuses() {
        let escapedStatuses = "\(globalsModel.urlBase)\(self.statusAPI)\(self.subscribedAPI)\(userModel.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedStatuses!) else {
            print("Error creando la URL para recuperar los estados" + escapedStatuses!)
            return
        }
        
        var statuses: [Status] = []
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: url) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            
            guard error == nil else {
                print("Se recibió un error al recuperar los estados: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al recuperar los estados. Respuesta: \(respuesta)")
                return
            }
            
            do {
                statuses = try JSONDecoder().decode([Status].self, from: data!)
            } catch {
                print("Error al decodificar el JSON de estados: \(error)")
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        self.subscribedStatuses = statuses
        print(statuses)

    }
    
    func getStatuses() {
        let escapedStatuses = "\(globalsModel.urlBase)\(self.statusAPI)\(userModel.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedStatuses!) else {
            print("Error creando la URL para recuperar los estados propios" + escapedStatuses!)
            return
        }
        
        var statuses: [Status] = []
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: url) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            
            guard error == nil else {
                print("Se recibió un error al recuperar los estados propios: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al recuperar los estados propios. Respuesta: \(respuesta)")
                return
            }
            
            do {
                statuses = try JSONDecoder().decode([Status].self, from: data!)
            } catch {
                print("Error al decodificar el JSON de estados: \(error)")
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        self.statuses = statuses

    }
    
    func changeFav(status: Binding<Status>) -> Void {
        let statusFavs = status.favs.wrappedValue
        let favStart = statusFavs.contains(userModel.user.userName)
        var favState = favStart
        
        
        let escapedChangeFav = "\(globalsModel.urlBase)\(self.statusAPI)\(self.favAPI)\(status.wrappedValue.id)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedChangeFav!) else {
            print("Error creando la URL " + escapedChangeFav!)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = userModel.user.userName.data(using: .utf8)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: request) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            
            guard error == nil else {
                print("Se recibió un error al cambiar el estado de fav: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al cambiar el estado de fav. Respuesta: \(respuesta)")
                return
            }
            
            favState = !favState
            
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if (favState != favStart) {
            DispatchQueue.main.async {
                self.getStatus(status: status.wrappedValue)
            }
        }
    }
    
    func getStatus(status: Status) -> Void {
        let escapedStatus = "\(globalsModel.urlBase)\(self.statusAPI)\(status.id)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedStatus!) else {
            print("Error creando la URL para recuperar un estado" + escapedStatus!)
            return
        }
        
        var statusGetted : Optional<Status> = nil
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: url) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            
            guard error == nil else {
                print("Se recibió un error al recuperar un estado: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al recuperar un estado. Respuesta: \(respuesta)")
                return
            }
            
            do {
                statusGetted = try JSONDecoder().decode(Status.self, from: data!)
            } catch {
                print("Error al decodificar el JSON de estados: \(error)")
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        let statusIndex = self.subscribedStatuses.firstIndex(of: status).unsafelyUnwrapped
        
        if (statusGetted != nil) {
            DispatchQueue.main.async {
                self.subscribedStatuses[statusIndex] = statusGetted.unsafelyUnwrapped
            }
        }
    }
    
    func publish(status: Status) -> Void {
        // publish the new social unit to the API and then, retrieve the social units to have it complete.
        // statuses.append(status); append the status received from the API, as it has the creationDate
        self.getSubscribedStatuses()
        self.getStatuses()
    }
    
    func delete(status: Status, completion: @escaping (Bool) -> Void) {
        let escapedDelete = "\(globalsModel.urlBase)\(self.statusAPI)\(status.id)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedDelete!) else {
            print("Error creando la URL de delete de estado")
            completion(false)
            return
        }
        
        var deleteSuccess = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = globalsModel.session.dataTask(with: request) { (data, res, error) in
            guard error == nil else {
                deleteSuccess = false
                print("Se recibió un error al borrar un estado: \(error!)")
                completion(false)
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                deleteSuccess = false
                print("Se recibió una respuesta distinta a 200 al borrar un estado. Respuesta: \(respuesta)")
                completion(false)
                return
            }
            
            completion(deleteSuccess)
        }
        
        task.resume()
    }
    
    func deleteAllLocal() -> Void {
        self.subscribedStatuses = []
        self.statuses = []
    }
    
}
