//
//  CarbonModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation


struct Compensation: Codable, Comparable {

    var comment : String
    var date : Date
    var id = UUID()
    var tons : Float
    
    static func <(lhs: Compensation, rhs: Compensation) -> Bool {
        return lhs.date.compare(rhs.date).rawValue > 0
    }
    
    enum CodingKeys: String, CodingKey {
        case comment
        case date
        case id
        case tons
    }
    
    init(comment: String, date: Date, id: UUID = UUID(), tons: Float) {
        self.comment = comment
        self.date = date
        self.id = id
        self.tons = tons
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.comment = try container.decode(String.self, forKey: .comment)
        
        let dateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let date = dateFormatter.date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string is not in the expected format")
        }
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.tons = try container.decode(Float.self, forKey: .tons)
    }
}


class CarbonModel : ObservableObject {
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    @Published var compensations : Array<Compensation> {
        didSet {
            do {
                let data = try encoder.encode(compensations)
                UserDefaults.standard.set(data, forKey: "compensations")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var unpublishedCompensations : Array<Compensation> {
        didSet {
            do {
                let data = try encoder.encode(unpublishedCompensations)
                UserDefaults.standard.set(data, forKey: "unpublishedCompensations")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var unpublishedUpdateCompensations : Array<Compensation> {
        didSet {
            do {
                let data = try encoder.encode(unpublishedUpdateCompensations)
                UserDefaults.standard.set(data, forKey: "unpublishedUpdateCompensations")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var userDef : UserDefaults
    let compensationAPI = "compensations/"
    var globalsModel : GlobalsModel
    var userModel : UserModel
    
    init(globalsModel: GlobalsModel, userModel: UserModel){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        userDef = UserDefaults.standard
        self.globalsModel = globalsModel
        self.userModel = userModel
        if let compensationsUserDefData = (userDef.object(forKey: "compensations") as? Data) {
            do {
                let compensationsUserDef = try decoder.decode(Array<Compensation>.self, from: compensationsUserDefData)
                self.compensations = compensationsUserDef
                print("Compensations recovered")
            } catch {
                self.compensations = []
                print(error.localizedDescription)
            }
        } else {
            print("There were no compensations in userDef")
            self.compensations = []
        }
        if let unpublishedCompensationsUserDefData = (userDef.object(forKey: "unpublishedCompensations") as? Data) {
            do {
                let unpublishedCompensationsUserDef = try decoder.decode(Array<Compensation>.self, from: unpublishedCompensationsUserDefData)
                self.unpublishedCompensations = unpublishedCompensationsUserDef
                print("Unpublished compensations recovered")
            } catch {
                self.unpublishedCompensations = []
                print(error.localizedDescription)
            }
        } else {
            print("There were no unpublished compensations in userDef")
            self.unpublishedCompensations = []
        }
        if let unpublishedUpdateCompensationsUserDefData = (userDef.object(forKey: "unpublishedUpdateCompensations") as? Data) {
            do {
                let unpublishedUpdateCompensationsUserDef = try decoder.decode(Array<Compensation>.self, from: unpublishedUpdateCompensationsUserDefData)
                self.unpublishedUpdateCompensations = unpublishedUpdateCompensationsUserDef
                print("Unpublished update compensations recovered")
            } catch {
                self.unpublishedUpdateCompensations = []
                print(error.localizedDescription)
            }
        } else {
            print("There were no unpublished update compensations in userDef")
            self.unpublishedUpdateCompensations = []
        }
    }
    
    func delete(index: Int) -> Void {
        let compensation = self.compensations[index]
        let escapedDelete = "\(globalsModel.urlBase)\(self.compensationAPI)\(compensation.id)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedDelete!) else {
            print("Error creando la URL de delete de compensacion")
            return
        }
        
        var deleteSuccess = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = userModel.user.userName.data(using: .utf8)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: request) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            guard error == nil else {
                deleteSuccess = false
                print("Se recibió un error al borrar una compensacion: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                deleteSuccess = false
                print("Se recibió una respuesta distinta a 200 al borrar una compensacion. Respuesta: \(respuesta)")
                return
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if deleteSuccess {
            self.compensations.remove(at: index)
        }
    }
    
    func deleteAllLocal() -> Void {
        compensations = []
    }
    
    public func getTotalCompensedInKg() -> Float {
        var totalCompensed = Float(0)
        if compensations.isEmpty {
            return totalCompensed
        }
        for compensation in compensations {
            totalCompensed += compensation.tons
        }
        return totalCompensed*1000
    }
    
    func publishCompensation(compensation: Compensation) -> Void {
        let escapedPublishRefill = "\(globalsModel.urlBase)\(self.compensationAPI)\(userModel.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedPublishRefill!) else {
            print("Error creando la URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: Compensation = compensation
        var dataParameters = Data()
        do {
            dataParameters = try encoder.encode(parameters)
        } catch {
            print(error.localizedDescription)
        }
        request.httpBody = dataParameters
        
        var publishCompensationCorrect = true
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: request) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            guard error == nil else {
                print("Se recibió un error al publicar la compensacion: \(error!)")
                publishCompensationCorrect = false
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al publicar la compensacion. Respuesta: \(respuesta)")
                publishCompensationCorrect = false
                return
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        var compensationsTemp = self.compensations
        compensationsTemp.append(compensation)
        let compensationsSorted = compensationsTemp.sorted(by: { (com0: Compensation, com1: Compensation) -> Bool in
            return com0 < com1
        })
        DispatchQueue.main.async {
            self.compensations = compensationsSorted
            
            if (!publishCompensationCorrect) {
                self.unpublishedCompensations.append(compensation)
            }
        }
    }
    
    func updateCompensation(compensation: Compensation) -> Void {
        let escapedUpdateCompensation = "\(globalsModel.urlBase)\(self.compensationAPI)\(userModel.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedUpdateCompensation!) else {
            print("Error creando la URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let parameters: Compensation = compensation
        var dataParameters = Data()
        do {
            dataParameters = try encoder.encode(parameters)
        } catch {
            print(error.localizedDescription)
        }
        request.httpBody = dataParameters
        
        var updateCompensationCorrect = true
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: request) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            guard error == nil else {
                print("Se recibió un error al actualizar la compensacion: \(error!)")
                updateCompensationCorrect = false
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al actualizar la compensacion. Respuesta: \(respuesta)")
                updateCompensationCorrect = false
                return
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)

        DispatchQueue.main.async {
            if (!updateCompensationCorrect) {
                self.unpublishedUpdateCompensations.append(compensation)
            }
        }
    }
    
    func getCompensations() {
        let escapedRefills = "\(globalsModel.urlBase)\(self.compensationAPI)\(userModel.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedRefills!) else {
            print("Error creando la URL para recuperar las compensaciones propias: \(escapedRefills!)")
            return
        }
        
        let task = globalsModel.session.dataTask(with: url) { (data, res, error) in
            guard error == nil else {
                print("Se recibió un error al recuperar las compensaciones propias: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al recuperar las compensaciones propias. Respuesta: \(respuesta)")
                return
            }
            
            do {
                if let data = data {
                    let compensationsRetrieved = try JSONDecoder().decode([Compensation].self, from: data)
                    let compensationsSorted = compensationsRetrieved.sorted(by: { (com0, com1) in
                        return com0 < com1
                    })
                    DispatchQueue.main.async {
                        self.compensations = compensationsSorted
                    }
                } else {
                    print("No se recibieron datos al recuperar las compensaciones propias.")
                }
            } catch {
                print("Error al decodificar el JSON de compensaciones: \(error)")
            }
        }
        
        task.resume()
    }
}
