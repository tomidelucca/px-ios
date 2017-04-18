//
//  CardsAdminViewModelTest.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 4/18/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest

class CardsAdminViewModelTest: BaseTest {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    

    func testNumberOfItemsToShow() {
        let dummyCards = [Card(),Card(),Card()]
        let cardAdminViewModel = CardsAdminViewModel(cards: dummyCards)
        XCTAssertEqual(cardAdminViewModel.numberOfOptions(), 3, "La cantidad de items a mostrar no se calcula correctametne.(Cantidad de tarjeas) ")
        XCTAssertFalse(cardAdminViewModel.shouldGetCustomerCardsInfo(),"No debería necesitar hacer la consulta de cards, dado que se instancia el ViewController con dichas tarjetas.")
        let cardAdminViewModelWithExtraOption = CardsAdminViewModel(cards: dummyCards, extraOptionTitle: "Extra Option")
        XCTAssertEqual(cardAdminViewModelWithExtraOption.numberOfOptions(), 4, "La cantidad de items a mostrar no se calcula correctametne. (Cantidad de tarjeas y una opcion extra)")
    }
    
    func testHeights(){
        let json : NSDictionary = MockManager.getMockFor("Card")!
        let cardFromJSON = Card.fromJSON(json)
        let dummyCards = [cardFromJSON]
        let cardAdminViewModel = CardsAdminViewModel(cards: dummyCards)
        XCTAssertEqual(cardAdminViewModel.calculateHeight(indexPath: IndexPath(row: 0, section: 0), numberOfCells: 1),150.50)
        XCTAssertEqual(cardAdminViewModel.calculateHeight(indexPath: IndexPath(row: 0, section: 1), numberOfCells: 1),150.50)
        XCTAssertEqual(cardAdminViewModel.maxHegithRow(indexPath:  IndexPath(row: 0, section: 0)),150.50)
        XCTAssertEqual(cardAdminViewModel.maxHegithRow(indexPath:  IndexPath(row: 0, section: 1)),150.50)
    }
    
    func testSectionsNumbers(){
        let dummyCards = [Card(),Card(),Card()]
        let cardAdminViewModel = CardsAdminViewModel(cards: dummyCards)
        XCTAssertTrue(cardAdminViewModel.isHeaderSection(section: 0))
        XCTAssertTrue(cardAdminViewModel.isCardsSection(section: 1))

    }
}
