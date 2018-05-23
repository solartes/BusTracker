//
//  DetalleRutaViewController.swift
//  BusTracker
//
//  Created by Julian Solarte on 5/21/18.
//  Copyright © 2018 unicauca. All rights reserved.
//

import UIKit

class DetalleRutaViewController: UIViewController {

    var ruta:Ruta?
    var rutaManager:RutasManager=RutasManager()
    @IBOutlet weak var nombreRuta: UILabel!
    @IBOutlet weak var horarioRuta: UILabel!
    @IBOutlet weak var recorridoRuta: UILabel!
    @IBOutlet weak var favBoton: UIButton!
    
    
    @IBAction func addFavorite(_ sender: Any) {
        let rutaFavorita=RutaFavorita(nombre: ruta!.nombre)
        if ruta!.rutaFavorita {
            rutaManager.removeRutaFav(rutaFavorita)
            favBoton.setImage(UIImage(named: "nofav.png"), for: .normal)
        }else{
            rutaManager.addRutaFav(rutaFavorita)
            favBoton.setImage(UIImage(named: "yesfav.png"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let ruta=ruta{
            nombreRuta.text=ruta.nombre
            horarioRuta.text=ruta.horario
            recorridoRuta.text=ruta.destinos.joined(separator: "->")
            if ruta.rutaFavorita {
                favBoton.setImage(UIImage(named: "yesfav.png"), for: .normal)
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
