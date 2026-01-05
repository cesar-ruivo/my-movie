import Foundation

// O Contrato
protocol HomeSectionStorageProtocol {
    func get() -> [HomeSections]
    func set(_ sections: [HomeSections])
    func add(_ section: HomeSections)
}

// A Implementação Real
final class HomeSectionStorage: HomeSectionStorageProtocol {
    private var activeSections: [HomeSections] = []
    
    func get() -> [HomeSections] {
        return activeSections
    }
    
    func set(_ sections: [HomeSections]) {
        self.activeSections = sections
    }
    
    func add(_ section: HomeSections) {
        self.activeSections.append(section)
    }
}
