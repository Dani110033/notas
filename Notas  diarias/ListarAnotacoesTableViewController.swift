//
//  ListarAnotacoesTableViewController.swift
//  Notas  diarias
//
//  Created by Enzo on 08/09/23.
//

import UIKit
import CoreData

class ListarAnotacoesTableViewController: UITableViewController {
    var context: NSManagedObjectContext!
    var anotacoes: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recuperarAnotacoes()
    }
    
    func recuperarAnotacoes() {
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacao")
       
        do {
        let anotacoesRecuperadas = try context.fetch(requisicao)
            self.anotacoes = anotacoesRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()
            } catch let erro as Error {
            print("Erro ao recuperar anotacoes: \(erro.localizedDescription) ")
        }
    
    }

override func numberOfSections( in tableView: UITableView) -> Int {
    return 1
    
}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.anotacoes.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        let anotacao = self.anotacoes[indice]
        self.performSegue(withIdentifier: "verAnotacao", sender: anotacao )
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verAnotacao"  {
            let viewdestino = segue.destination as! AnotacaoViewController
            viewdestino.anotacao = (sender  as!  NSManagedObject)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula" , for: indexPath)
        
        let anotacao = self.anotacoes[ indexPath.row ]
        let textoRecuperado = anotacao.value(forKey: "texto")
        let dataRecuperda = anotacao.value(forKey: "data")
        
        celula.textLabel?.text = textoRecuperado as? String
        celula.detailTextLabel?.text = String(describing: dataRecuperda)
        
    return celula
    
}
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let indice = indexPath.row
            let anotacao = self.anotacoes[indice]
            
            self.context.delete(anotacao)
            self.anotacoes.remove(at: indice)
            
            self.tableView.deleteRows(at: [indexPath] , with: .automatic)
            
            do {
                try self.context.save()
            }catch  let erro {
                print("Erro ao remover item \(erro) ")
        }
    }

}
}
