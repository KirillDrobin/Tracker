//
//  RecordSender.swift
//  Tracker
//
//  Created by Кирилл Дробин on 27.12.2024.
//

import Foundation

protocol RecordSender: AnyObject {
    func recordSet(cellId: Int64, cellDate: Date)
    func recordDel(cellId: Int64, cellDate: Date)
}
