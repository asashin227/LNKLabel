//
//  Pattern.swift
//  FBSnapshotTestCase
//
//  Created by Asakura Shinsuke on 2017/10/11.
//

public protocol Patternable: Hashable {
    var regString: String { get }
}
public extension Patternable {

    var hashValue: Int {
        return self.regString.hashValue
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.regString == rhs.regString
    }
}

open class Pattern: NSObject, Patternable {
    open var regString: String {
        return ""
    }
}

public class MailPattern: Pattern {
    override public var regString: String {
        return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
}

public class URLPattern: Pattern {
    override public var regString: String {
        return "(http://|https://){1}[\\w\\.\\-/:=\\?]+"
    }
}

public class PhonePattern: Pattern {
    override public var regString: String {
        return "([0-9]{2,4}-[0-9]{2,4}-[0-9]{3,4})|([0-9]{11})|([+0-9]{13})|([+0-9]{2,5}-[0-9]{2,4}-[0-9]{2,4}-[0-9]{3,4})"
    }
}
