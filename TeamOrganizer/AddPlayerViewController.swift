//
//  AddPlayerViewController.swift
//  TeamOrganizer
//
//  Created by Vincent Durpoix on 28/11/2016.
//  Copyright © 2016 keuwa. All rights reserved.
//

import UIKit
import CoreData

class AddPlayerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {



    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    var teamArray : [Team] = []
    
    @IBAction func addPlayer(_ sender: Any) {
        if let context = DataManager.shared.objectContext {
            
            let player = Player(context: context)
            player.age = 22
            player.name = textField.text
            player.hasTeam = teamArray[pickerView.selectedRow(inComponent: 0)]
            
            try? context.save()
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        initTable()
        // Do any additional setup after loading the view.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teamArray.count

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teamArray[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(teamArray[row].name)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTable(){
        if let context = DataManager.shared.objectContext {
            let request: NSFetchRequest = Team.fetchRequest()
            if let team = try? context.fetch(request){
                teamArray.append(contentsOf: team)
                pickerView.reloadAllComponents()
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
