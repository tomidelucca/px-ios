//
//  IdentificationViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 5/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class IdentificationViewController: MercadoPagoUIViewController , UITextFieldDelegate{

    
    
    @IBOutlet weak var numberDocLabel: UILabel!
    @IBOutlet weak var numberTextField: HoshiTextField!
    var callback : (( identification: Identification) -> Void)?
    var identificationTypes : [IdentificationType]?
    var identificationType : IdentificationType?
    @IBOutlet weak var typeButton: UIButton!

    @IBOutlet var typePicker: UIPickerView! = UIPickerView()
    

    
    public init(callback : (( identification: Identification) -> Void)) {
        super.init(nibName: "IdentificationViewController", bundle: MercadoPago.getBundle())
       
      //  self.edgesForExtendedLayout = UIRectEdge.None

        self.callback = callback
        
        
         
    }
    override func loadMPStyles(){
        
        if self.navigationController != nil {
            
            
            //Navigation bar colors
            let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 18)!]
            
            if self.navigationController != nil {
                self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
                self.navigationItem.hidesBackButton = true
                self.navigationController!.interactivePopGestureRecognizer?.delegate = self
                self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
                self.navigationController?.navigationBar.barTintColor = UIColor(red: 90, green: 190, blue: 231)
                self.navigationController?.navigationBar.removeBottomLine()
                self.navigationController?.navigationBar.translucent = false
                //Create navigation buttons
                displayBackButton()
            }
        }
        
    }

    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
      
        if(textField.text?.characters.count > 9){
            return false
        }
        return true
    }

    
    public func editingChanged(textField:UITextField) {
         print(textField.text)
        if(textField.text?.characters.count > 0){
            let num : Int = Int(textField.text!)!
            let myIntString = num.stringFormatedWithSepator
            
            print(myIntString)
            numberDocLabel.text = myIntString
        }
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.autocorrectionType = UITextAutocorrectionType.No
        numberTextField.keyboardType = UIKeyboardType.NumberPad
        numberTextField.addTarget(self, action: "editingChanged:", forControlEvents: UIControlEvents.EditingChanged)

        self.setupInputAccessoryView()
        self.getIdentificationTypes()
        typePicker.hidden = true;
        numberTextField.becomeFirstResponder()
    }
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.leftBarButtonItem!.action = Selector("invokeCallbackCancel")
    }

 public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    

    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    

    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if(self.identificationTypes == nil){
            return 0
        }
       
        return self.identificationTypes!.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.identificationTypes![row].name
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        identificationType =  self.identificationTypes![row]
        typeButton.setTitle( self.identificationTypes![row].name, forState: .Normal)
        typePicker.hidden = true;
    }
    
    @IBAction func setType(sender: AnyObject) {
        numberTextField.resignFirstResponder()
        typePicker.hidden = false
        
    }

    
    func setupInputAccessoryView() {
        let navBar = UINavigationBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        navBar.barStyle = UIBarStyle.Default;
        navBar.backgroundColor = UIColor(netHex: 0xEEEEEE);
        navBar.alpha = 1;

        let navItem = UINavigationItem()

        let doneNext = UIBarButtonItem(title: "Siguiente", style: .Plain, target: self, action: "rightArrowKeyTapped")

        let donePrev =  UIBarButtonItem(title: "Anterior", style: .Plain, target: self, action: "leftArrowKeyTapped")

        
        
        
        
        navItem.rightBarButtonItem = doneNext
        navItem.leftBarButtonItem = donePrev
        //    navItem.setLeftBarButtonItems([donePrev,doneNext], animated: false)
        
        
        
        navBar.pushNavigationItem(navItem, animated: false)
        
        numberTextField.inputAccessoryView = navBar
        
    }

    func rightArrowKeyTapped(){
        let idnt = Identification(type: identificationType?.name , number: numberDocLabel.text?.stringByReplacingOccurrencesOfString(".", withString: ""))
        
        self.callback!(identification:idnt)
    }
    func leftArrowKeyTapped(){
        self.navigationController?.popViewControllerAnimated(false)
        
    }
    
    private func getIdentificationTypes(){
        MPServicesBuilder.getIdentificationTypes({ (identificationTypes) -> Void in
            self.identificationTypes = identificationTypes
            self.typePicker.reloadAllComponents()
            self.identificationType =  self.identificationTypes![0]
            self.typeButton.setTitle( self.identificationTypes![0].name, forState: .Normal)
            }, failure : { (error) -> Void in
                self.requestFailure(error)
        })
    }
}


struct Number {
    static let formatterWithSepator: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .DecimalStyle
        return formatter
    }()
}
extension IntegerType {
    var stringFormatedWithSepator: String {
        return Number.formatterWithSepator.stringFromNumber(hashValue) ?? ""
    }
}

