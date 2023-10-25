//
//  CarbonModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation


struct Compensation: Codable, Comparable {
    
    var id = UUID()
    var date : Date
    var tons : Float
    var comment : String
    
    static func <(lhs: Compensation, rhs: Compensation) -> Bool {
        return lhs.date.compare(rhs.date).rawValue > 0
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
    }
    
    func delete(index: Int) -> Void {
        compensations.remove(at: index)
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
   
}
