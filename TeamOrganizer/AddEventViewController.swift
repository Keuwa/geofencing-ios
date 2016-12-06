//
//  AddEventViewController.swift
//  TeamOrganizer
//
//  Created by Vincent Durpoix on 29/11/2016.
//  Copyright © 2016 keuwa. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var lonTextField: UITextField!
    @IBOutlet weak var buttonTextField: UIButton!
    
    weak var delegate: AddEventViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nav = self.tabBarController?.viewControllers?[0] as! UINavigationController
        
        delegate = nav.viewControllers[0] as! TeamListViewController
        self.title = "Ajouter un événement"

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addEventTaped(_ sender: Any) {
        if let context = DataManager.shared.objectContext {
            let lat = Double(latTextField.text!)
            let lon = Double(lonTextField.text!)
            let event = Event(context: context)
            event.name = nameTextField.text
            event.lat = lat!
            event.lon = lon!
            
            try? context.save()
        }
        delegate?.addEventToMonitorByDelegate()
        self.navigationController?.popToRootViewController(animated: true)
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

protocol AddEventViewControllerDelegate: class {
    
    func addEventToMonitorByDelegate()
}
