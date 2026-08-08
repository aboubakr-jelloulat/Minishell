<div align="center">

# MINISHELL

**A Unix shell rebuilt from the ground up no shortcuts, no library doing the thinking for you**

![GNU/Linux](https://img.shields.io/badge/GNU%2FLinux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Shell](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![C](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)
[![42](https://img.shields.io/badge/42-Project-000000?style=for-the-badge&logo=42&logoColor=white)](https://www.42network.org/)

![Terminal demo](https://readme-typing-svg.demolab.com/?font=Fira+Code&size=20&duration=2500&pause=800&color=39FF14&background=0D1117&center=true&vCenter=true&width=600&height=60&lines=minishell%24+ls+-la+%7C+grep+%22.c%22+%7C+wc+-l;minishell%24+export+PATH%3D%24PATH%3A.%2Fbin;minishell%24+cat+%3C%3C+EOF;minishell%24+echo+%22built+from+scratch+in+C%22)

</div>

---

## Overview

Minishell is a working reimplementation of the core of `bash`, built entirely from scratch in C. It parses a command line the way a real shell does, resolves it into an executable pipeline, and runs it handling built-ins, environment variables, pipes, redirections, and signals along the way.

The point of the project is not to copy bash's output, but to understand what actually happens between typing a command and seeing a process run: tokenizing, parsing, expansion, forking, and process control.

## What It Handles

**Parsing and execution**
- Full command execution with argument and path resolution
- Pipes (`|`) chaining any number of commands together
- Redirections: input (`<`), output (`>`), append (`>>`), heredoc (`<<`)
- Single and double quote parsing, including nested cases
- `$VAR` and `${VAR}` environment variable expansion
- Correct exit status propagation for every command

**Signals**
- `Ctrl+C` interrupts the running command and returns to a fresh prompt
- `Ctrl+D` exits the shell cleanly on an empty line
- `Ctrl+\` is ignored at the prompt and handled properly inside child processes

## Requirements

- `readline`  command-line editing and history
- `termcap`  terminal capability database, required by readline

## Installation

**Ubuntu / Debian**
```bash
sudo apt-get update
sudo apt-get install libreadline-dev
```

**Fedora**
```bash
sudo dnf install readline-devel
```

**macOS**
```bash
brew install readline
```

**Build and run**
```bash
git clone https://github.com/aboubakr-jelloulat/Minishell.git
cd Minishell
make
./minishell
```

## Usage

**Basic commands**
```bash
minishell$ ls -la
minishell$ pwd
minishell$ echo "Hello, World!"
```

**Environment variables**
```bash
minishell$ export MY_VAR="Hello"
minishell$ echo $MY_VAR
minishell$ unset MY_VAR
```

**Pipes and redirections**
```bash
minishell$ ls -la | grep ".c" | wc -l
minishell$ echo "Hello" > output.txt
minishell$ wc -l < input.txt
minishell$ echo "World" >> output.txt
```

**Heredoc**
```bash
minishell$ cat << EOF
> This is a here document
> Multiple lines supported
> EOF
```

**Quoting**
```bash
minishell$ echo "Hello $USER"      # expanded
minishell$ echo 'Hello $USER'      # literal
minishell$ echo "It's a \"test\""  # escaped
```

## Architecture

```
Lexer  ─────▶  Parser  ─────▶  Executor
(tokenizer)    (AST builder)    (command runner)

   │               │                │
   ▼               ▼                ▼
Input &        Syntax analysis   Process control
history         & validation      & built-ins
```

## Project Structure

```
minishell/
├── includes/
│   ├── enums.h
│   ├── minishell.h
│   ├── prototypes.h
│   └── structs.h
├── src/
│   ├── builtins/       built-in command implementations
│   ├── env/             environment variable management
│   ├── Error/            error handling and reporting
│   ├── exec/              command execution and process management
│   ├── heredoc/            here-document implementation
│   ├── lib/                 custom library functions
│   ├── parsing/               syntax analysis and command parsing
│   ├── redirection/            input/output redirection handling
│   ├── tokenizer/                lexical analysis
│   └── main.c                       entry point and main loop
└── Makefile
```
