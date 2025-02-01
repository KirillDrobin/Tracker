//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Кирилл Дробин on 01.02.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {

        let vc = TrackersViewController()
        
        assertSnapshot(of: vc, as: .image)
        assertSnapshot(of: vc, as: .image(on: .iPhoneSe))
        assertSnapshot(of: vc, as: .recursiveDescription)
    }

}
