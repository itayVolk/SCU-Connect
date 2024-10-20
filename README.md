
# SCU SSH Hotkeys

Adds hotkeys for various SCU SSH/Git related things

## Setup

1. If you plan to use the VPN features: download the cisco VPN from [here](https://www.scu.edu/technology/get-connected/networking/how-to-access-vpn/) and set it to remember your username.
1. If you plan to use github: create a classic personal access token using [this guide](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic) and copy it to your clipboard.
1. Open the app and input your data.

## Hotkeys

Always Active:
| Hotkey              | Action                                              |
|---------------------|-----------------------------------------------------|
| Window + Ctrl + r | Reopen setup window to input new data
Windows + Ctrl + v         | Connect/disconnect to SCU VPN                       |
| Windows + Ctrl + Alt + v | Connect to SSH/Maximize window if already connected |

Only active in SSH:
| Hotkey         | Action                                |
|----------------|---------------------------------------|
| Ctrl + v       | Attempt to paste computer's clipboard |
| Ctrl + Alt + v | Paste SSH clipboard                   |
| Ctrl + s       | Save and exit VIM                     |
| Ctrl + Alt + s | Send normal Ctrl + s                  |
| Ctrl + p       | Open a commit/push window             |
| Ctrl + f       | Fetch and pull                        |
| Ctrl + t       | Open a tar window                     |
| Ctrl + i       | Open a git initialization window      |
Ctrl + r | Make git store details next time you input
Ctrl + Alt + r | Type stored username and password