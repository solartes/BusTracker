//
//  RutaFavorita.swift
//  BusTracker
//
//  Created by Julian Solarte on 5/23/18.
//  Copyright © 2018 unicauca. All rights reserved.
//

import Foundation

class RutaFavorita{
    var id:Int
    var nombre:String
    
    init(nombre:String,id:Int? = nil) {
        self.nombre = nombre
        self.id = id ?? -1
    }
    
    convenience init?(rs:FMResultSet) {
        let nombre = rs.string(forColumn: "nombreRuta")
        let id = rs.int(forColumn: "ROWID")
        self.init(nombre: nombre!, id:Int(id))
    }
    
}
