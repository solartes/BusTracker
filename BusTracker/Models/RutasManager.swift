//
//  RutasManager.swift
//  BusTracker
//
//  Created by Julian Solarte on 5/21/18.
//  Copyright © 2018 unicauca. All rights reserved.
//

import Foundation

// MARK: Paths
private var appSupportDirectory:URL = {
    let url = FileManager().urls(for:.applicationSupportDirectory,in: .userDomainMask).first!
    if !FileManager().fileExists(atPath: url.path) {
        do {
            try FileManager().createDirectory(at: url,
                                              withIntermediateDirectories: false)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }
    return url
}()

private var rutasFile:URL = {
    let filePath = appSupportDirectory.appendingPathComponent("Rutas").appendingPathExtension("db")
    print(filePath)
    if !FileManager().fileExists(atPath: filePath.path) {
        if let bundleFilePath = Bundle.main.resourceURL?.appendingPathComponent("Rutas").appendingPathExtension("db") {
            do {
                try FileManager().copyItem(at: bundleFilePath, to: filePath)
            } catch let error as NSError {
                //fingers crossed
                print("\(error.localizedDescription)")
            }
        }
    }
    return filePath
}()
class RutasManager {
    private lazy var rutas:[Ruta] = self.loadRutas()
    var rutasEncontradas:[Ruta]=[]
    var rutasFavoritas:[RutaFavorita]=[]
    var rutasCount:Int {return rutas.count}
    var rutasFoundCount:Int {return rutasEncontradas.count}
    
    func getAllRuta(at index:Int)->Ruta {
        return rutas[index]
    }
    
    func getFoundRuta(at index:Int)->Ruta {
        return rutasEncontradas[index]
    }
    
    private func loadRutas()->[Ruta] {
        return todasRutas()
    }
    
    private func todasRutas()->[Ruta] {
        return [
            Ruta(nombre:"Ruta 1",horario:"Lunes a Viernes 6:00am - 8:00pm",destinos:["La Paz","Exito","Terminal","La Esmeralda","Tomas Cipriano","Los Naranjos"]),
            Ruta(nombre:"Ruta 2",horario:"Lunes a Viernes 6:00am - 8:00pm",destinos:["Tomas Cipriano","Chirimia","Centro","Carrera 6","Campanario","Jardines de Paz"]),
            Ruta(nombre:"Ruta 4",horario:"Lunes a Viernes 6:00am - 8:00pm",destinos:["Piscinas Comfacauca","Centro","Carrera 5","Plaza de toros","Calle 13","Chirimia","Lomas de Granada"]),
            Ruta(nombre:"Ruta 5",horario:"Lunes a Viernes 6:00am - 8:00pm",destinos:["Yambitara","Centro","Carrera 6","Calle 13","Cementerio","Tomas Cipriano"]),
            Ruta(nombre:"Ruta 6",horario:"Lunes a Viernes 6:00am - 8:00pm",destinos:["La Paz","Lacteos Purace","Tulcan","Calle 13","Chirimia","Los Naranjos"]),
            Ruta(nombre:"Ruta 7",horario:"Lunes a Viernes 6:00am - 8:00pm",destinos:["Piscinas Comfacauca","Campanario","Exito","Terminal","Camilo Torres","Calle 13"]),
            Ruta(nombre:"Ruta 8",horario:"Lunes a Viernes 6:00am - 8:00pm",destinos:["Los Naranjos","Tomas Cipriano","La Esmeralda","Calle 13","Morinda"]),
            Ruta(nombre:"Ruta 9",horario:"Lunes a Viernes 6:00am - 8:00pm",destinos:["Los Naranjos","Tomas Cipriano","Calle 13","Centro","Campanario","La Venta"]),
            Ruta(nombre:"Ruta 10",horario:"Lunes a Viernes 6:00am - 8:00pm",destinos:["Lomas de Granada","Chirimia","Esmeralda","Exito","Terminal","Campanario","Sena Norte"]),
            Ruta(nombre:"Ruta 11",horario:"Lunes a Viernes 6:00am - 8:00pm",destinos:["La Paz","Exito","Terminal","La Esmeralda","Tomas Cipriano","Los Naranjos"])
        ]
    }
    
    func obtenerRutas(origen:String, destino:String){
        rutasEncontradas=[]
        var origenBool:Int = -1
        var destinoBool:Int = -1
        for ruta in rutas {
            for(index,lugar) in ruta.destinos.enumerated(){
                if(origen==lugar){
                    origenBool=index;
                }
                if(destino==lugar){
                    destinoBool=index;
                }
            }
            if(origenBool<destinoBool && origenBool != -1 && destinoBool != -1){
                rutasEncontradas.append(ruta);
            }
            origenBool = -1
            destinoBool = -1
        }
        verificarFavorito()
    }
    
    func verificarFavorito(){
        retrieveRutasFav()
        for rutaFav in rutasFavoritas {
            for rutaOri in rutas {
                if(rutaFav.nombre==rutaOri.nombre){
                    rutaOri.rutaFavorita=true
                }
            }
        }
    }
    
    func obtenerRutasFavoritas(){
        rutasEncontradas=[]
        retrieveRutasFav()
        for rutaFav in rutasFavoritas {
            for rutaOri in rutas {
                if(rutaFav.nombre==rutaOri.nombre){
                    rutaOri.rutaFavorita=true
                    rutasEncontradas.append(rutaOri);
                }
            }
        }
    }
    
    func addRutaFav(_ ruta:RutaFavorita) {
        var ruta = ruta
        SQLAddRutaFav(ruta: &ruta)
    }
    
    func removeRutaFav(_ ruta:RutaFavorita) {
        let ruta = ruta
        SQLRemoveRutaFav(ruta: ruta)
    }
    
    func getOpenDB()->FMDatabase? {
        let db = FMDatabase(path: rutasFile.path)
        guard db.open() else {
            print("Unable to open database")
            return nil
        }
        return db
    }
    
    func retrieveRutasFav(){
        rutasFavoritas=[]
        guard let db = getOpenDB() else { return }
        do {
            let rs = try db.executeQuery(
                "SELECT *, ROWID FROM rutasFavoritas", values: nil)
            while rs.next() {
                if let ruta = RutaFavorita(rs: rs) {
                    rutasFavoritas.append(ruta)
                }
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        db.close()
    }
    
    func SQLAddRutaFav(ruta:inout RutaFavorita) {
        guard let db = getOpenDB() else { return }
        do {
            try db.executeUpdate(
                "insert into rutasFavoritas (nombreRuta) values (?)",
                values: [ruta.nombre]
            )
            ruta.id = Int(db.lastInsertRowId)
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        db.close()
    }
    
    func SQLRemoveRutaFav(ruta:RutaFavorita) {
        guard let db = getOpenDB() else { return }
        do {
            try db.executeUpdate(
                "delete from rutasFavoritas where nombreRuta = ?",
                values: [ruta.nombre]
            )
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        db.close()
    }}
