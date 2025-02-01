//
//  Constants.swift
//  Tracker
//
//  Created by Кирилл Дробин on 29.12.2024.
//

import UIKit

enum Constants {
    static let daysOfWeek = [NSLocalizedString("Понедельник", comment: ""),
                             NSLocalizedString("Вторник", comment: ""),
                             NSLocalizedString("Среда", comment: ""),
                             NSLocalizedString("Четверг", comment: ""),
                             NSLocalizedString("Пятница", comment: ""),
                             NSLocalizedString("Суббота", comment: ""),
                             NSLocalizedString("Воскресенье", comment: "")]
    static let daysOfWeekShort = [NSLocalizedString("Пн", comment: ""),
                                  NSLocalizedString("Вт", comment: ""),
                                  NSLocalizedString("Ср", comment: ""),
                                  NSLocalizedString("Чт", comment: ""),
                                  NSLocalizedString("Пт", comment: ""),
                                  NSLocalizedString("Сб", comment: ""),
                                  NSLocalizedString("Вс", comment: "")]
    
    static let emojisForCell = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    static let colorsForCell = [UIColor(red: 253/255, green: 76/255, blue: 73/255, alpha: 1),
                                           UIColor(red: 255/255, green: 136/255, blue: 30/255, alpha: 1),
                                           UIColor(red: 0/255, green: 123/255, blue: 250/255, alpha: 1),
                                           UIColor(red: 110/255, green: 68/255, blue: 254/255, alpha: 1),
                                           UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1),
                                           UIColor(red: 230/255, green: 109/255, blue: 212/255, alpha: 1),
                                           UIColor(red: 249/255, green: 212/255, blue: 212/255, alpha: 1),
                                           UIColor(red: 52/255, green: 167/255, blue: 254/255, alpha: 1),
                                           UIColor(red: 70/255, green: 230/255, blue: 157/255, alpha: 1),
                                           UIColor(red: 52/255, green: 52/255, blue: 124/255, alpha: 1),
                                           UIColor(red: 255/255, green: 103/255, blue: 77/255, alpha: 1),
                                           UIColor(red: 255/255, green: 153/255, blue: 204/255, alpha: 1),
                                           UIColor(red: 246/255, green: 196/255, blue: 139/255, alpha: 1),
                                           UIColor(red: 121/255, green: 148/255, blue: 245/255, alpha: 1),
                                           UIColor(red: 131/255, green: 44/255, blue: 241/255, alpha: 1),
                                           UIColor(red: 173/255, green: 86/255, blue: 218/255, alpha: 1),
                                           UIColor(red: 141/255, green: 114/255, blue: 230/255, alpha: 1),
                                           UIColor(red: 47/255, green: 208/255, blue: 88/255, alpha: 1),]
}
