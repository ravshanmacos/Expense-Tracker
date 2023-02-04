//
//  Constants.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/24.
//

import Foundation

struct Constants{
    struct CellIdentifiers {
        static let loadingCell = "LoadingTableViewCell"
        static let emptyCell = "EmptyTableViewCell"
        static let transactionCell = "transactionCell"
        static let generalCell = "generalCell"
        static let notificationCell = "notificationCell"
        static let cardCell = "cardCell"
        static let imageCell = "imageCell"
        static let languageCell = "LanguageCell"
    }
    struct Segues{
        static let profileToRegister = "profileToRegister"
        static let profileToEdit = "profileToEdit"
        static let homeToNotification = "homeToNotifications"
        static let mycardToAddcard = "mycardToAddCard"
        static let settingsToLanguages = "settingsToLangs"
        static let settingsToFeedback = "settingsToFeedback"
        
    }
    struct Settings{
    static let payment = "Payment"
    static let activity = "Activity"
    static let messageCenter = "MessageCenter"
    static let reminder = "Reminder"
    static let language = "Language"
    static let faq = "FAQs"
    static let feedback = "Send Feedback"
    static let report = "Report a problem"
    }
}
