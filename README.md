# Another attempt at neovim configuration.

## Motivation:

- Emacs is great but:
	- Single threaded
	- Elisp is great but like Lua more
	- DAP is broken on emacs (hangs when investigating complex java variables)
- What about systems where I only have access to terminal? Emacs from terminal is cray-cray.
- Love tmux.
- Why not use old config?
	- Want to try lazy.nvim.
	- Want to move away from lsp-zero and set the whole thing up on my own.
	- Don't want to be scared of plugins setups.

## Goals:

- Have a light and fast setup.
- Make it look pretty.
- Needs to be fully functional with Python, C++ and Java.
- Fully functional means:
	- LSP.
	- DAP.
	- Tree-sitter.

## TODO:

- DAP
- JDTLS
- Autoformatting (null-ls)

