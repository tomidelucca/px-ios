//
//  DecorationPreferenceTest.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 1/17/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest

class DecorationPreferenceTest: BaseTest {

    var decoration: DecorationPreference!

    override func setUp() {
        super.setUp()
        self.decoration = DecorationPreference()
    }

    func testInits() {
        let decorationPreference = DecorationPreference(baseColor: UIColor.brown)
        XCTAssertEqual(decorationPreference.baseColor, UIColor.brown)
    }

    func testDefaultValues() {
        XCTAssertEqual(decoration.getBaseColor(), UIColor.px_blueMercadoPago())
        XCTAssertEqual(decoration.fontName, ".SFUIDisplay-Regular")
        XCTAssertEqual(decoration.fontLightName, ".SFUIDisplay-Light")
    }

    func testSetBaseColor() {
        decoration.setBaseColor(color: UIColor.brown)
        XCTAssertEqual(decoration.getBaseColor(), UIColor.brown)
    }

    func testEnableDarkFont() {
        decoration.enableDarkFont()
        XCTAssertEqual(decoration.getFontColor(), UIColor.black)
    }

    func testEnableLightFont() {
        decoration.enableLightFont()
        XCTAssertEqual(decoration.getFontColor(), UIColor.white)
    }

    func testSetMercadoPagoBaseColor() {
        decoration.setMercadoPagoBaseColor()
        XCTAssertEqual(decoration.getBaseColor(), UIColor.px_blueMercadoPago())
        decoration.setBaseColor(color: UIColor.purple)
        decoration.setMercadoPagoBaseColor()
        XCTAssertEqual(decoration.getBaseColor(), UIColor.px_blueMercadoPago())
    }

    func testSetBaseColorHexa() {
        decoration.setBaseColor(hexColor: "#B34C42")
        XCTAssertEqual(decoration.getBaseColor(), UIColor.errorCellColor())
    }

    func testSetMercadoPagoFont() {
        decoration.setCustomFontWith(name: "sarasa")
        decoration.setMercadoPagoFont()
        XCTAssertEqual(decoration.getFontName(), ".SFUIDisplay-Regular")
    }

    func testSetFontName() {
        decoration.setCustomFontWith(name: "Comic")
        XCTAssertEqual(decoration.getFontName(), "Comic")
    }

    func testSetMercadoPagoLightFont() {
        decoration.setLightCustomFontWith(name: "sarasa")
        decoration.setMercadoPagoLightFont()
        XCTAssertEqual(decoration.getLightFontName(), ".SFUIDisplay-Light")
    }

    func testSetLightFontName() {
        decoration.setLightCustomFontWith(name: "Comic")
        XCTAssertEqual(decoration.getLightFontName(), "Comic")
    }

}
