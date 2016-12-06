//
//  AddPlayerToTeamViewController.swift
//  TeamOrganizer
//
//  Created by Vincent Durpoix on 06/12/2016.
//  Copyright © 2016 keuwa. All rights reserved.
//

import UIKit
import CoreData

class AddPlayerToTeamViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var playerArray:[Player] = []
    var team : Team! ;
    var cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addPlayers))
        self.navigationItem.rightBarButtonItem = button;
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        
        // Do any additional setup after loading the view.
    }
    
    func addPlayers(){
        var players:[Player] = []
        for cell in tableView.visibleCells{
            if(cell.accessoryType == UITableViewCellAccessoryType.checkmark){
                players.append(playerArray[(tableView.indexPath(for: cell)?.row)!])
            }
        }
        addPlayerToTeam(players: players)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initTable()
        self.title = "Ajouter un événement"
    }
    
    func addPlayerToTeam(players: [Player]){
        if let context = DataManager.shared.objectContext {
            if let teamObjectInBase = context.object(with: team.objectID) as? Team{
                for player in players{
                    teamObjectInBase.hasPlayer! = teamObjectInBase.hasPlayer!.adding(player) as NSSet// as NSSet
                }
                print(teamObjectInBase.hasPlayer ?? "fail")
            }
            try? context.save()
        }
        
    }
    
    func initTable(){
        if let context = DataManager.shared.objectContext {
            let request: NSFetchRequest = Player.fetchRequest()
            //request.predicate = NSPredicate(format: "NOT (teams CONTAINS %@)", team)
            //request.predicate = NSPredicate(format: "NOT ( teams CONTAINS %@)", team)
            if let players = try? context.fetch(request){
                playerArray = []
                playerArray.append(contentsOf: players)
                tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        // Adding the right informations
        cell.textLabel?.text = self.playerArray[indexPath.row].name;
        
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            
            cell!.accessoryType = UITableViewCellAccessoryType.none;
            
        }else{
            
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark;
            
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
