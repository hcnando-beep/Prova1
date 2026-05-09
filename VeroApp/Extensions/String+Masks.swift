import Foundation

extension String {
    func cpfMasked() -> String {
        let digits = self.filter(\.isNumber)
        var result = ""
        for (i, char) in digits.prefix(11).enumerated() {
            if i == 3 || i == 6 { result += "." }
            if i == 9 { result += "-" }
            result.append(char)
        }
        return result
    }

    func phoneMasked() -> String {
        let digits = self.filter(\.isNumber)
        var result = ""
        for (i, char) in digits.prefix(11).enumerated() {
            if i == 0 { result += "(" }
            if i == 2 { result += ") " }
            if digits.count == 11 && i == 7 { result += "-" }
            if digits.count <= 10 && i == 6 { result += "-" }
            result.append(char)
        }
        return result
    }

    func cepMasked() -> String {
        let digits = self.filter(\.isNumber)
        var result = ""
        for (i, char) in digits.prefix(8).enumerated() {
            if i == 5 { result += "-" }
            result.append(char)
        }
        return result
    }

    func rgMasked() -> String {
        let digits = self.filter(\.isNumber)
        var result = ""
        for (i, char) in digits.prefix(9).enumerated() {
            if i == 2 || i == 5 { result += "." }
            if i == 8 { result += "-" }
            result.append(char)
        }
        return result
    }

    var digitsOnly: String { self.filter(\.isNumber) }
}
