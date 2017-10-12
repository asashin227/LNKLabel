//
//  ViewController.swift
//  LinkLabel
//
//  Created by asashin227 on 09/13/2017.
//  Copyright (c) 2017 asashin227. All rights reserved.
//

import UIKit
import LNKLabel
import SafariServices
import MessageUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let label = LNKLabel()
        label.linkPatterns = [MailPattern(), URLPattern(), PhonePattern()]
        label.linkPatterns?.append(CustomPattern())
        label.text = "https://github.com/asashin227/LNKLabel\n09012345678\naaa.bbb@ccc.com\nhogehogefugafuga"
        label.delegate = self
        label.numberOfLines = 0
        label.frame.size.width = UIScreen.main.bounds.size.width
        label.sizeToFit()
        label.center = self.view.center
        view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController {
    func openURL(_ urlString: String) {
        guard let url = NSURL.init(string: urlString) else { return }
        
        let safari = SFSafariViewController(url: url as URL)
        self.present(safari, animated: true, completion: nil)
    }
    
    func call(phoneNumberString: String) {
        let scheme: URL = URL(string: String(format: "tel:%@", phoneNumberString))!
        UIApplication.shared.openURL(scheme)
    }
    
    func openMailUI(mailAddressString: String) {
        if !MFMailComposeViewController.canSendMail() { return }
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([mailAddressString])
        self.present(mailVC, animated: true, completion: nil)
    }
}


extension ViewController: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


extension ViewController: LNKLabelDelegate {
    
    func didTaped(label: LNKLabel, pattern: Pattern, matchText: String, range: NSRange) {
        switch pattern {
        case is URLPattern:
            openURL(matchText)
        case is MailPattern:
            openMailUI(mailAddressString: matchText)
        case is PhonePattern:
            call(phoneNumberString: matchText)
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
