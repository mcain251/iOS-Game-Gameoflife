//
//  GameScene.swift
//  Gameoflife
//
//  Created by Marshall Cain on 6/22/17.
//  Copyright © 2017 Marshall Cain. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var playButton: MSButtonNode!
    var pauseButton: MSButtonNode!
    var stepButton: MSButtonNode!
    var wrapButton: MSButtonNode!
    var wrapButton2: MSButtonNode!
    var resetButton: MSButtonNode!
    var speedButton1: MSButtonNode!
    var speedButton2: MSButtonNode!
    var speedButton3: MSButtonNode!
    var speedButton4: MSButtonNode!
    var grid: Grid!
    var populationLabel: SKLabelNode!
    var generationLabel: SKLabelNode!
    var delay = 0.25
    var playing = false
    var timer = 0.0
    let fixedDelta = 1.0/60.0
    var wrap = true
    var end = false
    
    // Scene setup
    override func didMove(to view: SKView) {
        
        // Set reference to the play button
        playButton = self.childNode(withName: "playButton") as! MSButtonNode
        
        // Set reference to the pause button
        pauseButton = self.childNode(withName: "pauseButton") as! MSButtonNode
        
        // Set reference to the step button
        stepButton = self.childNode(withName: "stepButton") as! MSButtonNode
        
        // Set reference to the wrap button
        wrapButton = self.childNode(withName: "wrapButton") as! MSButtonNode
        wrapButton2 = self.childNode(withName: "wrapButton2") as! MSButtonNode
        wrapButton2.state = .MSButtonNodeStateHidden
        
        // Set reference to the reset button
        resetButton = self.childNode(withName: "resetButton") as! MSButtonNode
        
        // Set reference to the speed buttons
        speedButton1 = self.childNode(withName: "speedButton1") as! MSButtonNode
        speedButton2 = self.childNode(withName: "speedButton2") as! MSButtonNode
        speedButton3 = self.childNode(withName: "speedButton3") as! MSButtonNode
        speedButton4 = self.childNode(withName: "speedButton4") as! MSButtonNode
        
        // Set reference to the grid
        grid = self.childNode(withName: "gridNode") as! Grid!
        
        // Set reference to the population label
        populationLabel = self.childNode(withName: "populationLabel") as! SKLabelNode!
        
        // Set reference to the generation label
        generationLabel = self.childNode(withName: "generationLabel") as! SKLabelNode!
        
        // Play button functionality
        playButton.selectedHandler = {
            
            // Resets generation counter if game ended
            if self.end {
                self.grid.generation = 0
                self.generationLabel.text = "0"
                self.end = false
            }
            
            if (self.grid.population != 0){
                self.playing = true
            }
        }
        
        // Pause button functionality
        pauseButton.selectedHandler = {
            
            // Resets generation counter if population is 0
            if !self.playing && self.grid.population == 0 {
                self.grid.generation = 0
                self.generationLabel.text = "0"
            }
            self.playing = false
        }
        
        // Step button functionality
        stepButton.selectedHandler = {
            
            // Moves the simulation forward
            self.stepSimulation()
        }
        
        // Reset button functionality
        resetButton.selectedHandler = {
            
            // Resets the counters and pauses the game
            self.grid.population = 0
            self.grid.generation = 0
            self.populationLabel.text = "0"
            self.generationLabel.text = "0"
            self.playing = false
            
            // Clears the grid
            self.grid.clear()
        }
        
        // Wrap button functionality
        wrapButton.selectedHandler = {
            
            // toggles the wrap feature
            self.grid.warp = !self.grid.warp
            
            // toggles the red icon
            if (self.grid.warp) {
                self.wrapButton2.state = .MSButtonNodeStateHidden
            }
            else {
                self.wrapButton2.state = .MSButtonNodeStateActive
            }
        }
        
        // Speed button functionalities
        speedButton1.selectedHandler = {
            
            // sets the speed to 2 fps
            self.delay = 0.5
        }
        
        speedButton2.selectedHandler = {
            
            // sets the speed to 4 fps
            self.delay = 0.25
        }
        
        speedButton3.selectedHandler = {
            
            // sets the speed to 10 fps
            self.delay = 0.1
        }
        
        speedButton4.selectedHandler = {
            
            // sets the speed to 100 fps
            self.delay = 0.01
        }
    }
    
    
    // Moves the simulation one step forward
    func stepSimulation() {
        
        // Steps the simulation
        self.grid.evolve()
        
        // Updates the labels
        self.populationLabel.text = "\(self.grid.population)"
        self.generationLabel.text = "\(self.grid.generation)"
    }

    // Called when a touch begins
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    // Called before each frame
    override func update(_ currentTime: TimeInterval) {
        if playing {
            if timer > delay {
                stepSimulation()
                timer = 0.0
            }
            else {
                timer += fixedDelta
            }
        }
        populationLabel.text = "\(grid.population)"
        if (grid.population == 0 && grid.generation > 0){
            playing = false
            end = true
        }
    }
}
