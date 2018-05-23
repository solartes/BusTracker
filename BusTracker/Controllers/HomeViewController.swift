//
//  HomeViewController.swift
//  BusTracker
//
//  Created by Julian Solarte on 5/1/18.
//  Copyright © 2018 unicauca. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var origenTextField: SearchTextField!
    @IBOutlet weak var destinoTextField: SearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origenTextField.filterStrings(["Exito","Campanario","Centro","Jardines de Paz","La Esmeralda","Los Naranjos","Piscinas Comfacauca","Lomas de Granada","Plaza de toros","Terminal","La Paz","Tomas Cipriano","Cementerio","Yambitara","Lacteos purace","Camilo Torres","Tulcan","Morinda","Chirimia","Carrera 6","Calle 13","Carrera 5","La Venta","Sena Norte"])
        destinoTextField.filterStrings(["Exito","Campanario","Centro","Jardines de Paz","La Esmeralda","Los Naranjos","Piscinas Comfacauca","Lomas de Granada","Plaza de toros","Terminal","La Paz","Tomas Cipriano","Cementerio","Yambitara","Lacteos purace","Camilo Torres","Tulcan","Morinda","Chirimia","Carrera 6","Calle 13","Carrera 5","La Venta","Sena Norte"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let rutasTableViewController = segue.destination as? RutasTableViewController{
            rutasTableViewController.origen=origenTextField.text!
            rutasTableViewController.destino=destinoTextField.text!
        }
    }

}

