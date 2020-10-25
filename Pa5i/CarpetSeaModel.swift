//
//  CarpetSeaModel.swift
//  Pa5
// This file is the model of the Carpet Sea game app. It holds the classes that define the objects used, and their respective functions.
//  CPSC 315-01, Fall 2020
//  No sources to cite
//  Created by Walker, Charles Milton on 10/18/20.
//  Copyright © 2020 Walker, Charles Milton. All rights reserved.
//

import Foundation
class Cell: CustomStringConvertible {
    var row: Int
    var col: Int
    var containsLine: Bool = false
    var fish: String? = ""
    var description: String {
        if containsLine && fish != "" {
            return "🎣"
        }
        return "\(fish ?? " ")"
    }
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    func placeFish(fish: String?) {
        self.fish = fish
    }
    
    func placeLine() {
        self.containsLine = true

    }
    
    func clearCell() {
        self.fish = ""
        self.containsLine = false
    }
}

//the CarpetSea is composed of cells and can manipulate those cells
class CarpetSea: CustomStringConvertible {
    var N: Int = 2
    var cells: [Cell] = []
    var availableFish: [String: Int] = ["🐟": 5, "🐙": 10, "🦈":15, "🐳":20]
    var fishString: Int = 0
    var description: String {
        return "\(cells)"
    }

    func createCells() {
        for rowNum in 1...N {
            for colNum in 1...N {
                cells.append(Cell(row: rowNum, col: colNum))
            }
        }
    }
//randomly selects a cell to place a randomly selected fish
    func randomlyPlaceFish() -> Cell {
        let i = Int.random(in: 0...cells.count - 1)
        fishString = Int.random(in: 0...availableFish.count - 1)
        let strings = availableFish.map {$0.0}
        let theFish = strings[fishString]
        cells[i].placeFish(fish: theFish)
        print(cells)
        return cells[i]
    }
//updates the selected cell's containsLine property
    func dropFishingLine(cellNum: Int) {
        cells[cellNum].placeLine()
    }
//returns true if the fish is caught
    func checkFishCaught(cell: Cell) -> Bool {
        if cell.containsLine {
            return true
        }
        return false
    }
//returns the fish string and score from the cell
    func setFishScore(cell: Cell) -> [String:Int] {
        let strings = availableFish.map {$0.0}
        let nums = availableFish.map {$0.1}
        let theFish = strings[fishString]
        let score = nums[fishString]
        return [theFish: score]
    }

    func clearCells() {
        for i in 0...cells.count-1 {
            cells[i].clearCell()
        }
    }
}
