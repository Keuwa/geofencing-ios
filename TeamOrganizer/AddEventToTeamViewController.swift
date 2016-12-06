//
//  AddEventToTeamViewController.swift
//  TeamOrganizer
//
//  Created by Vincent Durpoix on 01/12/2016.
//  Copyright © 2016 keuwa. All rights reserved.
//

import UIKit
import CoreData
class AddEventToTeamViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var eventTableView: UITableView!

    var eventArray:[Event] = []
    var team : Team! ;
    var cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addEvents))
        self.navigationItem.rightBarButtonItem = button;
        

        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.allowsMultipleSelectionDuringEditing = true

        // Do any additional setup after loading the view.
    }

    func addEvents(){
        var events:[Event] = []
        for cell in eventTableView.visibleCells{
            if(cell.accessoryType == UITableViewCellAccessoryType.checkmark){
                events.append(eventArray[(eventTableView.indexPath(for: cell)?.row)!])
            }
        }
        addEventToTeam(events: events)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initTable()
        self.title = "Ajouter un événement"
    }
    
    func addEventToTeam(events: [Event]){
        if let context = DataManager.shared.objectContext {
            if let teamObjectInBase = context.object(with: team.objectID) as? Team{
                for event in events{
                    teamObjectInBase.events! = teamObjectInBase.events!.adding(event) as NSSet// as NSSet
                }
                print(teamObjectInBase.events ?? "fail")
            }
        try? context.save()
        }

    }
    
    func initTable(){
        if let context = DataManager.shared.objectContext {
            let request: NSFetchRequest = Event.fetchRequest()
            //request.predicate = NSPredicate(format: "NOT (teams CONTAINS %@)", team)
            //request.predicate = NSPredicate(format: "NOT ( teams CONTAINS %@)", team)
            if let events = try? context.fetch(request){
                eventArray = []
                eventArray.append(contentsOf: events)
                eventTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        // Adding the right informations
        cell.textLabel?.text = self.eventArray[indexPath.row].name;
        
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
