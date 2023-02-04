//
//  UIHelper.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/26.
//

import Foundation
import UIKit

struct UIHelper{
    
    private var calendarHelper = CalendarHelper()
    
    static func createButton(imageName:String)->UIButton?{
        let button = UIButton()
        guard let image = UIImage.init(systemName: imageName)?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal) else{return nil}
        button.setImage(image, for: .normal)
        return button
    }
    
    static func setupMenuButton(button:UIButton, listOfItems: [String], buttonAction: @escaping (_ title:String)->Void){
        let popUpButtonClosure = { (action: UIAction) in
            buttonAction(action.title)
        }
        button.menu = UIMenu(children: listOfItems.map({ item in
            UIAction(title: item, handler: popUpButtonClosure)
        }))
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
    }
    
    static func createBlurBackground(with parentView:UIView, isAddedToParent:Bool = true, blurStyle: UIBlurEffect.Style = .light)->UIVisualEffectView{
        //creating blur effect
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = parentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //animation
        blurEffectView.alpha = 0
        UIVisualEffectView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            blurEffectView.alpha = 1
        }completion: { _ in
            if isAddedToParent{
                parentView.addSubview(blurEffectView)
            }
           
        }
        
        return blurEffectView
    }
    
    mutating func getWeeklyCalendarUI(weekdaysStack:UIStackView){
        let currentWeekNumbers = calendarHelper.currentWeek()
        let currentDay = calendarHelper.currentDay()
        currentWeekNumbers.forEach { weekNumber in
            if weekNumber == currentDay{
                weekdaysStack.addArrangedSubview(createWeekdayUI(dayNumber: weekNumber, isCurrentDay: true))
            }else{
                weekdaysStack.addArrangedSubview(createWeekdayUI(dayNumber: weekNumber, isCurrentDay: false))
            }
        }
    }
    
    private func createWeekdayUI(dayNumber:Int, isCurrentDay:Bool)->UIView{
        let parentView = UIView()
        //child view
        let childView = UIStackView()
        childView.layer.cornerRadius = 15
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        //label
        let label = UILabel()
        label.text = "\(dayNumber)"
        label.textAlignment = .center
        if isCurrentDay {
            childView.backgroundColor = UIColor(named: "green-light")
            label.textColor = UIColor.white
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        childView.addArrangedSubview(label)
        
        parentView.addSubview(childView)
        childView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        childView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        childView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        childView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        return parentView
    }

}
