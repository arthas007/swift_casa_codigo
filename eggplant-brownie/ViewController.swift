//
//  ViewController.swift
//  eggplant-brownie
//
//  Created by Arthur Diego on 1/9/17.
//  Copyright © 2017 br.com.alura. All rights reserved.
//

import UIKit

/*
    Interface que gera um contrato com a classe que implementa ela
 */
protocol AddAMealDelegate {
    func add(meal: Meal)
}

/*
    Interface dataSource para implementar os metodos da table view que estão conectados ao controller
 */
protocol UITableViewDataSource : NSObjectProtocol{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
}
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddAnItemDelegate {
    
    @IBOutlet var nameField : UITextField!
    @IBOutlet var happinessField : UITextField!
    @IBOutlet var tableView: UITableView?
    var delegate:AddAMealDelegate?
    
    var items = [Item(name: "Eggplant Brownie", calories: 10),
                 Item(name: "Zucchini Muffin", calories: 10),
                 Item(name: "Cookie", calories: 10),
                 Item(name: "Coconut oil", calories: 500),
                 Item(name: "Chocolate frosting", calories: 1000),
                 Item(name: "Chocolate chip", calories: 1000)]
    
    var selected = Array<Item>()
    
    /*
        Metodo que sobrescreve e cria um botao em tempo de execução
        e atribui a ele algunas propriedades
        e coloca ele num Selector
    */
    override func viewDidLoad() {	
       
        let newItemButton = UIBarButtonItem(title: "new item", style: UIBarButtonItemStyle.plain, target: self, action: Selector("showNewItem"))
        
        navigationItem.rightBarButtonItem = newItemButton
        
    }
    
    func addNew(item: Item){
        items.append(item)
        
        if let table = tableView {
            table.reloadData()
        } else {
            Alert(controller: self).show()
            
        }
       
    }
    
    /*
        @IBAction listener de ação, navega para a view selecionada
     */
    @IBAction func showNewItem(){
        let newItem = NewItemViewController(delegate2: self)
        if let navigation = navigationController{
            navigation.pushViewController(newItem, animated: true)
        }else{
            Alert(controller: self).show()
            
        }
    }
    
    func getMeal() -> Meal?{
        if nameField == nil || happinessField == nil{
            return nil
        }
        let name = nameField!.text
        let happiness:Int! = Int(happinessField.text!)
        
        if happiness == nil{
            return nil
        }
        
        let meal = Meal(name: name!, happiness: happiness)
        meal.items = selected
        print("eaten:\(meal.name)\(meal.happiness)\(meal.items)")
        return meal
    }
    
    @IBAction func add(){
        if let meal = getMeal() {
            if let meals = delegate {
                meals.add(meal: meal)
            
                if let navigation = self.navigationController{
                    navigation.popViewController(animated:true )
                }else{
                    Alert(controller: self).show(message: "Erro inesperado, mas a refeição foi adicionada.")
                }
            return
            }
        }
        Alert(controller: self).show()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count // Retorna quantidade de linhas que a tabela possuir  com base no tamanho do array
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = items[row]
        var cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil) //Intancia o componente CEll
        
        cell.textLabel!.text = item.name //Atribui o valo do atributo name do objeto Item
        
        return cell
        
    }
    /*
        Método para selecionar e deselecionar os itens da tableview 
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell == nil{
            return
        }
        if(cell!.accessoryType == UITableViewCellAccessoryType.none){
        cell!.accessoryType = UITableViewCellAccessoryType.checkmark
            selected.append(items[indexPath.row])
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.none
            let position = selected.index(of: items[indexPath.row])
            selected.remove(at: position!)
        }
    }

    
    
}

	
