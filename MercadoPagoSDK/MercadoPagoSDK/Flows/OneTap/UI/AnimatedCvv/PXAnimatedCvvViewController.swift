//
//  PXAnimatedCvvViewController.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 11/11/18.
//

import UIKit

final class PXAnimatedCvvViewController: UIViewController {

    private let ghostTextField = UITextField()
    private var card: PXCardSliderViewModel?
    private var cardHeaderVC: CardHeaderController?
    private var cardFrame: CGRect = .zero
    private var accesoryView: UIButton = UIButton(frame: .zero)

    convenience init(withCard: PXCardSliderViewModel?, frame: CGRect) {
        self.init()
        self.card = withCard
        self.cardFrame = frame
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeBlur()
        showCard()
    }
}

extension PXAnimatedCvvViewController {
    private func setupUI() {
        view.backgroundColor = .clear
    }

    private func makeBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        view.addSubview(blurEffectView)
        UIView.animate(withDuration: 0.4) {
            blurEffectView.alpha = 1
        }
    }

    private func showCard() {
        if let currentCard = card, let cardData = currentCard.cardData {
            cardHeaderVC = CardHeaderController(currentCard.cardUI, cardData)
            if let cardVC = cardHeaderVC {
                cardVC.view.frame = CGRect(origin: CGPoint(x: cardFrame.origin.x, y: cardFrame.origin.y), size: PXCardSliderSizeManager.getItemContainerSize())
                addChildViewController(cardVC)
                view.addSubview(cardVC.view)
                cardVC.didMove(toParentViewController: self)
                cardVC.show()

                var animator = PXAnimator.init(duration: 0.4, dampingRatio: 20.5)
                animator.addAnimation(animation: {
                    cardVC.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                })
                animator.addCompletion {
                    self.perform(#selector(PXAnimatedCvvViewController.changeCardPosition), with: self, afterDelay: 0.0)
                }
                animator.animate()
            }
        }
    }
}

extension PXAnimatedCvvViewController {
    @objc func changeCardPosition() {
        var animator = PXAnimator.init(duration: 0.5, dampingRatio: 20.4)
        animator.addAnimation(animation: {
             self.cardHeaderVC?.view.transform = CGAffineTransform.identity
        })
        animator.addCompletion {
            self.showKeyboard()
        }
        animator.animate()
    }

    @objc func showKeyboard() {
        accesoryView = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 54))
        accesoryView.backgroundColor = ThemeManager.shared.greyColor()
        accesoryView.setTitle("Pagar".localized, for: .normal)
        accesoryView.setTitleColor(UIColor.white, for: .normal)
        accesoryView.isEnabled = false
        ghostTextField.inputAccessoryView = accesoryView
        ghostTextField.delegate = self
        view.addSubview(ghostTextField)
        ghostTextField.isHidden = true
        ghostTextField.keyboardType = .numberPad
        ghostTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {

        }

        UIView.animate(withDuration: 0.3, animations: {
            self.cardHeaderVC?.view.frame = CGRect(origin: CGPoint(x: self.cardFrame.origin.x, y: 85), size: PXCardSliderSizeManager.getItemContainerSize())
        }) { finish in
            if finish {
                self.flipCard()
            }
        }
    }

    func flipCard() {
        self.cardHeaderVC?.showSecurityCode()
    }
}

extension PXAnimatedCvvViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let ttext = textField.text {
            card?.cardData?.securityCode = ttext
        }

        // TODO: Get proper values for secury card code.
        if let cDataCode = card?.cardData?.securityCode, cDataCode.count < 2 {
            card?.cardData?.securityCode += string
            UIView.animate(withDuration: 0.2) {
                self.accesoryView.backgroundColor = ThemeManager.shared.greyColor()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.accesoryView.backgroundColor = ThemeManager.shared.getAccentColor()
            }
        }

        return true
    }
}
