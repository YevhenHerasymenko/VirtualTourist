//
//  VirtualTouristViewController.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 28/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import UIKit

class VirtualTouristViewController: UIViewController {

    @IBOutlet weak var rightItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions

    @IBAction func edit(sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done:")
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "edit:")
    }
    
    
}
