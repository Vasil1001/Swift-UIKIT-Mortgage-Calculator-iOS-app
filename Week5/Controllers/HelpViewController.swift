//
//  HelpViewController.swift
//  FinanceAppCW1
//
//  Created by Vasil Dzhakov on 07/03/2022.
//

import UIKit

class HelpViewController: UIViewController {
    
    //https://www.ioscreator.com/tutorials/segmented-control-ios-tutorial
    @IBOutlet weak var segmentedControlPages: UISegmentedControl!
    
    @IBOutlet var helpView: UIView!
    @IBOutlet var instructionsView: UIView!
    
    @IBOutlet weak var labelMortgage: UILabel!
    @IBOutlet weak var textMortgage: UILabel!
    
    @IBOutlet weak var textSavings: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControlPagesAction(_ sender: UISegmentedControl) {
        switch segmentedControlPages.selectedSegmentIndex {
        case 0:
            labelMortgage.text = "Mortgage"
            //from investopedia https://www.investopedia.com/terms/m/mortgage.asp
            textMortgage.text = "The term “mortgage” refers to a loan used to purchase or maintain a home, land, or other types of real estate. The borrower agrees to pay the lender over time, typically in a series of regular payments that are divided into principal and interest. The property serves as collateral to secure the loan."
            
            textSavings.text = "Savings refers to the money that a person has left over after they subtract out their consumer spending from their disposable income over a given time period. Savings, therefore, represents a net surplus of funds for an individual or household after all expenses and obligations have been paid."
        case 1:
            labelMortgage.text = "Mortgage"
            textMortgage.text = "To calculate mortgage loan values you must input 3 fields - a fixed interest rate %, and 2 other fields from loan amount, monthly payment or number of payments, leaving the one you want to calculate empty."
            
            textSavings.text = "To calculate savings you must enter 3 fields, leaving the desired result empty. User has to enter 4 fields for a calculation in case he is looking for Savings with monthly contributions. The interest % can be calculated if there are no monthly contributions, only for Simple Savings."
        default:
            break;
        }
    }
}
