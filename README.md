A Flutter application featuring an interactive spin wheel for prize giveaways, with support for Arabic text and Excel export functionality.

![image](https://github.com/user-attachments/assets/a2ba08c1-8487-45fa-8228-0d9856384b51)
![image](https://github.com/user-attachments/assets/01c949f0-27e5-412a-99b3-f56d1dcf3cbc)
![image](https://github.com/user-attachments/assets/564d04d1-b7d8-49a9-a07c-820e4c38837c)
![image](https://github.com/user-attachments/assets/ac201ef8-6957-4731-869e-c4e83100f191)
![image](https://github.com/user-attachments/assets/b4bcdf91-74f0-4d6c-9346-87e1753dd350)
![image](https://github.com/user-attachments/assets/fabcbe60-8a61-4c58-afa5-a721e2bec763)
![image](https://github.com/user-attachments/assets/d55d4bf9-11df-43ea-9b16-1ca1e78ecb62)
![image](https://github.com/user-attachments/assets/04bb09f2-8802-4583-8430-b8c2ca13fd93)



## Features

- Interactive spinning wheel with confetti animations
- Support for Arabic participant names
- Guest mode with separate prize pool
- Export results to Excel (Windows & Android)
- **Fullscreen toggle** (press ESC to exit, ENTER to enter fullscreen)
- Responsive design for different screen sizes

## Fullscreen Mode Controls
The app includes keyboard-controlled fullscreen mode:

ENTER key: Toggle fullscreen mode ON

ESC key: Toggle fullscreen mode OFF

Note: Fullscreen mode works best in desktop environments.

## How to Use
Main Game:

Click "Start Game" to begin

Spin the wheel to select participants

Prizes are automatically awarded

Guest Mode:

Access via the floating action button

Separate pool of participants and prizes

Export guest results separately

Exporting Results:

Main game results can be exported from Results screen

Guest results can be exported from Guest Results screen

Files are saved to Downloads folder (Windows) or Documents (Android)

Technical Details
Built with Flutter 3.0+

Uses Provider for state management

Key dependencies:

flutter_fortune_wheel for the spinning wheel

excel for export functionality

confetti for celebration animations

open_file to view exported files
