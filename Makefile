################################################  #############################################

################################################
#           OS DETECTION & SETUP              #
################################################

# OS Detection and readline installation check
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
    ################################################
    #                   macOS                      #
    ################################################
    
    # Check if Homebrew is installed
    BREW_EXISTS := $(shell command -v brew >/dev/null 2>&1 && echo "yes" || echo "no")
    ifeq ($(BREW_EXISTS),no)
        $(info $(RED)$(BOLD)ERROR: Homebrew not found!$(RESET))
        $(info $(YELLOW)Please install Homebrew first:$(RESET))
        $(info $(CYAN)/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"$(RESET))
        $(error Homebrew is required for macOS installation)
    endif
    
    # Check if readline is installed via Homebrew
    READLINE_INSTALLED := $(shell brew list readline 2>/dev/null && echo "yes" || echo "no")
    ifeq ($(READLINE_INSTALLED),no)
        $(info $(YELLOW)$(BOLD)Readline not found on macOS. Installing via Homebrew...$(RESET))
        INSTALL_RESULT := $(shell brew install readline 2>&1)
        INSTALL_CHECK := $(shell brew list readline 2>/dev/null && echo "success" || echo "failed")
        ifeq ($(INSTALL_CHECK),failed)
            $(info $(RED)$(BOLD)Failed to install readline automatically!$(RESET))
            $(info $(YELLOW)Please run manually: $(CYAN)brew install readline$(RESET))
            $(error Readline installation failed)
        else
            $(info $(GREEN)$(BOLD)✓ Readline successfully installed!$(RESET))
        endif
    endif
    
    READLINE_DIR := $(shell brew --prefix readline 2>/dev/null)
    OS_MSG = "$(GREEN)$(BOLD)OS DETECTED: macOS - Readline ready!$(RESET)"

else ifeq ($(UNAME_S),Linux)
    ################################################
    #                   LINUX                      #
    ################################################
    
    # Detect Linux distribution
    DISTRO := unknown
    ifneq ($(shell command -v apt-get 2>/dev/null),)
        DISTRO := debian
        PKG_MANAGER := apt-get
        READLINE_PKG := libreadline-dev
        INSTALL_CMD := sudo apt-get update && sudo apt-get install -y
    else ifneq ($(shell command -v yum 2>/dev/null),)
        DISTRO := redhat
        PKG_MANAGER := yum
        READLINE_PKG := readline-devel
        INSTALL_CMD := sudo yum install -y
    else ifneq ($(shell command -v dnf 2>/dev/null),)
        DISTRO := fedora
        PKG_MANAGER := dnf
        READLINE_PKG := readline-devel
        INSTALL_CMD := sudo dnf install -y
    else ifneq ($(shell command -v pacman 2>/dev/null),)
        DISTRO := arch
        PKG_MANAGER := pacman
        READLINE_PKG := readline
        INSTALL_CMD := sudo pacman -S --noconfirm
    else ifneq ($(shell command -v zypper 2>/dev/null),)
        DISTRO := opensuse
        PKG_MANAGER := zypper
        READLINE_PKG := readline-devel
        INSTALL_CMD := sudo zypper install -y
    endif
    
    # Check if readline development libraries are installed
    READLINE_INSTALLED := $(shell pkg-config --exists readline && echo "yes" || echo "no")
    ifeq ($(READLINE_INSTALLED),no)
        $(info $(YELLOW)$(BOLD)Readline development libraries not found on Linux!$(RESET))
        $(info $(CYAN)Detected distribution: $(DISTRO) ($(PKG_MANAGER))$(RESET))
        
        ifeq ($(DISTRO),unknown)
            $(info $(RED)$(BOLD)Unknown Linux distribution!$(RESET))
            $(info $(YELLOW)Please install readline development libraries manually:$(RESET))
            $(info $(CYAN)- Debian/Ubuntu: sudo apt-get install libreadline-dev$(RESET))
            $(info $(CYAN)- Red Hat/CentOS: sudo yum install readline-devel$(RESET))
            $(info $(CYAN)- Fedora: sudo dnf install readline-devel$(RESET))
            $(info $(CYAN)- Arch Linux: sudo pacman -S readline$(RESET))
            $(info $(CYAN)- openSUSE: sudo zypper install readline-devel$(RESET))
            $(error Manual installation required)
        else
            $(info $(YELLOW)To install readline, run:$(RESET))
            $(info $(CYAN)$(INSTALL_CMD) $(READLINE_PKG)$(RESET))
            $(info $(RED)$(BOLD)Please install readline development libraries and try again.$(RESET))
            $(error Readline development libraries required)
        endif
    endif
    
    OS_MSG = "$(GREEN)$(BOLD)OS DETECTED: Linux ($(DISTRO)) - Readline ready!$(RESET)"

else
    ################################################
    #                UNSUPPORTED                   #
    ################################################
    $(info $(RED)$(BOLD)Unsupported operating system: $(UNAME_S)$(RESET))
    $(info $(YELLOW)This Makefile supports:$(RESET))
    $(info $(CYAN)- macOS (Darwin) with Homebrew$(RESET))
    $(info $(CYAN)- Linux distributions (Debian/Ubuntu, Red Hat/CentOS, Fedora, Arch, openSUSE)$(RESET))
    $(error Please use a supported operating system)
endif

################################################
#             COMPILER SETTINGS                #
################################################

#System detection
ifeq ($(UNAME_S),Darwin)
	READLINE_DIR := $(shell brew --prefix readline)
	CFLAGS       = -Wall -Wextra -Werror -D_GNU_SOURCE -I$(INCLUDE_DIR) -I$(READLINE_DIR)/include
	LDFLAGS      = -L$(READLINE_DIR)/lib -lreadline -lhistory
	os_msg = "$(GREEN)OS DETECTED Mac!$(RESET)"

else ifeq ($(UNAME_S),Linux)
	CFLAGS       = -Wall -Wextra -Werror -Wunreachable-code -D_GNU_SOURCE -I$(INCLUDE_DIR)
	LDFLAGS      = -lreadline -lhistory -lncurses
	os_msg = "$(GREEN)OS DETECTED Linux!$(RESET)"
endif

CC           = cc
# CFLAGS       = -Wall -Wextra -Werror -Wunreachable-code -I$(INCLUDE_DIR) -I$(READLINE_DIR)/include

# CFLAGS       = -Wall -Wextra -Werror -Wunreachable-code
# LDFLAGS      = -lreadline -lhistory -lncurses
#CFLAGS      += -Wall -Wextra -Werror -fsanitize=address -g3

# LDFLAGS      = -L$(READLINE_DIR)/lib -lreadline -lhistory -lncurses

################################################
#                 DIRECTORIES                  #
################################################

SRC_DIR      = src
BUILD_DIR    = $(SRC_DIR)/.build
INCLUDE_DIR  = includes

# Sub directories
BUILTINS_DIR = $(SRC_DIR)/builtins
LIB_DIR      = $(SRC_DIR)/lib
ENV_DIR      = $(SRC_DIR)/env
ERROR_DIR    = $(SRC_DIR)/Error
EXEC_DIR     = $(SRC_DIR)/exec
HEREDOC_DIR  = $(SRC_DIR)/heredoc
PARSING_DIR  = $(SRC_DIR)/parsing
REDIR_DIR    = $(SRC_DIR)/redirection
TOKEN_DIR    = $(SRC_DIR)/tokenizer

################################################
#                  FILES                       #
################################################

# Define the executable name
NAME         = minishell

# HEADERS
HEADERS      = $(wildcard $(INCLUDE_DIR)/*.h)

# Define source files
MAIN_SRC     = $(SRC_DIR)/main.c

# Builtin sources
BUILTINS_SRC = $(wildcard $(BUILTINS_DIR)/*.c)

# Other sub sources
ENV_SRC      = $(wildcard $(ENV_DIR)/*.c)
EXEC_SRC     = $(wildcard $(EXEC_DIR)/*.c)
HEREDOC_SRC  = $(wildcard $(HEREDOC_DIR)/*.c)
PARSING_SRC  = $(wildcard $(PARSING_DIR)/*.c)
REDIR_SRC    = $(wildcard $(REDIR_DIR)/*.c)
TOKEN_SRC    = $(wildcard $(TOKEN_DIR)/*.c)
ERROR_SRC	 = $(wildcard $(ERROR_DIR)/*.c)

# Combine all sources
SRCS         = $(MAIN_SRC) \
               $(BUILTINS_SRC) \
               $(ENV_SRC) \
               $(EXEC_SRC) \
               $(HEREDOC_SRC) \
               $(PARSING_SRC) \
               $(REDIR_SRC) \
               $(SIGNALS_SRC) \
               $(TOKEN_SRC) \
			   $(ERROR_SRC)


# Generate object file paths
OBJS         = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRCS))
DEPS         = $(OBJS:.o=.d)

# LIBFT

LIB          = $(LIB_DIR)/libft.a
LIB_HDR      = $(LIB_DIR)/libft.h

################################################
#                   RULES                      #
################################################

.PHONY: all clean fclean re libclean libfclean debug norm banner practice check-os

# Default target
all: check-os $(NAME)

# Check OS and display message
check-os:
	@printf $(OS_MSG)

# Create build directory structure
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/builtins
	@mkdir -p $(BUILD_DIR)/env
	@mkdir -p $(BUILD_DIR)/exec
	@mkdir -p $(BUILD_DIR)/heredoc
	@mkdir -p $(BUILD_DIR)/parsing
	@mkdir -p $(BUILD_DIR)/redirection
	@mkdir -p $(BUILD_DIR)/tokenizer
	@mkdir -p $(BUILD_DIR)/Error
	@printf "$(CYAN)$(BOLD)%s$(RESET)\n" "Build directory structure created"


# Compile libft
$(LIB): 
	@printf "$(CYAN)$(BOLD)%s$(RESET)\n" "Building libft..."
	@$(MAKE) -C $(LIB_DIR)
	@printf "$(GREEN)$(BOLD)%s$(RESET)\n" "✓ libft.a ready"

# Compile minishell
$(NAME): $(BUILD_DIR) $(LIB) $(OBJS)
	@printf "$(CYAN)$(BOLD)%s$(RESET)\n" "Linking minishell..."
	@$(CC) $(CFLAGS) $(OBJS) $(LIB) $(LDFLAGS) -o $(NAME)
	@printf "$(GREEN)$(BOLD)%s$(RESET)\n" "✓ $(NAME) successfully built!"
	@printf "$(GREEN)$(BOLD)%s$(RESET)\n" "Run ./minishell to start your shell!"

# Compile source files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	@printf "$(CYAN)%s$(RESET)\n" "Compiling $<..."
	@$(CC) $(CFLAGS) -MMD -c $< -o $@

# Clean objects
clean:
	@printf "$(YELLOW)%s$(RESET)\n" "Cleaning object files..."
	@rm -rf $(BUILD_DIR)
	@printf "$(RED)%s$(RESET)\n" "✓ Object files removed"

# Clean libft
libclean:
	@printf "$(YELLOW)%s$(RESET)\n" "Cleaning libft..."
	@$(MAKE) clean -C $(LIB_DIR)
	@printf "$(RED)%s$(RESET)\n" "✓ libft cleaned"

# Full clean library
libfclean:
	@printf "$(YELLOW)%s$(RESET)\n" "Full cleaning libft..."
	@$(MAKE) fclean -C $(LIB_DIR)
	@printf "$(RED)%s$(RESET)\n" "✓ libft completely cleaned"

# Full clean
fclean: clean libfclean
	@printf "$(YELLOW)%s$(RESET)\n" "Removing executable..."
	@rm -f $(NAME)
	@printf "$(RED)%s$(RESET)\n" "✓ $(NAME) removed"
	@rm -f $(BUILD_DIR)

# Rebuild
re: fclean all

# Norminette check
norm:
	@printf "$(YELLOW)%s$(RESET)\n" "Running norminette..."
	@norminette $(SRC_DIR)
	@norminette $(INCLUDE_DIR)
	@printf "$(GREEN)%s$(RESET)\n" "✓ Norminette check completed"

readline:
	$(shell 42-wizzard-brew)
	$(shell brew install readline)
	$(shell brew install ncurses)
	$(shell brew link readline --force)
	$(shell export LDFLAGS="-L$(brew --prefix readline)/lib")
	$(shell export CPPFLAGS="-I$(brew --prefix readline)/include")



################################################
#                 COLORS                       #
################################################

RESET        = \033[0m
BOLD         = \033[1m
BLACK        = \033[30m
RED          = \033[31m
GREEN        = \033[32m
YELLOW       = \033[33m
BLUE         = \033[34m
MAGENTA      = \033[35m
CYAN         = \033[36m
WHITE        = \033[37m
BGBLACK      = \033[40m
BGRED        = \033[41m
BGGREEN      = \033[42m
BGYELLOW     = \033[43m
BGBLUE       = \033[44m
BGMAGENTA    = \033[45m
BGCYAN       = \033[46m
BGWHITE      = \033[47m