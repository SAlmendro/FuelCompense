//
//  FuelModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation

struct Refill: Codable, Comparable {
    var date: Date
    var eurosLiter: Float
    var fullTank: Bool
    var id: UUID
    var liters: Float
    var odometer: Int
    var total: Float
    var totalCarbon: Float
    
    static func <(lhs: Refill, rhs: Refill) -> Bool {
            return lhs.odometer < rhs.odometer
    }

    enum CodingKeys: String, CodingKey {
        case date
        case eurosLiter
        case fullTank
        case id
        case liters
        case odometer
        case total
        case totalCarbon
    }

    init(date: Date, eurosLiter: Float, fullTank: Bool, liters: Float, odometer: Int, total: Float, totalCarbon: Float) {
        self.date = date
        self.eurosLiter = eurosLiter
        self.fullTank = fullTank
        self.id = UUID()
        self.liters = liters
        self.odometer = odometer
        self.total = total
        self.totalCarbon = totalCarbon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let dateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let date = dateFormatter.date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string is not in the expected format")
        }

        self.eurosLiter = try container.decode(Float.self, forKey: .eurosLiter)
        self.fullTank = try container.decode(Bool.self, forKey: .fullTank)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.liters = try container.decode(Float.self, forKey: .liters)
        self.odometer = try container.decode(Int.self, forKey: .odometer)
        self.total = try container.decode(Float.self, forKey: .total)
        self.totalCarbon = try container.decode(Float.self, forKey: .totalCarbon)
    }
}


struct FullTankData {
    
    var fullKm : Int
    var fullLiters : Float
    var fullCO2 : Float
    var totalEur : Float
    var meanConsume : Float
    var meanEmissions : Float
    var meanEur : Float
    
}


