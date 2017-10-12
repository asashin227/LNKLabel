# LNKLabel

[![CI Status](http://img.shields.io/travis/asashin227/LNKLabel.svg?style=flat)](https://travis-ci.org/asashin227/LNKLabel)
[![Version](https://img.shields.io/cocoapods/v/LNKLabel.svg?style=flat)](http://cocoapods.org/pods/LNKLabel)
[![License](https://img.shields.io/cocoapods/l/LNKLabel.svg?style=flat)](http://cocoapods.org/pods/LNKLabel)
[![Platform](https://img.shields.io/cocoapods/p/LNKLabel.svg?style=flat)](http://cocoapods.org/pods/LNKLabel)

LNKLabel is customed UILabel that is linkable and highlighted.

## Usage

### Make linkale label
```swift
let label = LNKLabel()
label.linkPatterns = [MailPattern(), URLPattern(), PhonePattern()]
label.text = "https://github.com/asashin227/LNKLabel\n09012345678\naaa.bbb@ccc.com\nhogehogefugafuga"
label.delegate = self
label.numberOfLines = 0
label.frame.size.width = UIScreen.main.bounds.size.width
label.sizeToFit()
label.center = self.view.center
view.addSubview(label)
```

### Receive taped callback
```swift
extension YourClass: LNKLabelDelegate {
    
    func didTaped(label: LNKLabel, pattern: Pattern, matchText: String, range: NSRange) {
        switch pattern {
        case is URLPattern:
            print("taped url link: \(matchText)")
        case is MailPattern:
            print("taped mail address: \(matchText)")
        case is PhonePattern:
            print("taped phone number: \(matchText)")
        default:
            break
        }
    }
    
}
```

### Make custom link pattern
```swift
public class CustomPattern: Pattern {
    override public var regString: String {
        return "hogehoge"
    }
}
```
and add for link

```swift
label.linkPatterns?.append(CustomPattern())
```

## Installation

LNKLabel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LNKLabel'
```

## License

LNKLabel is available under the MIT license. See the LICENSE file for more info.
