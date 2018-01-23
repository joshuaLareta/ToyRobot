//
//  RootViewController.swift
//  ToyRobot
//
//  Created by Joshua on 23/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    // RootViewControllers elements
    var commandLabel: UILabel = {
        let tempCommandLabel = UILabel()
        tempCommandLabel.translatesAutoresizingMaskIntoConstraints = false
        tempCommandLabel.font = UIFont.systemFont(ofSize: 15)
        tempCommandLabel.text = NSLocalizedString("Command:", comment: "Command title")
        tempCommandLabel.textColor = .black
        return tempCommandLabel
    }()
    
    var commandTextfield: UITextField = {
        let tempCommandTextfield = UITextField()
        tempCommandTextfield.translatesAutoresizingMaskIntoConstraints = false
        tempCommandTextfield.font = UIFont.systemFont(ofSize: 18)
        tempCommandTextfield.textAlignment = .left
        
        // stylize the placeholder using attributed string
        tempCommandTextfield.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("what is your instruction (i.e. PLACE 1,1,NORTH)", comment: "placeholder for the textfield"), attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13)])
        
        // add a bottom line for the textfield
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 49, width:(UIScreen.main.bounds.width-105), height: 0.5)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        tempCommandTextfield.layer.addSublayer(bottomLine)
        return tempCommandTextfield
    }()
    
    var executeButton: UIButton = {
        let tempExecuteButton = UIButton(type: .custom)
        tempExecuteButton.translatesAutoresizingMaskIntoConstraints = false
        tempExecuteButton.setTitle(NSLocalizedString("Execute", comment: "Execute buttont title"), for: .normal)
        tempExecuteButton.setTitleColor(UIColor.black, for: .normal)
        tempExecuteButton.setTitleColor(UIColor.gray, for: .highlighted)
        tempExecuteButton.addTarget(self, action: #selector(RootViewController.executeButtonAction), for: .touchUpInside)
        tempExecuteButton.clipsToBounds = true
        
        // add layer effects to highlight the button
        tempExecuteButton.layer.borderColor = UIColor.darkGray.cgColor
        tempExecuteButton.layer.borderWidth = 1
        tempExecuteButton.layer.cornerRadius = 5
        return tempExecuteButton
    }()
    
    // lazily load the rootManager with a given table as required
    lazy var manager: RootManager = {
        let tempManager = RootManager(withTable: Table(minX: 0, minY: 0, maxX: 5, maxY: 5)) // initalize a table with a 5 x 5 dimension and starts at 0,0 point
        return tempManager
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(commandLabel)
        view.addSubview(commandTextfield)
        view.addSubview(executeButton)
        setupConstraints()
    }
    
    
    // private function for setting up the constraints of the view
    private func setupConstraints () {
        // setup Horizontal constraints for command label and command textfield
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[commandLabel(==85)][commandTextfield]-10-|", options: [], metrics: nil, views: ["commandLabel": commandLabel,
                                                                                                                      "commandTextfield": commandTextfield]))
        // setup Horizontal constraints for execute button
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[executeButton(==100)]", options: [], metrics: nil, views: ["executeButton": executeButton]))
        // additional constraints to horizontally center the execute button
        view.addConstraint(NSLayoutConstraint(item: executeButton, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        // setup command label vertical constraints
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[commandLabel(==50)]", options: [], metrics: nil, views:["commandLabel": commandLabel]))
        // setup command textfield vertical constraints
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[commandTextfield(==50)]", options: [], metrics: nil, views:["commandTextfield": commandTextfield]))
        
        // setup vertical constraints for execute button
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[commandTextfield]-10-[executeButton(==50)]", options: [], metrics: nil, views: ["commandTextfield": commandTextfield, "executeButton": executeButton]))
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Button action
    
    @objc func executeButtonAction () {
        // only call manager when execute command is pressed
        print ("trying to execute command \(commandTextfield.text ?? "")")
        manager.executeCommand(commandTextfield.text) { [weak self] (commandResponse, error) in
            guard error == nil else {
                // theres an error alert the user
                if let errorMessage = error?.localizedDescription {
                    self?.showAlert(withTitle: NSLocalizedString("Error", comment: "title of the error alert"), andMessage: errorMessage)
                     print("error: \(errorMessage)")
                } else {
                    print ("error message was empty")
                }
                return // return as there is nothing else to do here
            }
            
            // must check if response has a value before proceeding
            guard let response = commandResponse else {
               // do nothing as there was no relevant response and its not an issue
                return
            }
            
            if response.shouldBeDisplayed == true {
                self?.showAlert(withTitle: NSLocalizedString("Report", comment: "Update Title alert"), andMessage: response.responseString)
            }else {
                if let responseString = response.responseString {
                    print (responseString)
                }
            }
        }
        // clean the textfield
        commandTextfield.text = nil
    }
    
    // function to show an alert when required
    private func showAlert(withTitle title: String?, andMessage message: String?) {
        // make sure that when we call an alert it will be on the main thread
        if Thread.isMainThread == true {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Alert action OK button"), style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            self .present(alertController, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(withTitle: title, andMessage: message) // just call it on the main thread
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

