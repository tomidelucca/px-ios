//
//  CurrencyUtilTest.swift
//  MercadoPagoSDKTests
//
//  Created by Juan sebastian Sanzone on 22/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import XCTest

class CurrencyUtilTest: BaseTest {

    func test_whenThirdDecimalBelowFiveThenRoundDownWithOneDigit() {
        let amount: Double = 5.432
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 5.43))
    }

    func test_whenThirdDecimalAboveFiveThenRoundUpWithOneDigit() {
        let amount: Double = 5.436
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 5.44))
    }

    func test_whenThirdDecimalEqualsFiveThenRoundUpWithOneDigit() {
        let amount: Double = 5.435
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 5.44))
    }

    func test_whenThirdDecimalBelowFiveThenRoundDownWithTwoDigits() {
        let amount: Double = 25.432
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 25.43))
    }

    func test_whenThirdDecimalAboveFiveThenRoundUpWithTwoDigits() {
        let amount: Double = 25.436
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 25.44))
    }

    func test_whenThirdDecimalEqualsFiveThenRoundUpWithTwoDigits() {
        let amount: Double = 25.435
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 25.44))
    }

    func test_whenThirdDecimalBelowFiveThenRoundDownWithThreeDigits() {
        let amount: Double = 425.432
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 425.43))
    }

    func test_whenThirdDecimalEqualsFiveThenRoundUpWithThreeDigits() {
        let amount: Double = 425.436
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 425.44))
    }

    func test_whenTwoDecimalsThenDontRound() {
        let amount: Double = 5.43
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 5.43))
    }

    func test_whenOneDecimalThenDontRound() {
        let amount: Double = 5.4
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 5.4))
    }

    func test_whenThirdDecimalIsNineThenRoundUpWithThreeDigits() {
        let amount: Double = 425.099
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 425.10))
    }

    func test_whenThirdDecimalIsFiveThenRoundUpWithThreeDigits() {
        let amount: Double = 425.005
        let roundedAmount: Double = CurrenciesUtil.getRoundedAmount(amount: amount)
        assert(roundedAmount .isEqual(to: 425.01))
    }
}
