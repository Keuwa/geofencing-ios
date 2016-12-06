//
//  PlayerListViewController.swift
//  TeamOrganizer
//
//  Created by Vincent Durpoix on 23/11/2016.
//  Copyright © 2016 keuwa. All rights reserved.
//

import UIKit
import CoreData

class PlayerListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var playerTableView: UITableView!
    var playerArray : [Player] = []
    let cellIdentifier = "ElementCell"

    override func viewWillAppear(_ animated: Bool) {
        initTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addTapped))

        self.navigationItem.rightBarButtonItem = button;
        self.title = "Joueurs"

        
        playerTableView.delegate = self
        playerTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTable(){
        if let context = DataManager.shared.objectContext {
            let request: NSFetchRequest = Player.fetchRequest()
            if let players = try? context.fetch(request){
                playerArray = []
                playerArray.append(contentsOf: players)
                playerTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            deletePlayer(player: playerArray[indexPath.row])
            playerArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        // Adding the right informations
        cell.textLabel?.text = self.playerArray[indexPath.row].name;
        
        // Returning the cell
        return cell

    }
    
    //Nav bar add player func
    func addTapped() -> Void {
        
        let vc = AddPlayerViewController(nibName: "AddPlayerViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)

        /*if let context = DataManager.shared.objectContext {
            
            let player = Player(context: context)
            player.age = 22
            player.name = "Salut"
            
            try? context.save()
            playerArray.append(player)
            playerTableView.reloadData()
        }*/
        
    }
    
    func deletePlayer(player:Player) -> Void{
        if let context = DataManager.shared.objectContext {
            context.delete(player)
            do{
                try context.save()
            }catch{
                print("Couldn't delete player")
            }
        }

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
