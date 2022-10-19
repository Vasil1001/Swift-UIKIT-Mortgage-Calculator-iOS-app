//
//  MortgageLoanViewController.swift
//  FinanceAppCW1
//
//  Created by Vasil Dzhakov on 07/03/2022.
//

import UIKit

class MortgageLoanViewController: UIViewController {
    
    @IBAction func instructionPopUp(_ sender: UIButton) {
        popUpAlert(message: "Fill in 3 out of 4 fields, leave the field you wish to calculate empty and press the 'Calulate' button. \n\nInterest cannot be calculated in this instance, it is required that you enter interest % for the calculations. \n\n The monthly payment is a fixed amount for the amount of payments selected. \n\nUse the switch to type in years instead of months for payments!", title: "Instructions\n")
    }
    
    // Set fixed placeholder text(£,%,Duration) inside all textfields from
    // https://stackoverflow.com/questions/52016838/swift-textfield-inside-left-side-add-icon
    //Works by creating a new UILabel(), setting a value to it and positioning it to the leftView of the textfield
    
    @IBOutlet weak var textLoanAmount: UITextField! {
        didSet {
            let staticMoneySignLabel = UILabel()
            staticMoneySignLabel.text = " £ "
            staticMoneySignLabel.sizeToFit()
            textLoanAmount.leftView = staticMoneySignLabel
            textLoanAmount.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var textInterest: UITextField! {
        didSet{
            let staticPercentLabel = UILabel()
            staticPercentLabel.text = " % "
            staticPercentLabel.sizeToFit()
            textInterest.leftView = staticPercentLabel
            textInterest.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var textMonthlyPayment: UITextField! {
        didSet{
            let staticMoneySignLabel2 = UILabel()
            staticMoneySignLabel2.text = " £ "
            staticMoneySignLabel2.sizeToFit()
            textMonthlyPayment.leftView = staticMoneySignLabel2
            textMonthlyPayment.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var textNoOfPayments: UITextField! {
        didSet{
            let duration = UILabel()
            duration.text = " Duration:  "
            duration.sizeToFit()
            textNoOfPayments.leftView = duration
            textNoOfPayments.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var labelMonthlyPayment: UILabel!
    @IBOutlet weak var labelNoOfPayments: UILabel!
    @IBOutlet weak var labelSwitch: UILabel!
    
    @IBOutlet weak var switchYears: UISwitch!
    
    // From week5/6 lab
    // set all textfields in view to 1, dismiss keyboard on click outside of textfield
    //keyboard also set to numpad only
    @IBAction func tapGestureKBDismissAction(_ sender: UITapGestureRecognizer) {
        if ((self.view.viewWithTag(1)?.isFirstResponder) != nil)
        {
            textLoanAmount.resignFirstResponder()
            textInterest.resignFirstResponder()
            textMonthlyPayment.resignFirstResponder()
            textNoOfPayments.resignFirstResponder()
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
        
        let loanAmount = defaults.string(forKey: "loanAmount")
        
        let interest = defaults.string(forKey: "interest")
        
        let monthlyPaymentAmount = defaults.string(forKey: "monthlyPaymentAmount")
        
        let numberOfPayments = defaults.string(forKey: "numberOfPayments")
        
        textLoanAmount.text = loanAmount
        textInterest.text = interest
        textMonthlyPayment.text = monthlyPaymentAmount
        textNoOfPayments.text = numberOfPayments
    }
    
    // Lab 3 Colorpicker example used to declare defaults and set them for when app is closed or in background
    @objc   func appMovedToBackground()
    {
        print("backgrounded or closed")
        
        let defaults = UserDefaults.standard
        
        let loanAmount = textLoanAmount.text
        defaults.set(loanAmount, forKey: "loanAmount")
        
        let interest = textInterest.text
        defaults.set(interest, forKey: "interest")
        
        let monthlyPaymentAmount = textMonthlyPayment.text
        defaults.set(monthlyPaymentAmount, forKey: "monthlyPaymentAmount")
        
        let numberOfPayments = textNoOfPayments.text
        defaults.set(numberOfPayments, forKey: "numberOfPayments")
    }
    
    //Switch toggle state for .months or .years calculations
    enum switchState {
        case months
        case years
    }
    
    //set starting state at months, e.g. user can enter 24 for 2 years
    var paymentValueState: switchState? = .months
    
    @IBAction func switchCode(_ sender: UISwitch) {
        
        if (textInterest.text  == "") {
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
            textNoOfPayments.text = ""
            labelSwitch.text = "Show years"
            labelNoOfPayments.text = "Number of Payments (months)"
            
            paymentValueState = .months
            
            if (textLoanAmount.text?.isEmpty)! {
                popUpAlert(message: "Please type a number to switch", title: "Switch Alert")
            } else {
                resultOnEmptyField()
            }
            
        } else {
            textNoOfPayments.text = ""
            labelSwitch.text = "Show months"
            labelNoOfPayments.text = "Number of Payments (years)"
            
            paymentValueState = .years
            
            if (textLoanAmount.text?.isEmpty)! {
                popUpAlert(message: "Please type a number to switch", title: "Switch Alert")
                
            } else {
                resultOnEmptyField()
            }
        }
    }
    
    @IBAction func CalculateBtn(_ sender: UIButton) {
        if (textInterest.text  == "") {
            popUpAlert(message: "Interest cannot be calculated while there are monthly payments. Please enter a value for interest.", title: "Alert")
        } else if checkTextfieldInput() == 3 {
            resultOnEmptyField()
        } else if checkTextfieldInput() == 4 {
            popUpAlert(message: "Please leave the field you want to calculate empty", title: "Alert")
        } else if checkTextfieldInput() == 0 {
            popUpAlert(message: "Please fill out 3 fields to calculate a result", title: "Alert")
        } else {
            popUpAlert(message: "Please fill out 3 fields to calculate a result", title: "Alert")
        }
    }
    
    @IBAction func resetBtn(_ sender: UIButton) {
        resetFields()
    }
    
    //Check how many fields are not empty
    func checkTextfieldInput() -> Int {
        var fields = 0
        //if NOT EMPTY
        if !(textLoanAmount.text?.isEmpty)! {
            fields += 1
        }
        if !(textInterest.text?.isEmpty)! {
            fields += 1
        }
        if !(textMonthlyPayment.text?.isEmpty)! {
            fields += 1
        }
        if !(textNoOfPayments.text?.isEmpty)! {
            fields += 1
        }
        return fields
    }
    
    //Create alert on screen for wrong inputs from:
    //https://www.ioscreator.com/tutorials/display-alert-ios-tutorial#:~:text=Go%20to%20the%20Storyboard%20and,bottom%2Dright%20of%20the%20Storyboard.
    func popUpAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetFields(){
        textLoanAmount.text = ""
        textInterest.text = ""
        textMonthlyPayment.text = ""
        textNoOfPayments.text = ""
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
    
    func resultOnEmptyField(){
        let t = Double(textNoOfPayments.text!) //use ! to unwrap optional of type String?
        let r = Double(textInterest.text!)
        let P = Double(textLoanAmount.text!)
        let PMT = Double(textMonthlyPayment.text!)
        
        //let CpY = 12.0 //12 Payments
        
        var resultEmptyField: Double = 0.0
        // Check for every field if its empty, output result in empty field, which is 'var resultEmptyField'
        // if it is, use the correct formula to display a result in resultEmptyField
        
        if (textLoanAmount.text?.isEmpty)! { //text? - might be empty or not, also ! unwraps value
            if paymentValueState == .months {
                do {
                    try resultEmptyField = formulaPrincipalLoanAmountMonthly(interest: r!, monthlyPayment: PMT!, numberOfPayments: t!)
                    textLoanAmount.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            } else if paymentValueState == .years {
                do {
                    try resultEmptyField =
                    formulaPrincipalLoanAmountYearly(interest: r!, monthlyPayment: PMT!, payments: t!)
                    textLoanAmount.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }
        }
        
        if (textMonthlyPayment.text?.isEmpty)! {
            if paymentValueState == .months{
                do{
                    try resultEmptyField = formulaPMTMonthlyPaymentMonthly(interest: r!, principalAmount: P!, numberOfPayments: t!)
                    textMonthlyPayment.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            } else if paymentValueState == .years {
                do {
                    try resultEmptyField = formulaPMTMonthlyPaymentYears(interest: r!, principalAmount: P!, numberOfPayments: t!)
                    textMonthlyPayment.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }
        }
        
        if (textNoOfPayments.text?.isEmpty)! {
            if paymentValueState == .months{
                do {
                    try resultEmptyField = formulaAmountOfPaymentsMonthly(interest: r!, principalAmount: P!,  monthlyPayment: PMT!)
                    textNoOfPayments.text = String(resultEmptyField)
                }
                catch let err {
                    print(err)
                }
            } else if paymentValueState == .years {
                do {
                    try resultEmptyField = formulaAmountOfPaymentsYearly(interest: r!, principalAmount: P!,  monthlyPayment: PMT!)
                    textNoOfPayments.text = String(resultEmptyField)
                }
                catch let err{
                    print(err)
                }
            }
        }
    }
    
    // Calculation formulas from brief and calculatorsoup.com
    // All results rounded 2 decimal places
    // https://developer.apple.com/forums/thread/116628
    
    // Principal Amount - months
    // https://www.calculatorsoup.com/calculators/financial/loan-calculator.php
    func formulaPrincipalLoanAmountMonthly(interest: Double, monthlyPayment: Double, numberOfPayments: Double) throws -> Double {
        let PMT = monthlyPayment
        let R = (interest / 100.0)/12
        let T = numberOfPayments
        
        let P = (PMT/R)*(1 - (1/(pow(1+R, T))))
        
        let roundedValue = round(P * 100) / 100.0
        return roundedValue
        
    }
    
    //Principal Amount - years
    func formulaPrincipalLoanAmountYearly(interest: Double, monthlyPayment: Double, payments: Double) throws -> Double {
        let PMT = monthlyPayment
        let R = (interest / 100.0)/12
        let T = payments * 12
        
        let P = ((PMT/R)*(1 - (1/(pow(1+R, T)))))
        
        let roundedValue = round(P * 100) / 100.0
        return roundedValue
        
    }
    
    // -------------------------------------------------------------------------//
    
    
    // https://www.calculatorsoup.com/calculators/financial/loan-calculator.php
    // PMT - Fixed monthly payment amount - years
    func formulaPMTMonthlyPaymentYears(interest: Double, principalAmount: Double, numberOfPayments: Double) throws -> Double {
        let R = (interest / 100.0)/12
        let P = principalAmount
        let T = numberOfPayments * 12
        
        let PMT = (((P*R)*(pow(1+R, T)))/(pow(1+R, T)-1))
        
        let roundedValue = round(PMT * 100) / 100.0
        return roundedValue
    }
    
    // https://www.calculatorsoup.com/calculators/financial/loan-calculator.php
    // PMT - Fixed monthly payment amount - months
    func formulaPMTMonthlyPaymentMonthly(interest: Double, principalAmount: Double, numberOfPayments: Double) throws -> Double {
        let R = (interest / 100.0) / 12
        let P = principalAmount
        let T = numberOfPayments
        let PMT = (((P*R)*(pow(1+R, T)))/(pow(1+R, T)-1))
        
        let roundedValue = round(PMT * 100) / 100.0
        return roundedValue
    }
    
    // ------------------------------------------------------------------------------------------------------------------- //
    
    // https://www.calculatorsoup.com/calculators/financial/loan-calculator.php
    // T = Number of payments - years
    func formulaAmountOfPaymentsYearly(interest: Double, principalAmount: Double, monthlyPayment: Double) throws -> Double {
        
        let PMT = monthlyPayment
        let P = principalAmount
        let R = (interest / 100.0) / 12
        
        let topFormula = log((PMT/R)/((PMT/R)-P))
        let bottomFormula = log(1 + R)
        
        let N = (topFormula/bottomFormula)/12
        
        let Nrounded = (N * 100).rounded()/100
        return Nrounded
    }
    
    // https://www.calculatorsoup.com/calculators/financial/loan-calculator.php
    // T - Number of payments - months
    func formulaAmountOfPaymentsMonthly(interest: Double, principalAmount: Double, monthlyPayment: Double) throws -> Double {
        
        let P = principalAmount
        let PMT = monthlyPayment
        let R = (interest / 100.0) / 12
        
        let topFormula = log((PMT/R)/((PMT/R)-P))
        let bottomFormula = log(1 + R)
        
        let N = (topFormula/bottomFormula)
        
        let Nrounded = (N * 100).rounded()/100
        return Nrounded.rounded()
    }
}
