import SwiftUI

// Enum di bawah ini menunjukkan setiap buttonnya
enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "/"
    case multiply = "*"
    case equal = "="
    case clear = "C"
    case decimal = "."
    case percent = "%"
    case negative = "+/-"
}

// Enum ini menunjukkan operasi apa yang akan dilakukan
enum Operation {
    case add, subtract, divide, multiply, none
}

struct ContentView: View {
    
    // Variabel state untuk menyimpan nilai tampilan saat ini, operasi saat ini, dan operand
    @State private var displayValue = "0"
    @State private var currentOperation: Operation = .none
    @State private var firstOperand = ""
    @State private var secondOperand = ""
    
    // Array yang mendefinisikan tata letak tombol kalkulator
    let buttons: [[CalcButton]] = [
        [.seven, .eight, .nine, .divide],
        [.four, .five, .six, .multiply],
        [.one, .two, .three, .subtract],
        [.clear, .zero, .decimal, .add],
        [.percent, .negative, .equal]
    ]
    
    var body: some View {
        ZStack {
            // Warna latar belakang
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    // Tampilan nilai
                    Text(displayValue)
                        .foregroundColor(.white)
                        .font(.system(size: 64))
                        .padding()
                }
                // Loop melalui array buttons untuk membuat tata letak kalkulator
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }) {
                                Text(item.rawValue)
                                    .frame(width: 70, height: 70)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .font(.system(size: 32))
                                    .cornerRadius(35)
                            }
                        }
                    }.padding(.bottom, 3)
                }
            }.padding()
        }
    }
    
    // Fungsi untuk menangani penekanan tombol
    private func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .divide, .multiply:
            if currentOperation == .none {
                // Menetapkan operasi saat ini dan menyimpan operand pertama
                currentOperation = mapButtonToOperation(button)
                firstOperand = displayValue
                displayValue = "0"
            }
        case .equal:
            if currentOperation != .none {
                // Melakukan operasi dan memperbarui nilai tampilan
                secondOperand = displayValue
                let result = performOperation()
                displayValue = "\(result)"
                currentOperation = .none
                firstOperand = ""
                secondOperand = ""
            }
        case .clear:
            // Menghapus tampilan dan mereset variabel state
            displayValue = "0"
            currentOperation = .none
            firstOperand = ""
            secondOperand = ""
        case .decimal:
            // Menambahkan titik desimal jika belum ada
            if !displayValue.contains(".") {
                displayValue += "."
            }
        case .percent:
            // Mengonversi nilai tampilan menjadi persentase
            if let value = Double(displayValue) {
                displayValue = "\(value / 100)"
            }
        case .negative:
            // Mengubah tanda nilai tampilan
            if let value = Double(displayValue) {
                displayValue = "\(-value)"
            }
        default:
            // Menambahkan angka ke nilai tampilan
            let number = button.rawValue
            if displayValue == "0" {
                displayValue = number
            } else {
                displayValue += number
            }
        }
    }
    
    // Memetakan CalcButton ke enum Operation
    private func mapButtonToOperation(_ button: CalcButton) -> Operation {
        switch button {
        case .add: return .add
        case .subtract: return .subtract
        case .divide: return .divide
        case .multiply: return .multiply
        default: return .none
        }
    }
    
    // Melakukan operasi yang dipilih pada operand
    private func performOperation() -> Double {
        guard let firstValue = Double(firstOperand),
              let secondValue = Double(secondOperand) else {
            return 0
        }
        
        switch currentOperation {
        case .add: return firstValue + secondValue
        case .subtract: return firstValue - secondValue
        case .divide: return firstValue / secondValue
        case .multiply: return firstValue * secondValue
        case .none: return 0
        }
    }
}

#Preview {
    ContentView()
}
