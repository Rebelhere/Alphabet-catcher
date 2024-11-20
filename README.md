# CatchAlphabets Game - Computer Organization and Assembly Language (COAL)

## Project Description
**CatchAlphabets** is an interactive game developed for the **Intel 8088 microprocessor**, showcasing low-level assembly language programming skills. The game runs on **DOSBox** with NASM, allowing players to control a **bucket** and catch falling alphabets to score points while avoiding penalties. It features a main menu, dynamic gameplay, and creative endgame elements, making it an excellent demonstration of interrupt handling, custom functions, and real-time user interaction.

---

## Features

### **Core Gameplay**:
1. **Main Menu**:
   - At launch, a **main page** is displayed prompting the user to:
     - **Press any key (except Esc)** to start the game.
     - Pressing **Esc** displays the credits and exits the program.

2. **Bucket Mechanics**:
   - A **bucket** (`ASCII value 0xDC`) is displayed at the **bottom-middle** of the screen when the game starts.
   - The bucket can be moved using the **arrow keys**:
     - **Left Arrow** (`0x4B`): Move the bucket left.
     - **Right Arrow** (`0x4D`): Move the bucket right.

3. **Falling Alphabets**:
   - Alphabets (`A-Z`) appear at random positions in the top row and fall toward the bucket.
   - At least **5 alphabets** fall simultaneously at varying speeds.
   - The speed of falling alphabets can be adjusted in the **source code**.

4. **Scoring System**:
   - Catching an alphabet adds **1 point** to the score.
   - The score is displayed in the **top-right corner** of the screen.

5. **Game Over Condition**:
   - Missing **10 alphabets** ends the game.
   - The player's **final score** is displayed in the **middle of the screen** for a few seconds before transitioning to the credits.

6. **Credits Scroll**:
   - After displaying the final score or pressing **Esc** at the main menu, a scrolling credits screen plays to conclude the game.

---

## How to Run
1. Install **DOSBox** and **NASM**.
2. Place the `CatchAlphabets.asm` file in your working directory.
3. Assemble the game for the 8088:
   ```
   nasm -f bin CatchAlphabets.asm -o CatchAlphabets.com
   ```
4. Run the game in DOSBox:
   ```
   CatchAlphabets.com
   ```

---

## Gameplay Instructions
1. **Main Menu**:
   - Press any key (except **Esc**) to start the game.
   - Press **Esc** to display the credits and exit.

2. **Move the Bucket**:
   - Use the **left arrow key** (`0x4B`) to move the bucket left.
   - Use the **right arrow key** (`0x4D`) to move the bucket right.

3. **Catch Alphabets**:
   - Align the bucket with falling alphabets to catch them and score points.

4. **Avoid Misses**:
   - The game ends if **10 alphabets** are missed.

---

## Code Features
- **Custom Random Function**:  
  Generates random positions and speeds for falling alphabets.
- **Real-Time Input**:  
  Hooks into **INT 9h** for responsive keyboard controls.
- **Adjustable Speed**:  
  The falling speed of alphabets can be modified in the **source code**.
- **Score Display on Game Over**:  
  At the end of the game, the final score is shown in the **middle of the screen** for a few seconds.
- **Main Menu and Credits**:  
  A main menu prompts the user to start or quit. A scrolling credits screen concludes the game.

---

## Future Enhancements
1. **Level System**:
   - Introduce progressive levels, increasing difficulty with:
     - Faster alphabets.
     - More falling items simultaneously.

2. **Bomb Mechanic**:
   - Add **bombs** that fall alongside alphabets.
   - If the bucket catches a bomb, the player experiences an **instant game over**.

3. **Power-Ups**:
   - Introduce special alphabets that grant bonuses, such as:
     - Double points.
     - Temporarily slowing down falling items.

4. **Sound Effects**:
   - Add audio cues for catching alphabets, missing them, and the game over.

---

## Credits
- **Developer**: Muhammad Rahim (*Rebelhere*)  
- **Special Thanks**: Ayesha Younus  

**CatchAlphabets - A nostalgic and exciting gaming experience on the Intel 8088!**

---

## Contributing
Feel free to open issues or submit pull requests for improvements or bug fixes.

---

## Collaboration Guidelines
We welcome contributions from the open-source community. If you'd like to collaborate on this project, please adhere to the following guidelines:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Implement your changes and commit them with descriptive messages.
4. Push your branch to your fork and submit a pull request.

---

### Feel free to reach out if you have any questions or suggestions !
