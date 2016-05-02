  //
//  CardFormViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/18/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CardFormViewController: MercadoPagoUIViewController , UITextFieldDelegate {

    
    
    @IBOutlet weak var promoButton: MPButton!
    @IBOutlet weak var cardView: UIView!
    var cardViewBack:UIView?
 
    var cardFront : CardFrontView?
    var cardBack : CardBackView?
    
    var cardNumberLabel: MPLabel?
    var numberLabelEmpty: Bool = true
    var nameLabel: MPLabel?
    var nameLabelEmpty: Bool = true
    var expirationDateLabel: MPLabel?
    var expirationLabelEmpty: Bool = true
    var cvvLabel: MPLabel?
    var cvvLabelEmpty: Bool = true

    var editingLabel : MPLabel?
    @IBOutlet weak var textBox: MPTextField!
   
    var paymentMethods : [PaymentMethod]?
    var paymentMethod : PaymentMethod?
    
    
    var installments : [Installment]?
    var payerCosts : [PayerCost]?
    
    var token : Token?
    
    
    var paymentSettings : PaymentSettings?
    var callback : (( paymentMethod: PaymentMethod,token: Token?, issuer: Issuer?, installment: Installment?) -> Void)?
    
    var amount : Double?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    public init(paymentSettings : PaymentSettings?, amount:Double, token: Token? = nil,  callback : ((paymentMethod: PaymentMethod, token: Token? , issuer: Issuer?, installment: Installment?) -> Void)) {
        super.init(nibName: "CardFormViewController", bundle: MercadoPago.getBundle())
        self.paymentSettings = paymentSettings
        self.token = token
      //  self.edgesForExtendedLayout = .All
        self.callback = callback
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cardView.addSubview(cardFront!)
        updateLabelsFontColors()
        

    }
    
    public override func viewDidAppear(animated: Bool) {
        
        
        cardFront?.frame = cardView.bounds
        cardBack?.frame = cardView.bounds
        textBox.placeholder = "Numero".localized
        textBox.becomeFirstResponder()
       
    }
  
    override public func viewDidLoad() {
        super.viewDidLoad()


        MPServicesBuilder.getPaymentMethods({ (paymentMethods) -> Void in
            self.paymentMethods = paymentMethods
            }) { (error) -> Void in
                // Mensaje de error correspondiente, ver que hacemos con el flujo
        }
        
        textBox.autocorrectionType = UITextAutocorrectionType.No
         textBox.keyboardType = UIKeyboardType.NumberPad
        textBox.addTarget(self, action: "editingChanged:", forControlEvents: UIControlEvents.EditingChanged)
       setupInputAccessoryView()
        textBox.delegate = self
        cardFront = CardFrontView()
        cardBack = CardBackView()
        cardBack!.backgroundColor = UIColor.clearColor()
        
        cardNumberLabel = cardFront?.cardNumber
        nameLabel = cardFront?.cardName
        expirationDateLabel = cardFront?.cardExpirationDate
        cvvLabel = cardBack?.cardCVV
        
        cardNumberLabel!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "touchNumber:"))
        cardNumberLabel?.text = ".... .... .... ...."
        nameLabel!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "touchName:"))
        nameLabel?.text = "Nombre Completo".localized
        expirationDateLabel!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "touchDate:"))
        expirationDateLabel?.text = "MM/AA".localized
        cvvLabel!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "touchCVV:"))
        cvvLabel?.text = "CVV".localized
        editingLabel = cardNumberLabel
        
        //Remove rightButton
      //  self.navigationItem.rightBarButtonItem = nil
      //  navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, style: .Done, target: self, action: "addTapped")
        
        
        // Or if you just want to insert one item.
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "confirmPaymentMethod"), animated: true)
        self.navigationItem.rightBarButtonItem!.enabled = false
        view.setNeedsUpdateConstraints()
        hidratateWithToken()

    }



    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let value : Bool = validateInput(textField, shouldChangeCharactersInRange: range, replacementString: string)
        updateLabelsFontColors()
        return value
    }


    
    public func editingChanged(textField:UITextField){

        if(editingLabel == cardNumberLabel){
            editingLabel?.text = formatCardNumberText(textField.text!)
            self.updateCardSkin()

            if(isAmexCard()){
                if (textField.text?.characters.count==18){
                    self.prepareNameLabelForEdit()
                }
            }else{
                if (textField.text?.characters.count==20){
                    self.prepareNameLabelForEdit()
                }
            }
             updateLabelsFontColors()
        }else if(editingLabel == nameLabel){
            editingLabel?.text = formatName(textField.text!)
            if (textField.text?.characters.count==20){
                self.prepareExpirationLabelForEdit()
            }
             updateLabelsFontColors()
        }else if(editingLabel == expirationDateLabel){
            editingLabel?.text = formatExpirationDate(textField.text!)
            if(textField.text?.characters.count == 5){
                if(!isAmexCard()){
                    editingLabel = cvvLabel
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.promoButton.alpha = 0
                        self.promoButton.enabled = false
                        UIView.transitionFromView(self.cardFront!, toView: self.cardBack!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: { (completion) -> Void in
                            self.prepareCVVLabelForEdit()
                        })
                    }
                }else{
                    self.prepareCVVLabelForEdit()
                }
                
            }
             updateLabelsFontColors()
        }else{
            editingLabel?.text = formatCVV(textField.text!)
           
            if(textField.text?.characters.count == 3){
                if(!isAmexCard()){
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                       
                        UIView.transitionFromView(self.cardBack!, toView: self.cardFront!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: { (completion) -> Void in
                            self.prepareNumberLabelForEdit()
                            self.promoButton.alpha = 1
                            self.promoButton.enabled = true
                            self.closeKeyboard()
                            self.navigationItem.rightBarButtonItem!.enabled = true
                        })
                        
                    }
                }else{
                    self.prepareNumberLabelForEdit()
                }
               
                if(isAmexCard()){
                    closeKeyboard()
                    self.navigationItem.rightBarButtonItem!.enabled = true
                }
                
            }

        }
      
        
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
    
        if(editingLabel == nameLabel){
                self.prepareExpirationLabelForEdit()
        }
        return true
    }

    
    /* Metodos para formatear el texto ingresado de forma que se muestre
        de forma adecuada dependiendo de cada campo de texto */
    private func formatCardNumberText(numberText:String) -> String{
        if(numberText.characters.count == 0){
            numberLabelEmpty = true
            return ".... .... .... ...."
        }
        numberLabelEmpty = false
        return numberText
    }
    
    private func formatName(name:String) -> String{
        if(name.characters.count == 0){
            nameLabelEmpty = true
            return "Nombre Completo".localized
        }
        nameLabelEmpty = false
        return name
       // return name.uppercaseString // TODO UX NO QUIERE MAYUSCULAS
    }
    private func formatCVV(cvv:String) -> String{
        if(cvv.characters.count == 0){
            cvvLabelEmpty = true
            return "CVV".localized
        }
        cvvLabelEmpty = false
        return cvv
    }
    private func formatExpirationDate(expirationDate:String) -> String{
        if(expirationDate.characters.count == 0){
            expirationLabelEmpty = true
            return "MM/AA".localized
        }
        expirationLabelEmpty = false
        return expirationDate
    }
    
    
    /* Metodos para preparar los diferentes labels del formulario para ser editados */
    private func prepareNumberLabelForEdit(){
        editingLabel = cardNumberLabel
        textBox.resignFirstResponder()
        textBox.keyboardType = UIKeyboardType.NumberPad
        textBox.becomeFirstResponder()
        textBox.text = numberLabelEmpty ?  "" : cardNumberLabel!.text
        textBox.placeholder = "Numero de tarjeta".localized
    }
    private func prepareNameLabelForEdit(){
        editingLabel = nameLabel
        textBox.resignFirstResponder()
        textBox.keyboardType = UIKeyboardType.Alphabet
        textBox.becomeFirstResponder()
        textBox.text = nameLabelEmpty ?  "" : nameLabel!.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        textBox.placeholder = "Nombre Completo".localized

    }
    private func prepareExpirationLabelForEdit(){
        editingLabel = expirationDateLabel
        textBox.resignFirstResponder()
        textBox.keyboardType = UIKeyboardType.NumberPad
        textBox.becomeFirstResponder()
        textBox.text = expirationLabelEmpty ?  "" : expirationDateLabel!.text
        textBox.placeholder = "Fecha de Expiracion".localized
    }
    private func prepareCVVLabelForEdit(){
        if(isAmexCard()){
            cvvLabel = cardFront?.cardCVV
            cardBack?.cardCVV.text = "CVV".localized
            cardBack?.cardCVV.alpha = 0
            cardFront?.cardCVV.alpha = 1
        }else{
            cvvLabel = cardBack?.cardCVV
            cardFront?.cardCVV.text = "CVV".localized
            cardFront?.cardCVV.alpha = 0
            cardBack?.cardCVV.alpha = 1
        }
        editingLabel = cvvLabel
        textBox.resignFirstResponder()
        textBox.keyboardType = UIKeyboardType.NumberPad
        textBox.becomeFirstResponder()
        textBox.text = cvvLabelEmpty  ?  "" : cvvLabel!.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        textBox.placeholder = "Codigo de Seguridad".localized
    }
    
    
    /* Metodos para escucha de los touch sobre los labels */
    func touchNumber(sender:UITapGestureRecognizer){
        prepareNumberLabelForEdit()
        updateLabelsFontColors()
    }
    func touchName(sender:UITapGestureRecognizer){
        prepareNameLabelForEdit()
        updateLabelsFontColors()
    }
    func touchDate(sender:UITapGestureRecognizer){
        prepareExpirationLabelForEdit()
        updateLabelsFontColors()
    }
    func touchCVV(sender:UITapGestureRecognizer){
        prepareCVVLabelForEdit()
        updateLabelsFontColors()
    }

    /* Metodos para validar si un texto ingresado es valido, dependiendo del tipo
        de campo que se este llenando */
    
    func validateInput(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        switch editingLabel! {
       
        case cardNumberLabel! :
            if(isAmexCard()){
                return validAmexInputNumber(textField, shouldChangeCharactersInRange: range, replacementString: string)
            }else{
                return validInputNumber(textField, shouldChangeCharactersInRange: range, replacementString: string)
            }

       
        case nameLabel! : return validInputName(textField.text! + string)
       
        case expirationDateLabel! : return validInputDate(textField, shouldChangeCharactersInRange: range, replacementString: string)
        
        case cvvLabel! : return validInputCVV(textField.text! + string)
        default : return false
        }
    }
    
    func validInputNumber(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        //Range.Lenth will greater than 0 if user is deleting text - Allow it to replce
        if range.length > 0
        {
            return true
        }
        
        //Dont allow empty strings
        if string == " "
        {
            return false
        }
        
        //Check for max length including the spacers we added
        if range.location == 20
        {
            return false
        }
        
        var originalText = textField.text
        let replacementText = string.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        //Verify entered text is a numeric value
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        for char in replacementText.unicodeScalars
        {
            if !digits.longCharacterIsMember(char.value)
            {
                return false
            }
        }
        
        //Put an empty space after every 4 places
        if originalText!.characters.count % 5 == 0
        {
            originalText?.appendContentsOf(" ")
            textField.text = originalText
        }
        
        return true

        
    }
    func validAmexInputNumber(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        //Range.Lenth will greater than 0 if user is deleting text - Allow it to replce
        if range.length > 0
        {
            return true
        }
        
        //Dont allow empty strings
        if string == " "
        {
            return false
        }
        
        //Check for max length including the spacers we added
        if range.location == 18
        {
            return false
        }
        
        var originalText = textField.text
        let replacementText = string.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        //Verify entered text is a numeric value
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        for char in replacementText.unicodeScalars
        {
            if !digits.longCharacterIsMember(char.value)
            {
                return false
            }
        }
        
        
        if ((originalText!.characters.count == 4)||(originalText!.characters.count == 12))
        {
            originalText?.appendContentsOf(" ")
            textField.text = originalText
        }
        
        return true
        
        
    }
    
    
    func validInputName(text : String) -> Bool{
        return true
    }
    func validInputDate(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        //Range.Lenth will greater than 0 if user is deleting text - Allow it to replce
        if range.length > 0
        {
            return true
        }
        
        //Dont allow empty strings
        if string == " "
        {
            return false
        }
        
        //Check for max length including the spacers we added
        if range.location == 5
        {
            return false
        }
        
        var originalText = textField.text
        let replacementText = string.stringByReplacingOccurrencesOfString("/", withString: "")
        
        //Verify entered text is a numeric value
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        for char in replacementText.unicodeScalars
        {
            if !digits.longCharacterIsMember(char.value)
            {
                return false
            }
        }
        
        
        if originalText!.characters.count == 2
        {
            originalText?.appendContentsOf("/")
            textField.text = originalText
        }
        
        return true


    }
    
    
    func validInputCVV(text : String) -> Bool{
        if( text.characters.count > self.cvvLenght() ){
            return false
        }
        let num = Int(text)
        return (num != nil)
    }
    
    func cvvLenght() -> Int{
        var lenght : Int
        
        if ((paymentMethod?.settings == nil)||(paymentMethod?.settings.count == 0)){
            lenght = 3 // Default
        }else{
            lenght = (paymentMethod?.settings[0].securityCode.length)!
        }
        return lenght
    }
    
    func setupInputAccessoryView() {
        let navBar = UINavigationBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        navBar.barStyle = UIBarStyle.Default;
        navBar.backgroundColor = UIColor(netHex: 0xEEEEEE);
        navBar.alpha = 1;
        //replace viewWidth with view controller width
        let navItem = UINavigationItem()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "closeKeyboard")
        
      //  let doneNext = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "rightArrowKeyTapped")
     //   let donePrev = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Rewind, target: self, action: "leftArrowKeyTapped")
        
        
       let doneNext =  UIBarButtonItem(image: MercadoPago.getImage("right_arrow"), landscapeImagePhone: MercadoPago.getImage("right_arrow"), style: .Plain, target: self, action: "rightArrowKeyTapped")
        let donePrev = UIBarButtonItem(image: MercadoPago.getImage("left_arrow"), landscapeImagePhone: MercadoPago.getImage("left_arrow"), style: .Plain, target: self, action: "leftArrowKeyTapped")
        

        
        
        navItem.rightBarButtonItem = doneButton
        
        navItem.setLeftBarButtonItems([donePrev,doneNext], animated: false)
        
        
        
        navBar.pushNavigationItem(navItem, animated: false)
        
        textBox.inputAccessoryView = navBar
        
    }
    
    
    
    func leftArrowKeyTapped(){
        switch editingLabel! {
            
        case cardNumberLabel! :
            self.promoButton.alpha = 0
            self.promoButton.enabled = false
            UIView.transitionFromView(self.cardFront!, toView: self.cardBack!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            self.prepareCVVLabelForEdit()
            
        case nameLabel! :
            self.prepareNumberLabelForEdit()
        case expirationDateLabel! :
        prepareNameLabelForEdit()
            
        case cvvLabel! :
           
            UIView.transitionFromView(self.cardBack!, toView: self.cardFront!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: { (completion) -> Void in
                self.promoButton.alpha = 1
                self.promoButton.enabled = true
            })
        
            prepareExpirationLabelForEdit()
        default : self.updateLabelsFontColors()
        }
        self.updateLabelsFontColors()
    }
    func rightArrowKeyTapped(){
        switch editingLabel! {
            
        case cardNumberLabel! : prepareNameLabelForEdit()
            
        case nameLabel! : prepareExpirationLabelForEdit()
            
        case expirationDateLabel! :
            if(!isAmexCard()){
                self.promoButton.alpha = 0
                self.promoButton.enabled = false
                UIView.transitionFromView(self.cardFront!, toView: self.cardBack!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: { (completion) -> Void in
                    self.updateLabelsFontColors()
                })
            }
            
            self.prepareCVVLabelForEdit()
            
        case cvvLabel! :
            if(!isAmexCard()){
                UIView.transitionFromView(self.cardBack!, toView: self.cardFront!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion:  { (completion) -> Void in
                    self.promoButton.alpha = 1
                    self.promoButton.enabled = true
                    self.updateLabelsFontColors()
                })
            }
            
            self.prepareNumberLabelForEdit()
        default : updateLabelsFontColors()
        }
        updateLabelsFontColors()
    }

    func closeKeyboard(){
        textBox.resignFirstResponder()
        delightedLabels()
    }
    
    func getBIN() -> String?{
        if(numberLabelEmpty){
            return nil
        }
        let trimmedNumber = cardNumberLabel?.text?.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        
        if (trimmedNumber!.characters.count < 6){
            return nil
        }else{
            let bin = trimmedNumber!.substringToIndex((trimmedNumber?.startIndex.advancedBy(6))!)
            return bin
        }
    }
    
    func matchedPaymentMethod () -> PaymentMethod? {
        if(paymentMethods == nil){
            return nil
        }
        if(getBIN() == nil){
            return nil
        }
        
        
        for (_, value) in paymentMethods!.enumerate() {
           
            if (value.conformsPaymentSettings(self.paymentSettings)){
                if (value.conformsToBIN(getBIN()!)){
                    return value.cloneWithBIN(getBIN()!)
                }
            }
            /*
            if (self.paymentSettings != nil){
                
                if (value.paymentTypeId == paymentType?.paymentTypeId){
                    if (value.conformsToBIN(getBIN()!)){
                        return value.cloneWithBIN(getBIN()!)
                    }
                }
            }else{
                if (value.conformsToBIN(getBIN()!)){
                    return value.cloneWithBIN(getBIN()!)
                }
            }
            */
        }
        return nil
    }
    
    func clearCardSkin(){
        
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            self.cardFront?.cardLogo.alpha =  0
            self.cardView.backgroundColor = UIColor(netHex: 0xEEEEEE)
            }) { (finish) -> Void in
                self.cardFront?.cardLogo.image =  nil
                
        }
        
    }
    
    func updateCardSkin(){
        if (textBox.text?.characters.count>7){
            let pmMatched = self.matchedPaymentMethod()
            
            if((pmMatched != nil) && (pmMatched != paymentMethod)){
                
                MPServicesBuilder.getInstallments(self.getBIN()!  , amount: 10000, issuer: nil, paymentTypeId: PaymentTypeId.CREDIT_CARD, success: { (installments) -> Void in
                    self.installments = installments
                    self.payerCosts = installments![0].payerCosts
                    }) { (error) -> Void in
                        print("error!")
                }
            }
            paymentMethod = pmMatched
            if(paymentMethod != nil){
                UIView.animateWithDuration(0.7, animations: { () -> Void in
               self.cardFront?.cardLogo.image =  MercadoPago.getImageFor(self.paymentMethod!)
                    self.cardView.backgroundColor = MercadoPago.getColorFor(self.paymentMethod!)
                    self.cardFront?.cardLogo.alpha = 1
                })
                
               
            }else{
                self.clearCardSkin()
            }
        }else{
            self.clearCardSkin()
        }
        
        if((paymentMethod != nil)&&(!paymentMethod!.secCodeInBack())){
            cvvLabel = cardFront?.cardCVV
            cardBack?.cardCVV.text = ""
        }else{
            cvvLabel = cardBack?.cardCVV
            cardFront?.cardCVV.text = ""
        }
    }
    
    func isAmexCard() -> Bool{
        if(getBIN() == nil){
            return false
        }
        if(paymentMethod != nil){
            return paymentMethod!.isAmex()
        }else{
            return false
        }
    }
    
    
    
    func delightedLabels(){
         cardNumberLabel?.textColor = MPLabel.defaultColorText
         nameLabel?.textColor = MPLabel.defaultColorText
         expirationDateLabel?.textColor = MPLabel.defaultColorText
         cvvLabel?.textColor = MPLabel.defaultColorText
    }
    
    func lightEditingLabel(){
        editingLabel?.textColor = MPLabel.highlightedColorText
    }
    func updateLabelsFontColors(){
        self.delightedLabels()
        self.lightEditingLabel()
    }
    func markErrorLabel(label: UILabel){
        label.textColor = MPLabel.errorColorText
    }
    
    func makeToken(){
        let number =  numberLabelEmpty ? "" :cardNumberLabel?.text
        let month = getMonth()
        let year = getYear()
        let secCode = cvvLabel?.text
        let name = nameLabel?.text
        
        let cardtoken = CardToken(cardNumber: number, expirationMonth: month, expirationYear: year, securityCode: secCode, cardholderName: name!, docType: "", docNumber: "")
        
        if (paymentMethod != nil){ 
            let errorMethod = cardtoken.validateCardNumber(paymentMethod!)
            if((errorMethod) != nil){
                markErrorLabel(cardNumberLabel!)
                return
            }
        }else{

                markErrorLabel(cardNumberLabel!)
                return
        }
        
        let errorDate = cardtoken.validateExpiryDate()
        if((errorDate) != nil){
            markErrorLabel(expirationDateLabel!)
            return
        }
        let errorName = cardtoken.validateCardholderName()
        if((errorName) != nil){
            markErrorLabel(nameLabel!)
            return
        }
        let errorCVV = cardtoken.validateSecurityCode()
        if((errorCVV) != nil){
            markErrorLabel(cvvLabel!)
            self.promoButton.alpha = 0
            self.promoButton.enabled = false
            UIView.transitionFromView(self.cardBack!, toView: self.cardFront!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            return
        }

        
        let installment : Installment = self.installments![0]
        
        MPServicesBuilder.createNewCardToken(cardtoken, success: { (token) -> Void in
            self.callback!(paymentMethod: self.paymentMethod!, token: token,issuer:installment.issuer, installment: installment)
            }) { (error) -> Void in
                print(error)
        }
        
    }
    
    
    func getMonth()->Int{
        let stringMMYY = expirationDateLabel?.text?.stringByReplacingOccurrencesOfString("/", withString: "")
        let validInt = Int(stringMMYY!)
        if(validInt == nil){
            return 0
        }
        let floatMMYY = Float(validInt! / 100)
        let mm : Int = Int(floor(floatMMYY))
        return mm
    }
    func getYear()->Int{
        let stringMMYY = expirationDateLabel?.text?.stringByReplacingOccurrencesOfString("/", withString: "")
        let validInt = Int(stringMMYY!)
        if(validInt == nil){
            return 0
        }
        let floatMMYY = Float( validInt! / 100 )
        let mm : Int = Int(floor(floatMMYY))
        let yy = Int(stringMMYY!)! - (mm*100)
        return yy
    }
    
    
    
    //BUTTON 
    func configureButton()
    {

       // promoButton.titleLabel!.font =  UIFont.boldSystemFontOfSize(8)
        promoButton.titleLabel!.text = "VER BANCOS CON MSI"
        promoButton.backgroundColor = UIColor.whiteColor()
        promoButton.layer.cornerRadius = 0.5 * promoButton.bounds.size.width
        promoButton.layer.borderColor = UIColor(netHex: 0x359FDB).CGColor
        promoButton.layer.borderWidth = 2.0
        promoButton.clipsToBounds = true
    }
    
    override public func viewDidLayoutSubviews() {
        configureButton()
    }

    
    func confirmPaymentMethod(){
        makeToken()
    }
    
    
    func hidratateWithToken(){
        if ( self.token == nil ){
            return
        }
        self.nameLabel?.text = self.token?.cardHolder?.name
        self.cardNumberLabel?.text = self.token?.getMaskNumber()
        self.expirationDateLabel?.text = self.token?.getExpirationDateFormated()
    }

    
}
