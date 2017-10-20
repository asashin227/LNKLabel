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

// MARK: - Custom pattern
public class CustomPattern: Pattern {
    override public var regString: String {
        return "hogehoge"
    }
}

// MARK: - ViewController
class ViewController: UIViewController {
    lazy var linkLabel: LNKLabel = {
        let label = LNKLabel()
        label.linkColor = .red
        label.linkPatterns = [MailPattern(), URLPattern(), PhonePattern()]
        label.linkPatterns?.append(CustomPattern())
        label.text = "https://github.com/asashin227/LNKLabel\n09012345678\naaa.bbb@ccc.com\nhogehogefugafuga"
        label.delegate = self
        label.numberOfLines = 0
        label.frame.size.width = UIScreen.main.bounds.size.width
        label.sizeToFit()
        
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        linkLabel.center = self.view.center
        self.view.addSubview(linkLabel)
        
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: linkLabel)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension ViewController {
    func getSafariViewController(with urlString: String) -> SFSafariViewController? {
        guard let url = NSURL.init(string: urlString) else { return nil }
        let safari = SFSafariViewController(url: url as URL)
        return safari
    }
    func getMailViewController(with toAddress: String) -> MFMailComposeViewController? {
        if !MFMailComposeViewController.canSendMail() { return nil }
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([toAddress])
        return mailVC
    }
}
extension ViewController {
    
    func openURL(_ urlString: String) {
        guard let safari = getSafariViewController(with: urlString) else { return }
        self.present(safari, animated: true, completion: nil)
    }
    
    func call(phoneNumberString: String) {
        let scheme: URL = URL(string: String(format: "tel:%@", phoneNumberString))!
        UIApplication.shared.openURL(scheme)
    }
    
    func openMailUI(mailAddressString: String) {
        guard let mailVC = getMailViewController(with: mailAddressString) else { return }
        self.present(mailVC, animated: true, completion: nil)
    }
}

// MARK: - LNKLabelDelegate
extension ViewController: LNKLabelDelegate {
    
    func didTaped(label: LNKLabel, pattern: Pattern, matchText: String, range: NSRange) {
        switch pattern {
        case is URLPattern:
            print("taped url: \(matchText)")
            openURL(matchText)
        case is MailPattern:
            print("taped mail address: \(matchText)")
            openMailUI(mailAddressString: matchText)
        case is PhonePattern:
            print("taped phone number: \(matchText)")
            call(phoneNumberString: matchText)
        default:
            print("taped custom pattern: \(matchText)")
        }
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate
extension ViewController: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


// MARK: - UIViewControllerPreviewingDelegate
extension ViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let hitLink = linkLabel.hitLink(at: location) else { return nil }
        
        switch hitLink.pattern {
        case is URLPattern:
            guard let safari = getSafariViewController(with: hitLink.touchedText) else { return nil }
            return safari
        case is MailPattern:
            guard let mailVC = getMailViewController(with: hitLink.touchedText) else { return nil }
            return mailVC
        default:
            return nil
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.present(viewControllerToCommit, animated: true)
    }
}
