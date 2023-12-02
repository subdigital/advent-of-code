import XCTest
import AOCShared
@testable import AdventOfCode


final class AdventOfCodeTests: XCTestCase {
    func testGridInsertColumnLeft() {
        var grid = Grid(data: ["1", "2", "3", "1", "2", "3", "1", "2" , "3"], width: 3, height: 3)
        grid.addColumnLeft(char: "0")
        print(grid.description)
        XCTAssertEqual(grid.origin.0, -1)
        XCTAssertEqual(grid.origin.1, 0)

        XCTAssertEqual(grid[(-1, 0)], "0")
        XCTAssertEqual(grid[(-1, 1)], "0")
        XCTAssertEqual(grid[(-1, 2)], "0")
    }

    func testGridInsertColumnRight() {
        var grid = Grid(data: ["1", "2", "3", "1", "2", "3", "1", "2" , "3"], width: 3, height: 3)
        grid.addColumnRight(char: "0")
        print(grid.description)
        XCTAssertEqual(grid.origin.0, 0)
        XCTAssertEqual(grid.origin.1, 0)

        XCTAssertEqual(grid[(0, 0)], "1")
        XCTAssertEqual(grid[(0, 1)], "1")
        XCTAssertEqual(grid[(0, 2)], "1")
        XCTAssertEqual(grid[(3, 0)], "0")
        XCTAssertEqual(grid[(3, 1)], "0")
        XCTAssertEqual(grid[(3, 2)], "0")
    }

    func testSensorRadius() {
        let sensor = Day15.Sensor(coord: .init(5, 8), beacon: .init(8, 8))
        XCTAssertEqual(sensor.radiusToBeacon, 3)

        let sensor2 = Day15.Sensor(coord: .init(5, 8), beacon: .init(8, 15))
        XCTAssertEqual(sensor2.radiusToBeacon, 10)
    }
}
