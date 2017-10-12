//
//  ViewController.swift
//  LinkLabel
//
//  Created by asashin227 on 09/13/2017.
//  Copyright (c) 2017 asashin227. All rights reserved.
//

import UIKit
import LNKLabel

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let label = LNKLabel()
        label.linkPatterns = [MailPattern(), URLPattern(), PhonePattern(), CustomPattern()]
        label.text = "https://github.com/asashin227/LinkLabel\nfugafuga09012345678\naaa.bbb@ccc.com\nhogehogefugafuga"
        label.delegate = self
        label.numberOfLines = 0
        label.frame.size.width = UIScreen.main.bounds.size.width
        label.sizeToFit()
        label.center = self.view.center
        print(label.text ?? "")
        view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension ViewController: LNKLabelDelegate {
    
    func didTaped(label: LNKLabel, pattern: Pattern, matchText: String, range: NSRange) {
        switch pattern {
        case is URLPattern:
            print("taped url link: \(matchText)")
        case is MailPattern:
            print("taped mail address: \(matchText)")
        case is PhonePattern:
            print("taped phone number: \(matchText)")
        default:
            print("taped custom pattern: \(matchText)")
        }
    }
    
}


public class CustomPattern: Pattern {
    override public var regString: String {
        return "hogehoge"
    }
}
