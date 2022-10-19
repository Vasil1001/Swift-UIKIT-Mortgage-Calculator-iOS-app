//
//  CompoundSavingsViewController.swift
//  FinanceAppCW1
//
//  Created by Vasil Dzhakov on 07/03/2022.
//

import UIKit

class CompoundSavingsViewController: UIViewController {
    
    @IBAction func instructionsPopUp(_ sender: UIButton) {
        popUpAlert(message: "Fill in 4 out of 5 fields, leave the field you wish to calculate empty and press the 'Calulate' button. \n\nInterest cannot be calculated in this instance, it is required that you enter interest % for the calculations. \n\n The monthly payment is a fixed amount for the amount of payments selected. \n\nUse the switch to type in years instead of months for payments!", title: "Instructions\n")
    }
    // Set fixed placeholder text(£,%,Duration) inside all textfields from
    // https://stackoverflow.com/questions/52016838/swift-textfield-inside-left-side-add-icon
    //Works by creating a new UILabel(), setting a value to it and positioning it to the leftView of the textfield
    
    @IBOutlet weak var textPrincipalAmount: UITextField! {
        didSet {
            let staticMoneySignLabel = UILabel()
            staticMoneySignLabel.text = " £ "
            staticMoneySignLabel.sizeToFit()
            textPrincipalAmount.leftView = staticMoneySignLabel
            textPrincipalAmount.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var textInterestRate: UITextField! {
        didSet {
            let staticPercentLabel = UILabel()
            staticPercentLabel.text = " % "
            staticPercentLabel.sizeToFit()
            textInterestRate.leftView = staticPercentLabel
            textInterestRate.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var textMonthlyPayment: UITextField! {
        didSet {
            let staticMoneySignLabel2 = UILabel()
            staticMoneySignLabel2.text = " £ "
            staticMoneySignLabel2.sizeToFit()
            textMonthlyPayment.leftView = staticMoneySignLabel2
            textMonthlyPayment.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var textFutureValue: UITextField! {
        didSet {
            let staticMoneySignLabel3 = UILabel()
            staticMoneySignLabel3.text = " £ "
            staticMoneySignLabel3.sizeToFit()
            textFutureValue.leftView = staticMoneySignLabel3
            textFutureValue.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var textNumberOfPayments: UITextField! {
        didSet {
            let staticMoneySignLabel4 = UILabel()
            staticMoneySignLabel4.text = " Duration "
            staticMoneySignLabel4.sizeToFit()
            textNumberOfPayments.leftView = staticMoneySignLabel4
            textNumberOfPayments.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var labelNumberOfPayments: UILabel!
    
    @IBOutlet weak var labelShowYearsSwitch: UILabel!
    @IBOutlet weak var switchYears: UISwitch!
    
    // From week5/6 lab
    // set all textfields in view to 1, dismiss keyboard on click outside of textfield
    //keyboard also set to numpad only
    @IBAction func tapGestureKBDismissAction(_ sender: Any) {
        if ((self.view.viewWithTag(1)?.isFirstResponder) != nil)
        {
            textPrincipalAmount.resignFirstResponder()
            textInterestRate.resignFirstResponder()
            textMonthlyPayment.resignFirstResponder()
            textFutureValue.resignFirstResponder()
            textNumberOfPayments.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Lab 3 Colorpicker example used to declare defaults and set them for when app is closed or in background
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        let defaults = UserDefaults.standard
        
        let principalAmountCompound = defaults.string(forKey: "principalAmountCompound")
        let interestRatePercentCompound = defaults.string(forKey: "interestRatePercentCompound")
        let monthlyPaymentCompound = defaults.string(forKey: "monthlyPaymentCompound")
        let futureValueCompound = defaults.string(forKey: "futureValueCompound")
        let numberOfPaymentsCompound = defaults.string(forKey: "numberOfPaymentsCompound")
        
        textPrincipalAmount.text = principalAmountCompound
        textInterestRate.text = interestRatePercentCompound
        textMonthlyPayment.text = monthlyPaymentCompound
        textFutureValue.text = futureValueCompound
        textNumberOfPayments.text = numberOfPaymentsCompound
    }
    
    // Lab 3 Colorpicker example used to declare defaults and set them for when app is closed or in background
    @objc   func appMovedToBackground()
    {
        print("backgrounded or closed")
        
        let defaults = UserDefaults.standard
        
        let principalAmountCompound = textPrincipalAmount.text
        defaults.set(principalAmountCompound, forKey: "principalAmountCompound")
        
        let interestRatePercentCompound = textInterestRate.text
        defaults.set(interestRatePercentCompound, forKey: "interestRatePercentCompound")
        
        let monthlyPaymentCompound = textMonthlyPayment.text
        defaults.set(monthlyPaymentCompound, forKey: "monthlyPaymentCompound")
        
        let futureValueCompound = textFutureValue.text
        defaults.set(futureValueCompound, forKey: "futureValueCompound")
        
        let numberOfPaymentsCompound = textNumberOfPayments.text
        defaults.set(numberOfPaymentsCompound, forKey: "numberOfPaymentsCompound")
    }
    
    //Switch toggle state for .months or .years calculations
    enum switchState {
        case months
        case years
    }
    
    //set starting state at months, e.g. user can enter 24 for 2 years
    var paymentValueState: switchState? = .months
    
    
    @IBAction func buttonCalculate(_ sender: UIButton) {
        
        if checkTextfieldInput() == 4 {
            resultOnEmptyField()
        } else if checkTextfieldInput() == 5 {
            popUpAlert(message: "Please leave the field you want to calculate empty", title: "Alert")
        } else if checkTextfieldInput() == 0 {
            popUpAlert(message: "Please fill out 4 fields to calculate a result", title: "Alert")
        } else {
            popUpAlert(message: "Please fill out 4 fields to calculate a result", title: "Alert")
            return
        }
    }
    
    @IBAction func buttonReset(_ sender: UIButton) {
        resetFields()
        
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        if (textInterestRate.text  == "") {
            popUpAlert(message: "Interest cannot be calculated while there are monthly payments. Please enter a value for interest.", title: "Alert")
            return
        } else if checkTextfieldInput() == 3 {
            popUpAlert(message: "Please fill out 4 fields to calculate a result", title: "Alert")
        } else if checkTextfieldInput() == 4 {
            resultOnEmptyField()
        } else if checkTextfieldInput() == 5 {
            resultOnEmptyField() //no popup just switch years
        } else if checkTextfieldInput() == 0 {
            popUpAlert(message: "Please fill out 4 fields to calculate a result", title: "Alert")
        } else {
            popUpAlert(message: "Please fill out 4 fields to calculate a result", title: "Alert")
        }
        
        if sender.isOn {
            textNumberOfPayments.text = ""
            labelShowYearsSwitch.text = "Show years"
            labelNumberOfPayments.text = "Number of Payments (months)"
            
            paymentValueState = .months
            resultOnEmptyField()
        } else {
            textNumberOfPayments.text = ""
            labelShowYearsSwitch.text = "Show months"
            labelNumberOfPayments.text = "Number of Payments (years)"
            
            paymentValueState = .years
            resultOnEmptyField()
        }
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
        if !(textInterestRate.text?.isEmpty)! {
            fields += 1
        }
        if !(textMonthlyPayment.text?.isEmpty)! {
            fields += 1
        }
        if !(textFutureValue.text?.isEmpty)! {
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
        let PMT = Double(textMonthlyPayment.text!)
        let A = Double(textFutureValue.text!)
        
        let CpY = 12.0 //12 Payments
        
        var resultEmptyField: Double = 0.0
        // Check for every field if its empty, output result in empty field, which is 'var resultEmptyField'
        // if it is, use the correct formula to display a result in resultEmptyField
        
        if (textPrincipalAmount.text?.isEmpty)! { //text? - might be empty or not, also ! unwraps value
            if paymentValueState == .months{
                do{
                    
                    try resultEmptyField = formulaPrincipalAmountMonths(futureValue: A!, interest: r!, monthlyPayment: PMT!, compoundInterestPerMonth: CpY, numberOfPayments: t!)
                    
                    textPrincipalAmount.text = String(resultEmptyField)
                }
                catch let err {
                    print(err)
                }
            } else if paymentValueState == .years {
                do {
                    try resultEmptyField = formulaPrincipalAmountYears(futureValue: A!, interest: r!, monthlyPayment: PMT!, compoundInterestPerMonth: CpY, numberOfPayments: t!)
                    
                    textPrincipalAmount.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }
        }
        
        if (textFutureValue.text?.isEmpty)! {
            if paymentValueState == .months{
                do{
                    
                    try resultEmptyField = formulaFutureValueMonths(principalValue: P!, interest: r!, compoundInterest: CpY, numberOfPayments: t!, PaymentMonthly: PMT!)
                    textFutureValue.text = String(resultEmptyField)
                }
                catch let err {
                    print(err)
                }
            } else if paymentValueState == .years {
                do {
                    try resultEmptyField = formulaFutureValueYears(principalValue: P!, interest: r!, compoundInterest: CpY, numberOfPayments: t!, PaymentMonthly: PMT!)
                    textFutureValue.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }
        }
        
        if (textMonthlyPayment.text?.isEmpty)! {
            if paymentValueState == .months{
                do{
                    try resultEmptyField = formulaMontlhyPaymentMonths(principalValue: P!, futureValue: A!, compoundInterestPerMonth: CpY, interest: r!, numberOfPayments: t!)
                    textMonthlyPayment.text = String(resultEmptyField)
                }
                catch let err {
                    print(err)
                }
            } else if paymentValueState == .years {
                do {
                    try resultEmptyField = formulaMontlhyPaymentYears(principalValue: P!, futureValue: A!, compoundInterestPerMonth: CpY, interest: r!, numberOfPayments: t!)
                    textMonthlyPayment.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }
        }
        
        if (textNumberOfPayments.text?.isEmpty)! {
            if paymentValueState == .months{
                do{
                    
                    try resultEmptyField = formulaNumberOfPaymentsMonthly(principalValue: P!, futureValue: A!, compoundInterestPerYear12: CpY, interest: r!, paymentMonthly: PMT!)
                    textNumberOfPayments.text = String(resultEmptyField)
                }
                catch let err {
                    print(err)
                }
            } else if paymentValueState == .years {
                do {
                    try resultEmptyField = formulaNumberOfPayments(principalValue: P!, futureValue: A!, compoundInterestPerMonth: CpY, interest: r!, paymentMonthly: PMT!)
                    textNumberOfPayments.text = String(resultEmptyField)
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
        textMonthlyPayment.text = ""
    }
    
    // Calculation formulas from brief and calculatorsoup.com
    // All results rounded 2 decimal places
    // https://developer.apple.com/forums/thread/116628
    
    //https://math.stackexchange.com/questions/4150453/compound-interest-with-regular-monthly-contributions-formula + updated brief pdf
    // P - Principal amount - years
    func formulaPrincipalAmountYears(futureValue: Double,interest: Double, monthlyPayment: Double, compoundInterestPerMonth: Double, numberOfPayments: Double ) throws -> Double {
        let A = Double(futureValue)
        let R = Double(interest / 100.0)
        let N = Double(compoundInterestPerMonth) //FIXED
        let T = Double(numberOfPayments) //monthly payments
        let PMT = Double(monthlyPayment)
        
        // let P = A/pow(1 + (R/N), N*T)
        let P = (A-(PMT * (pow((1 + R / N), N*T) - 1) / (R / N)))/pow(1 + (R/N), N*T)
        
        let roundedDouble = round(P*100)/100.0
        return roundedDouble
    }
    
    //https://math.stackexchange.com/questions/4150453/compound-interest-with-regular-monthly-contributions-formula + updated brief pdf
    // P - Principal amount - months
    func formulaPrincipalAmountMonths(futureValue: Double,interest: Double, monthlyPayment: Double, compoundInterestPerMonth: Double, numberOfPayments: Double ) throws -> Double {
        let A = Double(futureValue)
        let R = Double(interest / 100.0)
        let N = Double(compoundInterestPerMonth) //FIXED
        let T = Double(numberOfPayments)/12 //monthly payments
        let PMT = Double(monthlyPayment)
        
        //future value -    // let P = A/pow(1 + (R/N), N*T)
        let P = (A-(PMT * (pow((1 + R / N), N*T) - 1) / (R / N)))/pow(1 + (R/N), N*T)
        
        let roundedDouble = round(P*100)/100.0
        return roundedDouble
    }
    
    // A - Calculate Future Value with monthly contributions - months
    func formulaFutureValueMonths(principalValue:Double, interest: Double, compoundInterest: Double, numberOfPayments: Double, PaymentMonthly: Double) throws -> Double {
        let P = Double(principalValue)
        let R = Double((interest) / 100)
        let T = Double(numberOfPayments)/12
        let N = Double(compoundInterest) //always 12
        let PMT = Double(PaymentMonthly)
        
        //  A = [ Compound interest for principal] + [ Future value of a series]
        //  Principal -> let P = A/pow(1 + (R/N), N*T)
        //  add A formula
        let A = (P*(pow(1 + R/N, N*T))) + (PMT*(pow(1+(R/N),N*T)-1)/(R/N))
        
        let roundedDouble = round(A*100)/100.0
        return roundedDouble
    }
    
    // A - Calculate Future Value with monthly contributions - years
    func formulaFutureValueYears(principalValue:Double, interest: Double, compoundInterest: Double, numberOfPayments: Double, PaymentMonthly: Double) throws -> Double {
        let P = Double(principalValue)
        let R = Double((interest) / 100)
        let T = Double(numberOfPayments)
        let N = Double(compoundInterest) //always 12
        let PMT = Double(PaymentMonthly)
        
        //  A = [ Compound interest for principal] + [ Future value of a series]
        //  Principal -> let P = A/pow(1 + (R/N), N*T)
        //  add A formula
        let A = (P*(pow(1 + R/N, N*T))) + (PMT*(pow(1+(R/N),N*T)-1)/(R/N))
        
        let roundedDouble = round(A*100)/100.0
        return roundedDouble
    }
    
    // PMT - Fixed monthly payment amount - years
    func formulaMontlhyPaymentYears(principalValue: Double, futureValue: Double, compoundInterestPerMonth: Double, interest: Double, numberOfPayments: Double) throws -> Double {
        let P = Double(principalValue)
        let R = Double((interest) / 100)
        let T = Double(numberOfPayments)
        let N = Double(compoundInterestPerMonth)
        let A = Double(futureValue)
        //                  A                /                        /
        let PMT =  (A-(P*(pow(1+R/N, N*T)))) / ((pow(1+R/N, N*T) - 1) / (R/N))
        
        let roundedDouble = round(PMT*100)/100.0
        return roundedDouble
    }
    
    // PMT - Fixed monthly payment amount - months
    func formulaMontlhyPaymentMonths(principalValue: Double, futureValue: Double, compoundInterestPerMonth: Double, interest: Double, numberOfPayments: Double) throws -> Double {
        let P = Double(principalValue)
        let R = Double((interest) / 100)
        let T = Double(numberOfPayments)/12
        let N = Double(compoundInterestPerMonth)
        let A = Double(futureValue)
        
        //                  A                /                        /
        let PMT =  (A-(P*(pow(1+R/N, N*T)))) / ((pow(1+R/N, N*T) - 1) / (R/N))
        
        let roundedDouble = round(PMT*100)/100.0
        return roundedDouble
    }
    
    // T - Number of payments - years
    func formulaNumberOfPayments(principalValue: Double, futureValue: Double, compoundInterestPerMonth: Double, interest: Double, paymentMonthly: Double) throws -> Double {
        let A = Double(futureValue)
        let P = Double(principalValue)
        let N = Double(compoundInterestPerMonth)
        let R = Double((interest) / 100)
        let PMT = Double(paymentMonthly)
        
        //let fA = (A-(P*(pow(1+R/N, N*T))))
        //A/pow(1 + (R/N), N*T)
        let T = (log(A + ((PMT * N) / R)) - log(((R * P) + (PMT * N)) / R)) / (N * log(1 + (R/N)))
        
        let roundedValue = round(T * 100) / 100.0
        return roundedValue
        
    }
    
    // T - Number of payments - months (T x 12)
    func formulaNumberOfPaymentsMonthly(principalValue: Double, futureValue: Double, compoundInterestPerYear12: Double, interest: Double, paymentMonthly: Double) throws -> Double {
        let A = Double(futureValue)
        let P = Double(principalValue)
        let N = Double(compoundInterestPerYear12)
        let R = Double((interest) / 100)
        let PMT = Double(paymentMonthly)
        
        let T = Double((log(A + ((PMT * N) / R)) - log(((R * P) + (PMT * N)) / R)) / (N * log(1 + (R / N)))) * 12
        
        let roundedValue = round(T * 100) / 100.0
        return roundedValue.rounded()
    }
}
