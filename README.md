# wtf-ai
Fully local AI-powered command correction tool and CLI assistant.

wtf-ai consists of two utilities that leverage Ollama and uv to bring large language model intelligence directly into your terminal workflow—without relying on external APIs or sacrificing privacy.

# The Utilities
1. `wtf` (The Correction Wrapper)
Inspired by the original [thefuck](https://github.com/nvbn/thefuck) cli-tool: When a command fails or you make a typo, simply type wtf. The tool analyzes your last command and its context, suggests a correction using a local LLM, and allows you to execute the fix with a single keystroke.

2. `ai` (The Standalone CLI)
A direct interface to your local models. It is designed to be highly "pipeable," allowing you to send terminal output, file contents, or direct questions to the AI and receive concise, markdown-formatted responses.

# Installation (homebrew)
The easiest way to install and manage wtf-ai on macOS (and Linux if you're lucky).

```bash
brew tap silvno/tap
brew install wtf-ai
```

After the installation has finished, pull the default model (~10GB).
```bash
ollama pull gemma4:latest
```
Finally, source the `wtf.sh` in your `.zshrc` or `.bashrc`:
```
source $HOMEBREW_REPOSITORY/opt/wtf-ai/share/wtf-ai/wtf.sh
```

# Usage Examples

Correcting Mistakes with wtf
Typo Correction

```bash
$ git comit -m "Initial commit"
# git: 'comit' is not a git command.

$ wtf
Thinking about: git comit -m "Initial commit"
Suggested: git commit -m "Initial commit"
Run this? [Y/n]:
```

# Querying with ai

##Direct Questions

```bash
$ ai "What is the command to list all listening ports on macOS?"
# lsof -i -P | grep LISTEN
```

## Piped Context

```bash
$ cat error.log | tail -n 20 | ai "Explain why this service failed to start"
```

#Configuration

wtf-ai can be customized using environment variables in your shell configuration file (.zshrc or .bashrc).

```bash
export AI_MODEL="yourfavoritemodel" # defaults to gemma4:latest
```

#Requirements

- `ollama`: Must be installed and running.
- `uv`: to isolate python dependencies

Local Model: You must have the model specified in AI_MODEL pulled locally (e.g., `ollama pull gemma4`).
