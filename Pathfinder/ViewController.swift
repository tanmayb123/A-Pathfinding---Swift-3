//
//  ViewController.swift
//  Pathfinder
//
//  Created by Tanmay Bakshi on 2017-01-22.
//  Copyright © 2017 Tanmay Bakshi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var nodeView: NodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func clear() {
        nodeView.clear()
    }
    
    @IBAction func pathfind() {
        nodeView.solve()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

