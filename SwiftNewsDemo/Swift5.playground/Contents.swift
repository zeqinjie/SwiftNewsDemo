import UIKit
import Foundation

var str = "Hello, playground"

/// 5.0 新特性
/*
 1. 标准 Result 型
 */
enum NetworkError: Error {
    case errorURL
}

func fetchUnreadCount(from urlString: String, completionHandler: @escaping (Result<Int, NetworkError>) -> Void)  {
    guard let url = URL(string: urlString) else {
        print("errorUrl...")
        completionHandler(.failure(.errorURL))
        return
    }

    // 此处省略复杂的网络请求
    print("Fetching \(url.absoluteString)...")
    completionHandler(.success(5))
}

fetchUnreadCount(from: "") { result in
    switch result {
    case .success(let count):
        print("\(count) 个未读信息。")
    case .failure(let error):
        print(error.localizedDescription)
    }
}

/*
2. 原始字符串
 */
/// 以下等效
let regularString = "\" Hello \" World"
let rawString = #"Hello" World"#

/// 以下等效
let regex1 = "\\\\[A-Z]+[A-Za-z]+\\.[a-z]+"
let regex2 = #"\\[A-Z]+[A-Za-z]+\.[a-z]+"#

let name = "Taylor"
let greeting = #"Hello, \#(name)!"#

/// 换行
let message = #"""
This is rendered as text: (example).
This uses string interpolation: #(example).
"""#

/*
 3. 自定义字符串插值
 */

struct User {
    var name: String
    var age: Int
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: User) {
        appendInterpolation("My name is \(value.name) and I'm \(value.age)")
    }
    
    mutating func appendInterpolation(repeat str: String, _ count: Int) {
        for _ in 0 ..< count {
            appendLiteral(str)
        }
    }
    
    mutating func appendInterpolation(
        _ values: [String], empty defaultValue: @autoclosure () -> String) {
        if values.count == 0 {
            appendLiteral(defaultValue())
        } else {
            appendLiteral(values.joined(separator: ", "))
        }
    }
}

let user = User(name: "Guybrush Threepwood", age: 33)
print("User details: \(user)")

print("Baby shark \(repeat: "doo ", 6)")

let names = ["Harry", "Ron", "Hermione"]
print("List of students: \(names, empty: "No one").")

struct HTMLComponent:
    ExpressibleByStringLiteral,
    ExpressibleByStringInterpolation,
    CustomStringConvertible {
    struct StringInterpolation: StringInterpolationProtocol {
        // 以空字符串开始
        var output = ""

        // 分配足够的空间来容纳双倍文字的文本
        init(literalCapacity: Int, interpolationCount: Int) {
            output.reserveCapacity(literalCapacity * 2)
        }

        // 一段硬编码的文本，只需添加它就可以
        mutating func appendLiteral(_ literal: String) {
            print("追加 ‘\(literal)’")
            output.append(literal)
        }

        // Twitter 用户名，将其添加为链接
        mutating func appendInterpolation(twitter: String) {
            print("追加 ‘\(twitter)’")
            output.append("<a href=\"https://twitter/\(twitter)\">@\(twitter)</a>")
        }

        // 电子邮件地址，使用 mailto 添加
        mutating func appendInterpolation(email: String) {
            print("追加 ‘\(email)’")
            output.append("<a href=\"mailto:\(email)\">\(email)</a>")
        }
    }

    // 整个组件的完整文本
    let description: String

    // 从文字字符串创建实例
    init(stringLiteral value: String) {
        description = value
    }

    // 从插值字符串创建实例
    init(stringInterpolation: StringInterpolation) {
        description = stringInterpolation.output
    }
}

let text: HTMLComponent = "你应该在 Twitter 上关注我 \(twitter: "twostraws")，或者你可以发送电子邮件给我 \(email: "paul@hackingwithswift.com")。"
print(text)

/*
 4. 自定义字符串插值
 */
/// 4.2 中新增的 @dynamicMemberLookup 注解 动态成员查找
@dynamicMemberLookup
struct DynamicMemberLookup {
    subscript (dynamicMember name: String) -> String {
        return "zhengzeqin"
    }
    subscript (dynamicMember age: String) -> Int {
        return 30
    }
    subscript (dynamicMember2 member: String) -> Int {
        return 172
    }
}
let dynamicMember = DynamicMemberLookup()
let dynamicMemberName: String = dynamicMember.name
let dynamicMemberAge: Int = dynamicMember.age
let dynamicHeight: Int = dynamicMember.height
print(dynamicMemberName, dynamicMemberAge, dynamicHeight)

@dynamicMemberLookup
enum JSON {
  case intValue(Int)
  case stringValue(String)
  case arrayValue(Array<JSON>)
  case dictionaryValue(Dictionary<String, JSON>)

  var stringValue: String? {
     if case .stringValue(let str) = self {
        return str
     }
     return nil
  }

  subscript(index: Int) -> JSON? {
     if case .arrayValue(let arr) = self {
        return index < arr.count ? arr[index] : nil
     }
     return nil
  }

  subscript(key: String) -> JSON? {
     if case .dictionaryValue(let dict) = self {
        return dict[key]
     }
     return nil
  }

  subscript(dynamicMember member: String) -> JSON? {
     if case .dictionaryValue(let dict) = self {
        return dict[member]
     }
     return nil
  }
}

let json = JSON.stringValue("Example")
let jsonResult = json[0]?["name"]?["first"]?.stringValue

@dynamicCallable
struct RandomNumberGenerator {
    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Double {
        let numberOfZeroes = Double(args.first?.value ?? 0)
        let maximum = pow(10, numberOfZeroes)
        return Double.random(in: 0...maximum)
    }
    
    
}

let random = RandomNumberGenerator()
let result = random(numberOfZeroes: 0)


/*
 5. 自定义字符串插值
 */
enum PasswordError: Error {
    case short
    case obvious
    case simple
}

func showOld(error: PasswordError) {
    switch error {
    case .short:
        print("Your password was too short.")
    case .obvious:
        print("Your password was too obvious.")
    @unknown default:
        print("Your password was too simple.")
    }
}


/*
 6. try? 嵌套可选的展平
 */
struct TryUser {
    var id: Int
    init?(id: Int) {
        if id < 1 {
            return nil
        }
        self.id = id
    }

    func getMessages() throws -> String {
        // 复杂的一段代码
        return "No messages"
    }
}

let tryUser = TryUser(id: 1)
let messages = try? tryUser?.getMessages()



/*
 7. Integer 整倍数自省
 */
let rowNumber = 4

if rowNumber.isMultiple(of: 2) {
    print("Even")
} else {
    print("Odd")
}
// if rowNumber % 2 == 0


/*
 8. compactMapValues() 转换和解包字典值
 */

let times = [
    "Hudson": "38",
    "Clarke": "42",
    "Robinson": "35",
    "Hartis": "DNF"
]

let finishers1 = times.compactMapValues { Int($0) }
//let finishers2 = times.compactMap { (key, value) -> Int in
//    return (Int(value) ?? 0)
//}

print(finishers1)


/*
 9. 被移除的特性：计算序列中的匹配项
 */

let scores = [100, 80, 85]
//let passCount = scores.count { $0 >= 85 }
let filterscores = scores.filter { $0 >= 85 }
print(filterscores)




