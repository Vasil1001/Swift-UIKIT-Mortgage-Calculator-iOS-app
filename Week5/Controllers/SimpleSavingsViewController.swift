//
//  SimpleSavingsViewController.swift
//  FinanceAppCW1
//
//  Created by Vasil Dzhakov on 07/03/2022.
//

import UIKit

class SimpleSavingsViewController: UIViewController {
    
    
    
    @IBAction func intructionsPopUp(_ sender: UIButton) {
        popUpAlert(message: "Fill in 3 out of 4 fields, leave the field you wish to calculate empty and press the 'Calulate' button. \n\nInterest can be calculated in this instance. \n\nThe monthly payment is a fixed amount for the amount of payments selected. \n\nUse the switch to type in years instead of months for payments!", title: "Instructions\n")
    }
    
    // Set fixed placeholder text(£,%,Duration) inside all textfields from
    // https://stackoverflow.com/questions/52016838/swift-textfield-inside-left-side-add-icon
    //Works by creating a new UILabel(), setting a value to it and positioning it to the leftView of the textfield
    
    @IBOutlet weak var textPrincipalAmount: UITextField! {
        didSet{
            let staticMoneySignLabel1 = UILabel()
            staticMoneySignLabel1.text = " £ "
            staticMoneySignLabel1.sizeToFit()
            textPrincipalAmount.leftView = staticMoneySignLabel1
            textPrincipalAmount.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    
    
    let staticInterestLabel = UILabel()
    @IBOutlet weak var textInterestRate: UITextField!{
        didSet{
            let staticLabel = UILabel()
            staticLabel.text = " % "
            staticLabel.sizeToFit()
            textInterestRate.leftView = staticLabel
            textInterestRate.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    
    @IBOutlet weak var textFutureValue: UITextField!{
        didSet{
            let staticMoneySignLabel2 = UILabel()
            
            staticMoneySignLabel2.text = " £ "
            staticMoneySignLabel2.sizeToFit()
            textFutureValue.leftView = staticMoneySignLabel2
            textFutureValue.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    
    
    @IBOutlet weak var textNumberOfPayments: UITextField!{
        didSet{
            let durationLabel = UILabel()
            durationLabel.text = " Duration: "
            durationLabel.sizeToFit()
            textNumberOfPayments.leftView = durationLabel
            textNumberOfPayments.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var switchYears: UISwitch!
    
    @IBOutlet weak var labelNumberOfPayments: UILabel!
    @IBOutlet weak var labelShowSwitch: UILabel!
    
    // From week5/6 lab
    // set all textfields in view to 1, dismiss keyboard on click outside of textfield
    //keyboard also set to numpad only
    @IBAction func tapGestureKBDismissAction(_ sender: UITapGestureRecognizer) {
        if ((self.view.viewWithTag(1)?.isFirstResponder) != nil)
        {
            textPrincipalAmount.resignFirstResponder()
            textInterestRate.resignFirstResponder()
            textFutureValue.resignFirstResponder()
            textNumberOfPayments.resignFirstResponder()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //listen for the notification the app moved to the background
        
        // Lab 3 Colorpicker example used to declare defaults and set them for when app is closed or in background
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        let defaults = UserDefaults.standard
        
        let principalAmountSavings = defaults.string(forKey: "principalAmountSavings")
        let interestRatePercentSavings = defaults.string(forKey: "interestRatePercentSavings")
        let futureValueSavings = defaults.string(forKey: "futureValueSavings")
        let numberOfPaymentsSavings = defaults.string(forKey: "numberOfPaymentsSavings")
        
        textPrincipalAmount.text = principalAmountSavings
        textInterestRate.text = interestRatePercentSavings
        textFutureValue.text = futureValueSavings
        textNumberOfPayments.text = numberOfPaymentsSavings
    }
    
    // Lab 3 Colorpicker example used to declare defaults and set them for when app is closed or in background
    @objc   func appMovedToBackground()
    {
        print("backgrounded or closed")
        
        let defaults = UserDefaults.standard
        
        let principalAmountSavings = textPrincipalAmount.text
        defaults.set(principalAmountSavings, forKey: "principalAmountSavings")
        
        let interestRatePercentSavings = textInterestRate.text
        defaults.set(interestRatePercentSavings, forKey: "interestRatePercentSavings")
        
        let futureValueSavings = textFutureValue.text
        defaults.set(futureValueSavings, forKey: "futureValueSavings")
        
        let numberOfPaymentsSavings = textNumberOfPayments.text
        defaults.set(numberOfPaymentsSavings, forKey: "numberOfPaymentsSavings")
    }
    
    //Switch toggle state for .months or .years calculations
    enum switchState {
        case months
        case years
    }
    
    //set starting state at months, e.g. user can enter 24 for 2 years
    var paymentValueState: switchState? = .months
    
    @IBAction func switchYearsAction(_ sender: UISwitch) {
        
        if (textInterestRate.text  == "") {
            popUpAlert(message: "Interest cannot be calculated while there are monthly payments. Please enter a value for interest.", title: "Alert")
            return
        } else if checkTextfieldInput() == 3 {
            resultOnEmptyField()
        } else if checkTextfieldInput() == 4 {
            resultOnEmptyField() //no popup just switch years
        } else if checkTextfieldInput() == 0 {
            popUpAlert(message: "Please fill out 3 fields to calculate a result", title: "Alert")
        } else {
            popUpAlert(message: "Please fill out 3 fields to calculate a result", title: "Alert")
        }
        
        if sender.isOn {
            textNumberOfPayments.text = ""
            
            labelShowSwitch.text = "Show months"
            labelNumberOfPayments.text = "Number of Payments (months)"
            paymentValueState = .months
            resultOnEmptyField()
        } else {
            textNumberOfPayments.text = ""
            
            labelShowSwitch.text = "Show years"
            labelNumberOfPayments.text = "Number of Payments (years)"
            paymentValueState = .years
            resultOnEmptyField()
        }
    }
    
    @IBAction func calculateButton(_ sender: UIButton) {
        if checkTextfieldInput() == 3 {
            resultOnEmptyField()
        } else if checkTextfieldInput() == 4 {
            popUpAlert(message: "Please leave the field you want to calculate empty", title: "Alert")
        } else if checkTextfieldInput() == 0 {
            popUpAlert(message: "Please fill out 3 fields to calculate a result", title: "Alert")
        } else {
            popUpAlert(message: "Please fill out 3 fields to calculate a result", title: "Alert")
        }
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        resetFields()
    }
    
    //Create alert on screen for wrong inputs from:
    //https://www.ioscreator.com/tutorials/display-alert-ios-tutorial#:~:text=Go%20to%20the%20Storyboard%20and,bottom%2Dright%20of%20the%20Storyboard.
    func popUpAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Check how many fields are not empty
    func checkTextfieldInput() -> Int {
        var fields = 0
        
        if !(textPrincipalAmount.text?.isEmpty)! {
            fields += 1
        }
        if !(textFutureValue.text?.isEmpty)! {
            fields += 1
        }
        if !(textInterestRate.text?.isEmpty)! {
            fields += 1
        }
        if !(textNumberOfPayments.text?.isEmpty)! {
            fields += 1
        }
        
        return fields
    }
    
    // FROM BRIEF - Refer to following declaration meanings
    // Solve for the following parameters
    //        t – time in years (synonymous with number of payments)
    //        r (%) – interest rate – for simple savings only where there is no monthly payments
    //        P – present value
    //        PMT – Payment
    //        A – future value
    
    //Other parameters
    //        PayPY – number of payments per year (always assumed to be 12)
    //        CpY – number of compound payments per year (always assumed to be 12)
    //        PmtAt – payment due at the beginning or end of each period (assumed to be END
    
    func resultOnEmptyField() {
        
        let t = Double(textNumberOfPayments.text!)
        let r = Double(textInterestRate.text!)
        let P = Double(textPrincipalAmount.text!)
        let A = Double(textFutureValue.text!)
        
        let CpY = 12.0 //12 Payments
        
        var resultEmptyField: Double = 0.0
        // Check for every field if its empty, output result in empty field, which is 'var resultEmptyField'
        // if it is, use the correct formula to display a result in resultEmptyField
        
        if (textPrincipalAmount.text?.isEmpty)! { //text? - might be empty or not, also ! unwraps value
            if paymentValueState == .months{
                do {
                    try resultEmptyField = formulaPrincipalAmountMonthly(futureValue: A!, interest: r!, compoundInterestPerYear12: CpY, numberOfPayments: t!)
                    textPrincipalAmount.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }else if paymentValueState == .years{
                do{
                    try resultEmptyField = formulaPrincipalAmountYearly(futureValue: A!, interest: r!, compoundInterestPerYear12: CpY, numberOfPayments: t!)
                    textPrincipalAmount.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }
        }
        
        if (textFutureValue.text?.isEmpty)! {
            if paymentValueState == .months{
                do {
                    try resultEmptyField = formulaFutureValueMonthly(principalValue: P!, interest: r!, compoundInterestPerYear12: CpY, numberOfPayments: t!)
                    textFutureValue.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }else if paymentValueState == .years{
                do{
                    try resultEmptyField = formulaFutureValueYearly(principalValue: P!, interest: r!, compoundInterestPerYear12: CpY, numberOfPayments: t!)
                    textFutureValue.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }
        }
        
        //Number of payments
        if (textNumberOfPayments.text?.isEmpty)! {
            if paymentValueState == .months{
                do {
                    try resultEmptyField = formulaNumberOfPaymentsMonthly(principalValue: P!, futureValue: A!, compoundInterestPerYear12: CpY, interest: r!)
                    textNumberOfPayments.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }else if paymentValueState == .years{
                do{
                    try resultEmptyField = formulaNumberOfPaymentsYearly(principalValue: P!, futureValue: A!, compoundInterestPerYear12: CpY, interest: r!)
                    textNumberOfPayments.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }
        }
        
        if (textInterestRate.text?.isEmpty)! {
            if paymentValueState == .months{
                do {
                    try resultEmptyField = formulaInterestRateMonthly(principalValue: P!, futureValue: A!, compoundInterestPerYear12: CpY, numberOfPayments: t!)
                    textInterestRate.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            } else if paymentValueState == .years{
                do{
                    try resultEmptyField = formulaInterestRateYearly(principalValue: P!, futureValue: A!, compoundInterestPerYear12: CpY, numberOfPayments: t!)
                    textInterestRate.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }
        }
    }
    
    func resetFields(){
        textPrincipalAmount.text = ""
        textInterestRate.text = ""
        textFutureValue.text = ""
        textNumberOfPayments.text = ""
    }
    
    // Calculation formulas from brief and calculatorsoup.com
    // All results rounded 2 decimal places
    // https://developer.apple.com/forums/thread/116628
    
    // P - Principal amount - years
    func formulaPrincipalAmountYearly(futureValue: Double, interest: Double, compoundInterestPerYear12: Double, numberOfPayments: Double ) throws -> Double {
        let A = Double(futureValue)
        let R = Double(interest / 100.0)
        let N = Double(compoundInterestPerYear12) //FIXED CPY
        let T = Double(numberOfPayments) //monthly payments
        
        let P = A/pow(1 + (R/N), N*T)
        
        
        let roundedValue = round(P * 100) / 100.0
        return roundedValue
    }
    
    // P - Principal amount - months
    func formulaPrincipalAmountMonthly(futureValue: Double, interest: Double, compoundInterestPerYear12: Double, numberOfPayments: Double ) throws -> Double {
        let A = Double(futureValue)
        let R = Double(interest / 100.0)
        let N = Double(compoundInterestPerYear12) //FIXED
        let T = Double(numberOfPayments)/12 //monthly payments
        
        let P = A/pow(1 + (R/N), N*T)
        
        let roundedValue = round(P * 100) / 100.0
        return roundedValue
    }
    
    // A - Calculate Future Value without monthly contributions - years
    func formulaFutureValueYearly(principalValue: Double, interest: Double, compoundInterestPerYear12: Double, numberOfPayments: Double) throws -> Double {
        let P = Double(principalValue)
        let R = Double((interest) / 100)
        let T = Double(numberOfPayments)
        let N = Double(compoundInterestPerYear12)
        
        
        let A = P * (pow((1 + R/N), N * T))
        
        let roundedValue = round(A * 100) / 100.0
        return roundedValue
    }
    
    // A - Calculate Future Value without monthly contributions - months
    func formulaFutureValueMonthly(principalValue: Double, interest: Double, compoundInterestPerYear12: Double, numberOfPayments: Double) throws -> Double {
        let P = Double(principalValue)
        let R = Double((interest) / 100)
        let T = Double(numberOfPayments)/12
        let N = Double(compoundInterestPerYear12)
        
        
        let A = P * (pow((1 + R/N), N * T))
        
        let roundedValue = round(A * 100) / 100.0
        return roundedValue
    }
    
    // R - Interest Rate - years
    func formulaInterestRateYearly(principalValue: Double, futureValue: Double, compoundInterestPerYear12: Double, numberOfPayments: Double) throws -> Double {
        let A = Double(futureValue)
        let P = Double(principalValue)
        let T = Double(numberOfPayments)
        let N = Double(compoundInterestPerYear12)
        
        let R = N * (pow((A/P),(1/(N * T))) - 1) * 100
        
        let roundedValue = round(R * 100) / 100.0
        return roundedValue
    }
    
    // R - Interest Rate - months
    func formulaInterestRateMonthly(principalValue: Double, futureValue: Double, compoundInterestPerYear12: Double, numberOfPayments: Double) throws -> Double {
        let A = Double(futureValue)
        let P = Double(principalValue)
        let T = Double(numberOfPayments)/12
        let N = Double(compoundInterestPerYear12)
        
        let R = N * (pow((A/P),(1/(N * T))) - 1) * 100
        
        let roundedValue = round(R * 100) / 100.0
        return roundedValue
    }
    
    // T - Number of payments months
    func formulaNumberOfPaymentsMonthly(principalValue: Double, futureValue: Double, compoundInterestPerYear12: Double, interest: Double)throws -> Double {
        let A = Double(futureValue)
        let P = Double(principalValue)
        let N = Double(compoundInterestPerYear12)
        let R = Double((interest) / 100)
        
        let T = log(A/P) / (N * log(1+(R/N))) * 12 //x12 for yearly
        
        let roundedValue = round(T * 100) / 100.0
        return roundedValue.rounded()
    }
    
    // T - Number of payments - years
    func formulaNumberOfPaymentsYearly(principalValue: Double, futureValue: Double, compoundInterestPerYear12: Double, interest: Double)throws -> Double {
        let A = Double(futureValue)
        let P = Double(principalValue)
        let N = Double(compoundInterestPerYear12)
        let R = Double((interest) / 100)
        
        let T = log(A/P) / (N * log(1+(R/N)))
        
        let roundedValue = round(T * 100) / 100.0
        return roundedValue
    }
}
