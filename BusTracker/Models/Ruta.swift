//
//  Ruta.swift
//  BusTracker
//
//  Created by Julian Solarte on 5/21/18.
//  Copyright © 2018 unicauca. All rights reserved.
//

import Foundation

class Ruta {
    var id:Int
    var nombre:String
    var destinos:[String]
    var tiempoLlegada:String
    var horario:String
    var rutaFavorita:Bool


    init(nombre:String,tiempoLlegada:String? = "",horario:String,id:Int? = nil,destinos:[String]) {
        self.nombre=nombre
        self.destinos=destinos
        self.tiempoLlegada=tiempoLlegada ?? ""
        self.horario=horario
        self.id = id ?? -1
        rutaFavorita=false
    }
}
