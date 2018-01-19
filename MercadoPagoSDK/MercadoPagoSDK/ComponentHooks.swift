@objc
public protocol PXComponetizable {
    func render() -> UIView
}
public protocol PXHookeable: PXComponetizable {
    func getStep() -> PXHookStep
    func render() -> UIView
    func renderDidFinish()
    func didRecive(hookStore: PXHookStore)
//    func didRecive(action: MPAction)
}

/*
open class MPAction: NSObject {
    
    private var checkout: MercadoPagoCheckout?
    
    public override init() {}
    
    open func initialize(checkout:MercadoPagoCheckout) -> MPAction {
        self.checkout = checkout
        return self
    }
    
    open func next() {
        checkout?.executeNextStep()
    }
}
*/
open class PXHookStore: NSObject {

    static let sharedInstance = PXHookStore()
    private var data = [String: Any]()
    var paymentData = PaymentData()
    var paymentOptionSelected: PaymentMethodOption?

    public func addData(forKey: String, value: Any) {
        self.data[forKey] = value
    }
    public func remove(key: String) {
        data.removeValue(forKey: key)
    }

    public func removeAll() {
        data.removeAll()
    }

    public func getData(forKey: String) -> Any? {
        return self.data[forKey]
    }

    public func getPaymentData() -> PaymentData {
        return paymentData
    }

    public func getPaymentOptionSelected() -> PaymentMethodOption? {
        return paymentOptionSelected
    }

}
