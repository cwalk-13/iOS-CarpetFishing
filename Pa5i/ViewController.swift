//
//  ViewController.swift
//  Pa5
//  This file is the viewcontroller of the Carpet Sea game app. It handles what functions are called when a button is pressed
//  CPSC 315-01, Fall 2020
//  No sources to cite
//Bonus: disable buttons when button is pressed
//  Created by Walker, Charles Milton on 10/18/20.
//  Copyright © 2020 Walker, Charles Milton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var sea = CarpetSea()
    var theFish = ""
    var fishScore = 0
    var selectedCell = Cell(row: 0, col: 0)
    var fishCell = Cell(row: 0, col: 0)
    var score = 0
    var S = 60
    
    let alert = UIAlertController(title: "Welcome to Carpet Fishing", message: "Tap a cell to drop your fishing line in carpet sea. After a second, you'll see if you caught a fish. In 60 seconds, try to gert the highest score you can. Here are the available fish in Carpet Sea [🐟: 5, 🐙: 10, 🦈:15, 🐳:20] ", preferredStyle: .alert)
    let dropAlert = UIAlertController(title: "Drop a line", message: "Tap on a cell to drop your line, then wait and see if yopu caught a fish!", preferredStyle: .alert)
    let newGameAlert = UIAlertController(title: "Game Over!", message: "Press continue to start a new game.", preferredStyle: .alert)
    

    var continueAction = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
    @IBOutlet var cells: [UIButton]!
    
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var newGameButton: UIButton!
    
//starts a new game if the new game button is pressed
    @IBAction func newGame(_ sender: UIButton) {
        startNewGame()
    }
    @IBAction func updateS(_ sender: Any) {
    }
    
    @IBAction func cellSelected(_ sender: UIButton) {
        selectedCell = sea.cells[sender.tag]
        sea.dropFishingLine(cellNum: sender.tag)
        labels[sender.tag].text = "⌇"
        labels[sender.tag].layer.zPosition = 1
        fishCell = sea.randomlyPlaceFish()
        
        startSecondTimer()

        continueAction = UIAlertAction(title: "Continue", style: .default, handler: startTimer(alertAction:))
//Bonus: disable buttons after one button is pressed
        for i in 0...cells.count-1 {
            cells[i].isEnabled = false
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        continueAction = UIAlertAction(title: "Continue", style: .default, handler: startTimer(alertAction:))
        sea.createCells()
        newGameAlert.addAction(continueAction)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//the first alert is presented when the app is opened
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: showDropAlert(alertAction:))
        alert.addAction(okayAction)
        present(alert, animated: true)
    }
//shows the second alert after the initial alert
    func showDropAlert(alertAction: UIAlertAction) {
        present(dropAlert,animated: true)
        dropAlert.addAction(continueAction)
    }
    
//variables to set up the two timers
    var timer: Timer? = nil
    var secTimer: Timer? = nil
    var stSeconds = 1
 
    var seconds: Int = 60 {
        didSet {
            timerLabel.text = "\(seconds)s"
        }
    }
    
//starts the 1 second timer, when this timer reaches zero calls the showCells and resetSecondTimer functions
    func startSecondTimer() {
        secTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (secTimer) in
//            print("timer started")
            self.stSeconds -= 1
            if self.stSeconds == 0 {
                self.showCells()
                self.resetSecondTimer()
//                print("timer stopped")
            }
        })
    }
    
//resets the 1 second timer and calls showCaughFish
    func resetSecondTimer() {
        secTimer?.invalidate() // optional chaining
        secTimer = nil
        stSeconds = 1
//        print("got to reset")
        showCaughtFish()
        
    }

// Starts the game timer, when this timer reaches zero starts a new game. also calls hide cells
    func startTimer(alertAction: UIAlertAction) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.seconds -= 1
            if self.seconds == 0 {
                self.startNewGame()
            }
        })
        scoreLabel.text = String(score)
        hideCells()
//reenables the buttons
        for i in 0...cells.count-1 {
            cells[i].isEnabled = true
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
// changes the text of eqach cell and brings the label stack view to z position 1
    func showCells() {
        labels[0].text = sea.cells[0].description
        labels[1].text = sea.cells[1].description
        labels[2].text = sea.cells[2].description
        labels[3].text = sea.cells[3].description
        
        labels[0].layer.zPosition = 1
        labels[1].layer.zPosition = 1
        labels[2].layer.zPosition = 1
        labels[3].layer.zPosition = 1
//        print("cells shown")
    }
// pushes the labels layer back to z position 0 so the cell text is not seen
    func hideCells() {
        sea.clearCells()
        labels[0].layer.zPosition = 0
        labels[1].layer.zPosition = 0
        labels[2].layer.zPosition = 0
        labels[3].layer.zPosition = 0
    }

//calls the CarpetSea setFishScore function and updates the fish string and fishscore variables
    func getFishScore() {
        let fishStats = sea.setFishScore(cell: fishCell)
        let strings = fishStats.map {$0.0}
        let nums = fishStats.map {$0.1}
        theFish = strings[0]
        fishScore = nums[0]
        
    }

//chooses which alert to show and whether or not to update the score based on the return value of CarpetSea's checkFishCaught function
    func showCaughtFish() {
        getFishScore()
//        print("got to show caught")
        let noCatchAlert = UIAlertController(title: "Reel in your line", message: "Looks like you didn't catch a fish! Press continue to drop a new line.", preferredStyle: .alert)
        let caughtAlert = UIAlertController(title: "Reel in your line", message: "You caught a \(theFish) worth \(fishScore) points! Press continue to drop a new line.", preferredStyle: .alert)
        if sea.checkFishCaught(cell: fishCell) {
            score += fishScore
            caughtAlert.addAction(continueAction)
            present(caughtAlert, animated: true)
            stopTimer()
        }
        else {
            noCatchAlert.addAction(continueAction)
            present(noCatchAlert, animated: true)
            stopTimer()
        }
    }
    
    func startNewGame() {
        stopTimer()
        seconds = S
        score = 0
        continueAction = UIAlertAction(title: "Continue", style: .default, handler: startTimer(alertAction:))
        present(newGameAlert, animated: true)
    }
}

