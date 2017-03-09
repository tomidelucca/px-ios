//
//  EntityType.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 3/9/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

open class EntityType : NSObject, Cellable {
    open var _id : NSNumber?
    open var name : String?
    
    open func getCell() -> UITableViewCell {
        let bundle = MercadoPago.getBundle()
        let cell: EntityTypeTableViewCell = bundle!.loadNibNamed("EntityTypeTableViewCell", owner: nil, options: nil)?[0] as! EntityTypeTableViewCell
        cell.fillCell(entityType: self)
        cell.addSeparatorLineToTop(width: Double(cell.contentView.frame.width), y: Float(cell.contentView.bounds.maxY))
        cell.selectionStyle = .none
        
        return cell
    }
    
    open class func fromJSON(_ json : NSDictionary) -> EntityType {
        let entityType : EntityType = EntityType()
        
        if let _id = JSONHandler.attemptParseToString(json["id"])?.numberValue{
            entityType._id = _id
        }
        if let name = JSONHandler.attemptParseToString(json["name"]){
            entityType.name = name
        }
        
        return entityType
    }
    
    open func toJSONString() -> String {
        return JSONHandler.jsonCoding(toJSON())
    }
    
    open func toJSON() -> [String:Any] {
        let id : Any = self._id == nil ? JSONHandler.null : self._id!
        let name : Any = self.name == nil ? JSONHandler.null : self.name!
        let obj:[String:Any] = [
            "id": id,
            "name" : name,
            ]
        return obj
    }
}

public func ==(obj1: EntityType, obj2: EntityType) -> Bool {
    
    let areEqual =
        obj1._id == obj2._id &&
            obj1.name == obj2.name
    
    return areEqual
}
