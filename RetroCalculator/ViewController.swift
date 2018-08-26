import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var labelOutput: UILabel!
    var audioPlayer: AVAudioPlayer!;
    var runningNumber = ""
    var isPointAllowed = true
    
    var currentOperation: Operation = Operation.Empty
    var leftValue: String = ""
    var resultValue: String = ""
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Subtract = "-"
        case Empty = "Empty"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAudioPlayer();
    }
    
    func prepareAudioPlayer() {
        let path = Bundle.main.path(forResource: "click", ofType: "wav");
        let soundUrl = URL(fileURLWithPath: path!);
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
            audioPlayer.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription);
        }
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        updateRunningNumber(button: sender)
    }
    
    @IBAction func btnSubtractPressed(_ sender: Any) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
        processOperation(operation: .Add)
    }
    
    @IBAction func btnMultiplyPressed(_ sender: Any) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func btnDividePressed(_ sender: Any) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func btnEqaulsPressed(_ sender: Any) {
        processOperation(operation: currentOperation)
        currentOperation = .Empty
    }
    
    @IBAction func btnClearPressed(_ sender: Any) {
        runningNumber = "0"
        leftValue = ""
        currentOperation = .Empty
        labelOutput.text = "0"
    }
    
    @IBAction func btnUndoPressed(_ sender: Any) {
        if runningNumber.isEmpty || runningNumber == "0" {
            return
        }
        runningNumber = String(runningNumber.dropLast())
        labelOutput.text = runningNumber
    }
    
    func playSound() {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        audioPlayer.play()
    }
    
    func updateRunningNumber(button: UIButton) {
        if (button.tag == -1) {
            return
        }
        
        if (button.tag == 16) {
            if isPointAllowed {
                runningNumber += "."
                labelOutput.text = runningNumber
                isPointAllowed = false
            }
            return
        }
        
        if (runningNumber == "0") {
            runningNumber = "\(button.tag)"
        } else {
            runningNumber += "\(button.tag)"
        }
        
        labelOutput.text = runningNumber
    }
    
    func processOperation(operation: Operation) {
        isPointAllowed = true
        
        if (runningNumber.isEmpty) {
            return
        }
        
        if (currentOperation == .Empty) {
            currentOperation = operation
            leftValue = runningNumber
            runningNumber = ""
            return
        }
        
        showResult(operation: operation)
    }
    
    func showResult(operation: Operation) {
        if currentOperation == Operation.Multiply {
            resultValue = "\(Double(leftValue)! * Double(runningNumber)!)"
        } else if currentOperation == Operation.Divide {
            resultValue = "\(Double(leftValue)! / Double(runningNumber)!)"
        } else if currentOperation == Operation.Subtract {
            resultValue = "\(Double(leftValue)! - Double(runningNumber)!)"
        } else if currentOperation == Operation.Add {
            resultValue = "\(Double(leftValue)! + Double(runningNumber)!)"
        }
        if (Double(resultValue)?.isNaN)! || (Double(resultValue)?.isInfinite)! {
            resultValue = "0"
        }
        labelOutput.text = resultValue;
        leftValue = resultValue
        currentOperation = operation
        runningNumber = ""
    }
}

