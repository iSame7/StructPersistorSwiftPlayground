//: Playground - noun: a place where people can play

import UIKit

// MARK: -
// MARK: Property list conversion protocol

protocol PropertyListReadable {
    func propertyListRepresentation() -> NSDictionary
    init?(propertyListRepresentation:NSDictionary?)
}

func extractValuesFromPropertyListArray<T:PropertyListReadable>(propertyListArray:[AnyObject]?) -> [T] {
    guard let encodedArray = propertyListArray else {return []}
    return encodedArray.map{$0 as? NSDictionary}.flatMap{T(propertyListRepresentation:$0)}
}

func saveValuesToDefaults<T:PropertyListReadable>(newValues:[T], key:String) {
    let encodedValues = newValues.map{$0.propertyListRepresentation()}
    NSUserDefaults.standardUserDefaults().setObject(encodedValues, forKey:key)
}

// MARK: -
// MARK: Player

struct Player {
    let id:String
    let name:String

    init(_ id: String, _ name: String) {
        self.id = id
        self.name = name
    }
}

extension Player: PropertyListReadable {
    func propertyListRepresentation() -> NSDictionary {
        let representation:[String:AnyObject] = ["id":self.id, "name":self.name]
        return representation
    }

    init?(propertyListRepresentation:NSDictionary?) {
        guard let values = propertyListRepresentation else {return nil}
        if let id = values["id"] as? String,
            name = values["name"] as? String {
                self.id = id
                self.name = name
        } else {
            return nil
        }
    }
}