class FuelModel : ObservableObject {
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    @Published var refills : Array<Refill> {
        didSet {
            do {
                let data = try encoder.encode(refills)
                UserDefaults.standard.set(data, forKey: "refills")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var unpublishedRefills : Array<Refill> {
        didSet {
            do {
                let data = try encoder.encode(unpublishedRefills)
                UserDefaults.standard.set(data, forKey: "unpublishedRefills")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var unpublishedUpdateRefills : Array<Refill> {
        didSet {
            do {
                let data = try encoder.encode(unpublishedUpdateRefills)
                UserDefaults.standard.set(data, forKey: "unpublishedUpdateRefills")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var userDef : UserDefaults
    var globalsModel : GlobalsModel
    var userModel : UserModel
    let refillAPI = "refills/"
    
    init(globalsModel: GlobalsModel, userModel: UserModel){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        userDef = UserDefaults.standard
        self.globalsModel = globalsModel
        self.userModel = userModel
        if let refillsUserDefData = (userDef.object(forKey: "refills") as? Data) {
            do {
                let refillsUserDef = try decoder.decode(Array<Refill>.self, from: refillsUserDefData)
                self.refills = refillsUserDef
                print("Refills recovered")
            } catch {
                self.refills = []
                print(error.localizedDescription)
            }
        } else {
            print("There were no refuelings in userDef")
            self.refills = []
        }
        if let unpublishedRefillsUserDefData = (userDef.object(forKey: "unpublishedRefills") as? Data) {
            do {
                let unpublishedRefillsUserDef = try decoder.decode(Array<Refill>.self, from: unpublishedRefillsUserDefData)
                self.unpublishedRefills = unpublishedRefillsUserDef
                print("Unpublished refills recovered")
            } catch {
                self.unpublishedRefills = []
                print(error.localizedDescription)
            }
        } else {
            print("There were no unpublished refills in userDef")
            self.unpublishedRefills = []
        }
        if let unpublishedUpdateRefillsUserDefData = (userDef.object(forKey: "unpublishedUpdateRefills") as? Data) {
            do {
                let unpublishedUpdateRefillsUserDef = try decoder.decode(Array<Refill>.self, from: unpublishedUpdateRefillsUserDefData)
                self.unpublishedUpdateRefills = unpublishedUpdateRefillsUserDef
                print("Unpublished refills recovered")
            } catch {
                self.unpublishedUpdateRefills = []
                print(error.localizedDescription)
            }
        } else {
            print("There were no unpublished refills in userDef")
            self.unpublishedUpdateRefills = []
        }
    }
    
    func delete(index: Int) -> Void {
        refills.remove(at: index)
    }
    
    func deleteAllLocal() -> Void {
        refills = []
    }
    
    func getTrip(i: Int) -> Int {
        if (refills.count == i+1 || getNumberOfFullTanks() < 2 || refills.count < 2) {
            return 0
        }
        return refills[i].odometer - refills[i+1].odometer
    }
    
    public func getFullTankData(i: Int) -> FullTankData {
        if (i+1 == refills.count) {
            return FullTankData(
                fullKm: getTrip(i: i),
                fullLiters: refills[i].liters,
                fullCO2: refills[i].totalCarbon,
                totalEur: refills[i].total,
                meanConsume: 0,
                meanEmissions: 0,
                meanEur: 0
                )
        }
        var partial = !refills[i+1].fullTank
        let fullKm = getTrip(i: i)
        let fullLiters = refills[i].liters
        let fullCO2 = refills[i].totalCarbon
        let totalEur = refills[i].total
        var fullTankData = FullTankData(
            fullKm: fullKm,
            fullLiters: fullLiters,
            fullCO2: fullCO2,
            totalEur: totalEur,
            meanConsume: (fullLiters / Float(fullKm))*100,
            meanEmissions: (fullCO2 / Float(fullKm))*100,
            meanEur: (totalEur / Float(fullKm))*100
            )
        var index = i+1
        while(partial) {
            fullTankData.fullKm += getTrip(i: index)
            fullTankData.fullLiters += refills[index].liters
            fullTankData.fullCO2 += refills[index].totalCarbon
            fullTankData.totalEur += refills[index].total
            fullTankData.meanConsume = (fullTankData.fullLiters / Float(fullTankData.fullKm))*100
            fullTankData.meanEmissions = (fullTankData.fullCO2 / Float(fullTankData.fullKm))*100
            fullTankData.meanEur = (fullTankData.totalEur / Float(fullTankData.fullKm))*100
            index += 1
            if (index == refills.count) {
                return fullTankData
            }
            partial = !refills[index].fullTank
        }
        print(fullTankData.meanEmissions)
        return fullTankData
    }
    
    public func getAverageEmissions() -> Float {
        let totalEmissions = getTotalEmissions()
        if totalEmissions == 0 {
            return Float(0)
        }
        print("total emissions: \(totalEmissions)")
        let totalKm = getTotalKm()
        print("total km: \(totalKm)")
        if totalKm < 1 {
            return Float(0)
        }
        return (totalEmissions/Float(totalKm))*100
    }
    
    public func getTotalEmissions() -> Float {
        var totalEmissions = Float(0)
        for refill in refills {
            totalEmissions += refill.totalCarbon
        }
        return totalEmissions
    }
    
    public func getTotalConsume() -> Float {
        var totalConsume = Float(0)
        for i in refills.indices {
            totalConsume += refills[i].liters
        }
        return totalConsume
    }
    
    public func getTotalKm() -> Int {
        if refills.count < 2 {
            return 0
        }
        return refills[0].odometer - refills[refills.count - 1].odometer
    }
    
    public func getTotalEur() -> Float {
        var totalEur = Float(0)
        for i in refills.indices {
            totalEur += refills[i].total
        }
        return totalEur
    }
    
    public func getAverageConsume() -> Float {
        let totalKm = getTotalKm()
        if totalKm < 1 {
            return Float(0)
        }
        return (getTotalConsume()/Float(totalKm))*100
    }
    
    public func getAverageEur() -> Float {
        let totalKm = getTotalKm()
        if totalKm < 1 {
            return Float(0)
        }
        return (getTotalEur()/Float(totalKm))*100
    }
    
    public func getNumberOfFullTanks() -> Int {
        var n = 0;
        for refill in refills {
            if refill.fullTank {
                n += 1
            }
        }
        return n
    }
    
    func publishRefill(refill: Refill) -> Void {
        let escapedPublishRefill = "\(globalsModel.urlBase)\(self.refillAPI)\(userModel.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedPublishRefill!) else {
            print("Error creando la URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: Refill = refill
        var dataParameters = Data()
        do {
            dataParameters = try encoder.encode(parameters)
        } catch {
            print(error.localizedDescription)
        }
        request.httpBody = dataParameters
        
        var publishRefillCorrect = true
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: request) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            guard error == nil else {
                print("Se recibió un error al publicar el refill: \(error!)")
                publishRefillCorrect = false
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al publicar el refill. Respuesta: \(respuesta)")
                publishRefillCorrect = false
                return
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        var refillsTemp = self.refills
        refillsTemp.append(refill)
        let refillsSorted = refillsTemp.sorted(by: { (ref0: Refill, ref1: Refill) -> Bool in
            return ref0 > ref1
        })
        DispatchQueue.main.async {
            self.refills = refillsSorted
            
            if (!publishRefillCorrect) {
                self.unpublishedRefills.append(refill)
            }
        }
    }
    
    func updateRefill(refill: Refill) -> Void {
        let escapedUpdateRefill = "\(globalsModel.urlBase)\(self.refillAPI)\(userModel.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedUpdateRefill!) else {
            print("Error creando la URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let parameters: Refill = refill
        var dataParameters = Data()
        do {
            dataParameters = try encoder.encode(parameters)
        } catch {
            print(error.localizedDescription)
        }
        request.httpBody = dataParameters
        
        var updateRefillCorrect = true
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = globalsModel.session.dataTask(with: request) { (data, res, error) in
            defer {
                semaphore.signal()
            }
            guard error == nil else {
                print("Se recibió un error al actualizar el refill: \(error!)")
                updateRefillCorrect = false
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al actualizar el refill. Respuesta: \(respuesta)")
                updateRefillCorrect = false
                return
            }
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)

        DispatchQueue.main.async {
            if (!updateRefillCorrect) {
                self.unpublishedUpdateRefills.append(refill)
            }
        }
    }
    
    func getRefills() {
        let escapedRefills = "\(globalsModel.urlBase)\(self.refillAPI)\(userModel.user.userName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: escapedRefills!) else {
            print("Error creando la URL para recuperar los refills propios: \(escapedRefills!)")
            return
        }
        
        let task = globalsModel.session.dataTask(with: url) { (data, res, error) in
            guard error == nil else {
                print("Se recibió un error al recuperar los refills propios: \(error!)")
                return
            }
            
            let respuesta = (res as! HTTPURLResponse).statusCode
            guard respuesta == 200 else {
                print("Se recibió una respuesta distinta a 200 al recuperar los refills propios. Respuesta: \(respuesta)")
                return
            }
            
            do {
                if let data = data {
                    let refillsRetrieved = try JSONDecoder().decode([Refill].self, from: data)
                    let refillsSorted = refillsRetrieved.sorted(by: { (ref0, ref1) in
                        return ref0 > ref1
                    })
                    DispatchQueue.main.async {
                        self.refills = refillsSorted
                    }
                } else {
                    print("No se recibieron datos al recuperar los refills propios.")
                }
            } catch {
                print("Error al decodificar el JSON de refills: \(error)")
            }
        }
        
        task.resume()
    }
    
}
