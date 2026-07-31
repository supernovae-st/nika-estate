# the-bite.tape — the hundred-year machinery in ~14 seconds: the ledger
# agrees with the tree, a staged edit diverges it, the gate refuses
# loud, the restore brings it back. Recorded on a real carrier repo
# (nika-registry, byte-identical shared tool); scripts/media/render.sh
# stages the copy. House theme = the engine's nika-hero palette + the
# v2 window chrome.
Output the-bite.gif

Set Shell zsh
Set FontFamily "JetBrains Mono"
Set FontSize 21
Set Width 1420
Set Height 780
Set Padding 24
Set Margin 22
Set MarginFill "#4f86ff"
Set BorderRadius 14
Set WindowBar Colorful
Set WindowBarSize 42
Set Theme { "name": "nika", "background": "#08090b", "foreground": "#dbe3ee", "cursor": "#4f86ff", "black": "#10131a", "red": "#ff6b6b", "green": "#34d399", "yellow": "#f0b45b", "blue": "#4f86ff", "magenta": "#b07bff", "cyan": "#22d3ee", "white": "#dbe3ee", "brightBlack": "#5b6472", "brightRed": "#ff8f8f", "brightGreen": "#5ee6b0", "brightYellow": "#ffd08a", "brightBlue": "#8db4ff", "brightMagenta": "#c9a2ff", "brightCyan": "#67e3f5", "brightWhite": "#ffffff" }
Set TypingSpeed 30ms
Set PlaybackSpeed 1.0

Hide
Type "cd /tmp/estate-demo && export TMPDIR=/tmp && unset -m '*API_KEY*' '*_TOKEN*' '*SECRET*' 2>/dev/null; setopt interactive_comments && clear"
Enter
Show

Type "# every file: AUTHORED bytes or a proven derivation · the ledger agrees with the tree"
Enter
Sleep 700ms
Type "python3 scripts/estate.py --check"
Enter
Sleep 2400ms

Type "# stage one silent edit — the gate must refuse"
Enter
Sleep 700ms
Type "echo '# tweak' >> README.md && git add README.md"
Enter
Sleep 600ms
Type "python3 scripts/estate.py --check"
Enter
Sleep 2800ms

Type "# undo it — the ledger and the tree agree again"
Enter
Sleep 700ms
Type "git restore --staged README.md && git restore README.md"
Enter
Sleep 600ms
Type "python3 scripts/estate.py --check"
Enter
Sleep 2600ms
Sleep 1400ms
