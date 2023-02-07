//
//  Constants.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/24.
//

import Foundation
import UIKit

struct Constants{
    
    struct Xibs{
        struct CollectionViewCells{
            static let cardCell = "CardCollectionViewCell"
            static let imageCell = "ImageCollectionViewCell"
        }
        
        struct TableViewCells{
            static let transactionCell = "TransactionCell"
            static let notificationCell = "NotificationCell"
            static let generalCell = "GeneralTableViewCell"
        }
        
        struct StateCells{
            static let emptyCell = "EmptyTableViewCell"
            static let loadingCell = "LoadingTableViewCell"
        }
        
        struct Views{
            static let cardView = "CardView"
            static let emptyCardView = "EmptyCardView"
        }
    }
    
    
    struct Images{
        static let menuIcon = UIImage.init(systemName: "circle.grid.2x2.fill")
        static let notificationIcon = UIImage.init(systemName: "bell.fill")
        static let cardBackgroundImagesStrings = ["cardImage-1","cardImage-2","cardImage-3","cardImage-4","cardImage-5"]
    }
    
    struct Categories{
        static let incomes = ["Salary", "UpWork"]
        static let expenses = ["Shopping", "Food", "Payment"]
        static let transactionTypes = ["income","expense"]
        static var cardTypes = ["None","MasterCard", "Visa Card","PayPal","Uzcard","Humo"]
    }
    
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
        static let mycardToUpdateCard = "myCardsToUpdateCard"
        
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
