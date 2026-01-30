![GNU/Linux](https://img.shields.io/badge/GNU%2FLinux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Shell](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![C](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)
![Makefile](https://img.shields.io/badge/Makefile-003366?style=for-the-badge&logo=cmake&logoColor=white)


# 🐚 Minishell





## Overview

**Minishell** is a simplified implementation of a Unix shell This project recreates the core functionality of bash, providing users with a command-line interface to interact with the operating system. The shell supports command execution, built-in commands, environment variable management, and advanced features like pipes and redirections.


### Advanced Features
- **Pipes (`|`)**: Connect multiple commands for data flow
- **Redirections**: 
  - Input redirection (`<`)
  - Output redirection (`>`)
  - Append redirection (`>>`)
  - Here document (`<<`)
- **Quote Handling**: Proper parsing of single and double quotes
- **Variable Expansion**: Support for `$VAR` and `${VAR}` syntax
- **Exit Status**: Proper handling of command exit codes

### Signal Management
- **CTRL+C**: Interrupt current command
- **CTRL+D**: Exit shell gracefully
- **CTRL+\\**: Quit signal handling


### Required Libraries
- `readline` - Command line editing and history
- `termcap` - Terminal capability database (dependency of readline)

## Installation

### Step 1: Install Readline Library

#### On Linux (Ubuntu/Debian):
```bash
sudo apt-get update
sudo apt-get install libreadline-dev
```

#### On Linux (CentOS/RHEL/Fedora):
```bash
# CentOS/RHEL
sudo yum install readline-devel

# Fedora
sudo dnf install readline-devel
```

#### On macOS:
```bash
# Using Homebrew (recommended)
brew install readline

# Using MacPorts
sudo port install readline
```

### Step 2: Clone and Build

```bash
# Clone the repository
git clone https://github.com/aboubakr-jelloulat/Minishell.git
cd Minishell

# Compile the project
make

# Clean build files (optional)
make clean
```

### Step 3: Run Minishell

```bash
./minishell
```

##  Usage

### Basic Command Execution
```bash
minishell$ ls -la
minishell$ pwd
minishell$ echo "Hello, World!"
```

### Environment Variables
```bash
minishell$ export MY_VAR="Hello"
minishell$ echo $MY_VAR
minishell$ unset MY_VAR
```

### Pipes and Redirections
```bash
# Using pipes
minishell$ ls -la | grep ".c" | wc -l

# Output redirection
minishell$ echo "Hello" > output.txt
minishell$ cat output.txt

# Input redirection
minishell$ wc -l < input.txt

# Append redirection
minishell$ echo "World" >> output.txt
```

### Here Document
```bash
minishell$ cat << EOF
> This is a here document
> Multiple lines supported
> EOF
```

### Quote Handling
```bash
minishell$ echo "Hello $USER"     # Variable expansion
minishell$ echo 'Hello $USER'     # Literal string
minishell$ echo "It's a \"test\""  # Escaped quotes
```

## 📡 Signal Handling

Minishell properly handles Unix signals to provide a smooth user experience:

- **SIGINT (Ctrl+C)**: Interrupts the current command and displays a new prompt
- **SIGQUIT (Ctrl+\\)**: Ignored in interactive mode, handled in child processes
- **EOF (Ctrl+D)**: Cleanly exits the shell

##  Technical Implementation

### Architecture Overview
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Lexer       │───▶│     Parser      │───▶│    Executor     │
│   (Tokenizer)   │    │  (AST Builder)  │    │ (Command Runner)│
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Input Handling  │    │ Syntax Analysis │    │ Process Control │
│   & History     │    │   & Validation  │    │   & Built-ins   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

##  Project Structure

```
MINISHELL/
├── includes/
│   ├── enums.h         # Enumeration definitions
│   ├── minishell.h     # Main header file
│   ├── prototypes.h    # Function prototypes
│   └── structs.h       # Data structure definitions
├── src/
│   ├── .build/         # Build artifacts and object files
│   ├── builtins/       # Built-in command implementations
│   ├── env/            # Environment variable management
│   ├── Error/          # Error handling and reporting
│   ├── exec/           # Command execution and process management
│   ├── heredoc/        # Here document implementation
│   ├── lib/            # Custom library functions
│   ├── parsing/        # Syntax analysis and command parsing
│   ├── redirection/    # Input/output redirection handling
│   ├── tokenizer/      # Tokenization and lexical analysis
│   └── main.c          # Entry point and main loop
├── Makefile            # Build configuration
└── README.md           # This file
```


---
