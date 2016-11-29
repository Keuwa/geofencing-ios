//
//  TeamListViewController.swift
//  TeamOrganizer
//
//  Created by Vincent Durpoix on 23/11/2016.
//  Copyright © 2016 keuwa. All rights reserved.
//

import UIKit
import CoreData

class TeamListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var teamTableView: UITableView!
    
    var teamArray: [Team] = []
    let cellIdentifier = "ElementCell"

    override func viewWillAppear(_ animated: Bool) {
        initTable()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addTapped))
        
        self.navigationItem.rightBarButtonItem = button;
        
        
        teamTableView.delegate = self
        teamTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initTable(){
        if let context = DataManager.shared.objectContext {
            let request: NSFetchRequest = Team.fetchRequest()
            if let team = try? context.fetch(request){
                teamArray = []
                teamArray.append(contentsOf: team)
                teamTableView.reloadData()
            }
        }
    }
    
///DELETE FUNCTIONS
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            deleteTeam(team: teamArray[indexPath.row])
            teamArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    func deleteTeam(team:Team) -> Void{
        if let context = DataManager.shared.objectContext {
            context.delete(team)
            do{
                try context.save()
            }catch{
                print("Couldn't delete player")
            }
        }
        
    }
    
    
    
    ///LIST INIT FUNCTION
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
    
    // Adding the right informations
        cell.textLabel?.text = self.teamArray[indexPath.row].name;
    
    // Returning the cell
        return cell
    
    }

    
    
//Nav bar add player func
    func addTapped() -> Void {
        
        var loginTextField: UITextField?
        let alertController = UIAlertController(title: "Création de l'équipe", message: "Rentrez votre nom d'équipe", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            self.addTeam(name: (loginTextField?.text)!);
            
        })
        let cancel = UIAlertAction(title: "Annuler", style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) -> Void in
            // Enter the textfiled customization code here.
            loginTextField = textField
            loginTextField?.placeholder = "Nom de l'équipe"
        }
        present(alertController, animated: true, completion: nil)
    }

    func addTeam(name:String) {
        if let context = DataManager.shared.objectContext {
            let team = Team(context: context)
            team.name = name
            
            try? context.save()
            teamArray.append(team)
            teamTableView.reloadData()
        }
    }

}
