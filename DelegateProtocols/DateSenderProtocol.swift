//
//  DateSenderProtocol.swift
//  Tracker
//
//  Created by Кирилл Дробин on 25.12.2024.
//

import Foundation

protocol DateSenderProtocol: AnyObject {
    func dateSender(dateSender: [Date])
    func dateShortSender(daysOfWeekShortArraySender: [String])
}
