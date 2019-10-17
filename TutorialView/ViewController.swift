//
//  ViewController.swift
//  TutorialView
//
//  Created by Konstantin Nazarenkov on 9/4/19.
//  Copyright © 2019 Konstantin Nazarenkov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var coloredSquare: UIView!
    @IBOutlet weak var actionButton: UIButton!
    
    private lazy var tutoralView = CRTutorialView(frame: self.view.frame)

    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: { [weak self] in
            guard let self = self else { return }
            self.coloredSquare.backgroundColor = .green
        })
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        tutoralView.configure(.targets([(firstLabel, "firstLabel"),
                                        (secondLabel, "secondLabel with long long long text ye, really long text here"),
                                        (coloredSquare, "coloredSquare text here is needed"),
                                        (actionButton, "actionButton"),
                                        (thirdLabel, "One more for testing asldn asjkdh ajsdjkasdkasdjkasjkd aksd jkashdjkasdjkasjkd asdhaksdhjkas asdkasjkd asjdhh")])
                              )
        tutoralView.show()
    }
    
}

