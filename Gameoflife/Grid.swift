//
//  Grid.swift
//  Gameoflife
//
//  Created by Marshall Cain on 6/22/17.
//  Copyright © 2017 Marshall Cain. All rights reserved.
//

import SpriteKit

class Grid: SKSpriteNode {
    
    // 2D array storing the creatures
    var gridArray = [[Creature]]()
    
    // Grid array dimensions
    let rows = 8
    let columns = 10
    
    // Cell dimensions, calculated during initialization
    var cellWidth = 0
    var cellHeight = 0
    
    // Counters for population and generation
    var population = 0
    var generation = 0
    
    // Toggle for the warp functionality
    var warp = true
    
    // Adds a creature to the grid
    func addCreatureAtGrid(x: Int, y: Int){
        
        // Initialize a new creature
        let creature = Creature()
        
        // Set its grid screen position
        creature.position = CGPoint(x: x * cellWidth - (x)/4 + 3,y: y * cellHeight - (y)/4 + 4)
        
        // Make it a child of the grid
        addChild(creature)
        
        // Add it to the grid array
        gridArray[x].append(creature)
    }
    
    // Populates the grid array with creatures
    func populateGrid() {
        
        // Loops through columns
        for x in 0 ..< columns {
            
            // Adds an empty column to the array
            gridArray.append([])
            
            // Loops through rows
            for y in 0 ..< rows {
                
                // Adds a new creature
                addCreatureAtGrid(x: x, y: y)
            }
        }
    }
    
    // Counts and assigns the number of living neighbors to each creature
    func countNeighbors() {
        
        // Loop through each creature
        for x in 0 ..< columns {
            for y in 0 ..< rows {
                
                // Reset the neighborCount to 0
                gridArray[x][y].neighborCount = 0
                
                // Creates an array of neighbors positions
                var neighborArray: [(x: Int,y: Int)] = []
                for nx in x - 1 ... x + 1 {
                    for ny in y - 1 ... y + 1 {
                        if warp {
                            let tup = ((nx + columns)%columns, (ny + rows)%rows)
                            neighborArray.append(tup)
                        }
                        else if (nx >= 0 && nx < columns && ny >= 0 && ny < rows){
                            let tup = (nx, ny)
                            neighborArray.append(tup)
                        }
                    }
                }
                
                // Loop through each neighbor
                for neighbor in neighborArray {
                    
                    // Make sure it doesn't count itself, then counts alive neighbors
                    if (neighbor.x != x || neighbor.y != y) && gridArray[neighbor.x][neighbor.y].isAlive {
                        gridArray[x][y].neighborCount += 1
                    }
                }
                
            }
        }
    }
    
    // Updates the state of each creature based on the number of neighbors it has
    func updateCreatures() {
        
        // Reset population counter
        population = 0
        
        // Loop through each creature
        for x in 0 ..< columns {
            for y in 0 ..< rows {
                
                // Apply the rules
                switch gridArray[x][y].neighborCount {
                case 3:
                    gridArray[x][y].isAlive = true
                    break;
                case 0...1, 4...8:
                    gridArray[x][y].isAlive = false
                    break;
                default:
                    break;
                }
                
                // Update population count
                if gridArray[x][y].isAlive {
                    population += 1
                }
            }
        }
    }
    
    // Updates the grid to the next state
    func evolve() {
        
        // Update creatures' neighbor count
        countNeighbors()
        
        // Update creatures' life status
        updateCreatures()
        
        // Increase the generation counter
        generation += 1
    }
    
    // Called when touch begins
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Only allows one touch
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // Converts the location into a grid location
        let gridX = Int(location.x) / cellWidth
        let gridY = Int(location.y) / cellHeight
        
        // Makes the creature at the desired location alive or dead
        gridArray[gridX][gridY].isAlive = !gridArray[gridX][gridY].isAlive
        
        // Changes the population counter
        if gridArray[gridX][gridY].isAlive {
            population += 1
        }
        else {
            population -= 1
        }
    }
    
    // Sets all the creatures to dead
    func clear() {
        for x in 0 ..< columns {
            for creature in gridArray[x] {
                creature.isAlive = false
            }
        }
    }
    
    // Required to inherit SKSpriteNode
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Enable touch
        isUserInteractionEnabled = true
        
        // Calculate cell dimensions
        cellWidth = Int(size.width) / columns
        cellHeight = Int(size.height) / rows
        
        // Populate grid with creatures
        populateGrid()
    }
}
