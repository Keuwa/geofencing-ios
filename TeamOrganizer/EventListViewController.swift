//
//  EventListViewController.swift
//  TeamOrganizer
//
//  Created by Vincent Durpoix on 23/11/2016.
//  Copyright © 2016 keuwa. All rights reserved.
//

import UIKit
import CoreData

class EventListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var eventTableView: UITableView!
    var eventArray:[Event] = []
    let cellIdentifier = "ElementCell"
    
    
    override func viewWillAppear(_ animated: Bool) {
        initTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addTapped))
        
        self.navigationItem.rightBarButtonItem = button;
        self.title = "Événements"
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initTable(){
        if let context = DataManager.shared.objectContext {
            let request: NSFetchRequest = Event.fetchRequest()
            if let events = try? context.fetch(request){
                eventArray = []
                eventArray.append(contentsOf: events)
                eventTableView.reloadData()
            }
        }
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
        
        cell.textLabel?.text = self.eventArray[indexPath.row].name;
        
        return cell
    }
    
    func addTapped() -> Void {
        
        let vc = AddEventViewController(nibName: "AddEventViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            deleteEvent(event: eventArray[indexPath.row])
            eventArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    func deleteEvent(event:Event) -> Void{
        if let context = DataManager.shared.objectContext {
            context.delete(event)
            do{
                try context.save()
            }catch{
                print("Couldn't delete event")
            }
        }
        
    }

}
