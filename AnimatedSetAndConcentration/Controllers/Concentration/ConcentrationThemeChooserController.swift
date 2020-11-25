//
//  ConcentrationThemeChooserController.swift
//  AnimatedSetAndConcentration
//
//  Created by Nicholas Bonet on 11/25/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserController: UIViewController, UISplitViewControllerDelegate {
    /*
        Nice little dictionary for different emoji themes for the cards.
        Can simply add a new entry of 8 emojis and it will be randomly
        selected by the game.
    */
    let themes = [
        "Vehicles": ["🚗", "🚕", "🚙", "🚒", "🚖", "🚘", "🚚", "🚛", "🚍", "🚌", "🚎", "🏎", "🚓", "🚐", "🚜", "🛺", "✈️", "🚤", "🚂", "🚆"],
        "Snacks": ["🍫", "🍬", "🍭", "🍪", "🍩", "🍰", "🧁", "🥮", "🍧", "🍨", "🍦", "🥧", "🎂", "☕️", "🍿", "🥜", "🍯", "🥛", "🥤", "🍡"],
        "Animals": ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵", "🐔", "🐧", "🐧", "🦆", "🐦"],
        "Fruits & Vegetables": ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🥑", "🥦", "🥬"],
        "Sports": ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱", "🪀", "🏓", "🏸", "🏒", "🏑", "🥍", "⛳️", "🥅", "🪁", "🏹"],
        "Shapes": ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🔴", "🟠", "🟡", "🟢", "🔵", "🟣", "⚫️", "⚪️", "🟤", "🟥", "🟧", "🟨"]
    ]

    /*
     Code below is adapted from the class demo covering multiple MVCs.
     */
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }

    public func splitViewController(_ splitViewController: UISplitViewController,
                                    collapseSecondary secondaryViewController: UIViewController,
                                    onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme.count == 0 {
                return true
            }
        }
        return false
    }

    private var splitViewDetailCVC: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }

    private var lastSeguedToConcentrationViewController: ConcentrationViewController?

    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailCVC {
            if let themeName = (sender as? UIButton)?.currentTitle,
               let newTheme = themes[themeName] {
                    cvc.theme = newTheme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle,
               let newTheme = themes[themeName] {
                    cvc.theme = newTheme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle,
               let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}
