import Foundation

enum ValidationService {
    static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    static func isValidCPF(_ cpf: String) -> Bool {
        let numbers = cpf.filter(\.isNumber)
        guard numbers.count == 11, Set(numbers).count != 1 else { return false }
        let digits = numbers.compactMap { Int(String($0)) }

        func check(_ len: Int) -> Bool {
            let sum = (0..<len).reduce(0) { $0 + digits[$1] * (len + 1 - $1) }
            let rem = sum % 11
            return digits[len] == (rem < 2 ? 0 : 11 - rem)
        }
        return check(9) && check(10)
    }

    static func isValidPhone(_ phone: String) -> Bool {
        let n = phone.filter(\.isNumber).count
        return n >= 10 && n <= 11
    }

    static func isValidCEP(_ cep: String) -> Bool {
        cep.filter(\.isNumber).count == 8
    }
}
