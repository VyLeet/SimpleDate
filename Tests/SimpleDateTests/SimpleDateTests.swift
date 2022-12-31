import XCTest
@testable import SimpleDate

final class SimpleDateTests: XCTestCase {
    func testCreateWithFirstDayOfNonLeapTheYear() throws {
        let date = Date.init(timeIntervalSinceReferenceDate: 0)
        let simpleDate = SimpleDate(date: date)
        
        XCTAssertEqual(simpleDate.dayNumber, 1)
    }
    
    func testCreateWithFirstDayOfLeapTheYear() throws {
        let date = Date.init(timeIntervalSince1970: 0)
        let simpleDate = SimpleDate(date: date)
        
        XCTAssertEqual(simpleDate.dayNumber, 1)
    }
    
    func testCreateWithLastDayOfLeapYear() throws {
        let date = Date.init(timeIntervalSinceReferenceDate: -10000)
        let simpleDate = SimpleDate(date: date)
        
        XCTAssertEqual(simpleDate.dayNumber, 366)
    }
    
    func testCreateWithLastDayOfNonLeapYear() throws {
        let date = Date.init(timeIntervalSince1970: -10000)
        let simpleDate = SimpleDate(date: date)
        
        XCTAssertEqual(simpleDate.dayNumber, 365)
    }
}
