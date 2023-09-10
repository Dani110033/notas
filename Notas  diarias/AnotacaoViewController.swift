//
//  AnotacaoViewController.swift
//  Notas  diarias
//
//  Created by Enzo on 08/09/23.
//

import UIKit
import CoreData

class AnotacaoViewController: UIViewController {
    
    
    @IBOutlet weak var texto: UITextView!
    var context: NSManagedObjectContext!
    var anotacao: NSManagedObject!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        //Configuracao iniciais
        self.texto.becomeFirstResponder()
        if anotacao != nil {//atualizar}
            let textoRecuperado = anotacao.value(forKey: "texto")
            self.texto.text = String(describing: textoRecuperado)
        
            }else{
            self.texto.text = ""
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
        @IBAction func salvar(_ sender: Any) {
            if anotacao != nil {//atualizar
                self.atualizarAnotacao()
                
                anotacao.setValue(self.texto.text , forKey: "texto")
                anotacao.setValue(Date() , forKey: "data")
            
                do {
                    try context.save()
                    print("sucesso ao atualizar anotacao")
                } catch let erro as Error {
                    print("Erro ao atualizar anotacao: \(erro.localizedDescription) ")
                }
                
                
                
            }else{
            self.salvaAnotacao()
            
            }
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }
        
    func atualizarAnotacao() {
        
    }
    
        func salvaAnotacao() {
            
            //Criar objeto para anotacao
            let novaAnotacao = NSEntityDescription.insertNewObject(forEntityName: "Anotacao", into: context)
            
            
            // Configura Anotacao
            novaAnotacao.setValue( self.texto.text , forKey: "texto")
            novaAnotacao.setValue( Date() , forKey: "data")
            
            //Formata data
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd , MM , yyyy , hh: mm "
            
            do {
                try context.save()
                print("Sucesso ao salvar anotacao!")
            } catch let erro as Error {
                print("Erro ao salvar anotacao:"  + erro.localizedDescription )
                
            }
            
                }

}
