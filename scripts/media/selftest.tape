# selftest.tape — the other half of the proof, in ~15 seconds: a gate that
# only says yes proves nothing, so the self-test builds a throwaway
# repository, plants one known mistake at a time and checks each verdict and
# exit code. Every line is the self-test's own output; scripts/media/render.sh
# stages a copy of this repository's scripts/. House theme = the engine's
# nika-hero palette.
Output selftest.gif

Set Shell zsh
Set FontFamily "JetBrains Mono"
Set FontSize 21
Set Width 1420
Set Height 880
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
Type "cd /tmp/estate-selftest-demo && export TMPDIR=/tmp && unset -m '*API_KEY*' '*_TOKEN*' '*SECRET*' 2>/dev/null; setopt interactive_comments && clear"
Enter
Show

Type "# a gate that only says yes proves nothing · plant one mistake at a time"
Enter
Sleep 600ms
Type "python3 scripts/selftest.py"
Enter
Wait@90s
Sleep 4500ms
