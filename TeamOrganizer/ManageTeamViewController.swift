//
//  ManageTeamViewController.swift
//  TeamOrganizer
//
//  Created by Vincent Durpoix on 29/11/2016.
//  Copyright © 2016 keuwa. All rights reserved.
//

import UIKit
import CoreData

class ManageTeamViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var eventTableView: UITableView!
    
    var team:Team?;
    
    var playerArray:[Player] = []
    var eventArray:[Event] = []

    let cellIdentifier1 = "ElementCell1"
    let cellIdentifier2 = "ElementCell2"

    //Todo init tables
    
    func initTable(){
        reloadTeam()
        playerArray = team?.hasPlayer?.allObjects as! [Player]
        eventArray = team?.events?.allObjects as! [Event]

        /*if let context = DataManager.shared.objectContext {
            let request: NSFetchRequest = Player.fetchRequest()
            request.predicate = NSPredicate(format: "hasTeam == %@", team!)
            if let player = try? context.fetch(request){
                playerArray = []
                playerArray.append(contentsOf: player)
                playerTableView.reloadData()
            }
        }
        if let context = DataManager.shared.objectContext {
            let request: NSFetchRequest = Event.fetchRequest()
            request.predicate = NSPredicate(format: "ANY teams != %@", team!)
            if let event = try? context.fetch(request){
                eventArray = []
                eventArray.append(contentsOf: event)
                eventTableView.reloadData()
            }
        }*/
    }
    
    func reloadTeam(){
        if let context = DataManager.shared.objectContext {
            if let teamObjectInBase = context.object(with: (team?.objectID)!) as? Team{
                //print(team?.events)
                self.team?.events = teamObjectInBase.events
                //print(team?.events)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initTable()
        self.title = team?.name
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addTapped))
        
        //self.navigationItem.rightBarButtonItem = button;
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
        playerTableView.delegate = self
        playerTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == playerTableView){
            return playerArray.count
        }else{
            return eventArray.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == playerTableView){
            let cell = playerTableView.dequeueReusableCell(withIdentifier: cellIdentifier1)
                ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier1)
            
            cell.textLabel?.text = self.playerArray[indexPath.row].name;
            return cell
        }else{
            let cell = eventTableView.dequeueReusableCell(withIdentifier: cellIdentifier2)
                ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier2)
            
            cell.textLabel?.text = self.eventArray[indexPath.row].name;
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if(tableView == playerTableView){
                deletePlayer(player: playerArray[indexPath.row])
                playerArray.remove(at: indexPath.row)
            }
            else{
                deleteEvent(event: eventArray[indexPath.row])
                eventArray.remove(at: indexPath.row)
            }
            
            tableView.reloadData()
        }
    }
    func deletePlayer(player:Player) -> Void{
        
        if let context = DataManager.shared.objectContext {
            if let playerObjectInBase = context.object(with: (team?.objectID)!) as? Team{
                let newSet = playerObjectInBase.hasPlayer as! NSMutableSet
                newSet.remove(player)
                playerObjectInBase.hasPlayer! = newSet
            }
            try? context.save()
        }

        
    }
    func deleteEvent(event:Event) -> Void{
        
        if let context = DataManager.shared.objectContext {
            if let teamObjectInBase = context.object(with: (team?.objectID)!) as? Team{
                let newSet = teamObjectInBase.events as! NSMutableSet
                newSet.remove(event)
                teamObjectInBase.events! = newSet
            }
            try? context.save()
        }
        
    }

    @IBAction func addEventToTeam(_ sender: Any) {
        let vc = AddEventToTeamViewController(nibName: "AddEventToTeamViewController", bundle: nil)
        vc.team = team
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func addPlayerToTeam(_ sender: Any) {
        let vc = AddPlayerToTeamViewController(nibName: "AddPlayerToTeamViewController", bundle: nil)
        vc.team = team
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
