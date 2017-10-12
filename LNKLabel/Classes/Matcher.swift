//
//  Matcher.swift
//  FBSnapshotTestCase
//
//  Created by Asakura Shinsuke on 2017/10/11.
//

extension Range where Bound == String.Index {
    static func `init`(from text: String, nsRange: NSRange) throws -> Range {
        guard let from16 = text.utf16.index(text.utf16.startIndex, offsetBy: nsRange.location, limitedBy: text.utf16.endIndex),
            let to16 = text.utf16.index(from16, offsetBy: nsRange.length, limitedBy: text.utf16.endIndex),
            let from = from16.samePosition(in: text),
            let to = to16.samePosition(in: text) else {
                // TODO: エラーちゃんと書く
                throw NSError(domain: Bundle.main.bundleIdentifier!, code: -9999, userInfo: [NSLocalizedDescriptionKey : ""])
        }
        return from ..< to
    }
}

struct  Matcher {
    var text: String? {
        didSet {
            searchMatches()
        }
    }

    var patterms: [Pattern]? {
        didSet {
            searchMatches()
        }
    }
    var matches: [Pattern : [(String, NSRange)]] = [:]
    
    private mutating func searchMatches() {
        guard let patterms = patterms, let text = text else { return }
        do {
            matches = [:]
            for pattern in patterms {
                guard let match = try search(text: text, pattern: pattern.regString) else { continue }
                matches[pattern] = match
            }
        } catch {
            // TODO: エラーちゃんと書く
        }
    }
    private func search(text: String, pattern: String) throws -> [(String, NSRange)]? {
        if text.isEmpty { return nil }
        
        let regularExp = try NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
        let nsstring = text as NSString
        let maches = regularExp.matches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: nsstring.range(of: nsstring as String))
        var resultArr = [(String, NSRange)]()
        for match in maches {
            let range = try Range<String.Index>.init(from: text, nsRange: match.range)
            resultArr.append((String(text[range]), match.range))
        }
        return resultArr
        
    }
}

