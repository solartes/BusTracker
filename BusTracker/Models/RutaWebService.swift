//
//  RutaWebService.swift
//  BusTracker
//
//  Created by Gustavo on 5/24/18.
//  Copyright © 2018 unicauca. All rights reserved.
//

import Foundation

protocol RutaService {
    func getRuta(with barcode: String,
                 completionHandler: @escaping (Ruta?, Error?) -> Void)
    func cancel()
}

class RutaWebService: RutaService {
    
}
