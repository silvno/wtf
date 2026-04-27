#!/usr/bin/env -S uv --quiet run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "openai",
#     "rich",
#     "typer",
# ]
# ///

import os
import sys
import typer
from rich.console import Console
from openai import OpenAI

app = typer.Typer()
console = Console()

# Point the standard OpenAI client to your local Ollama server
client = OpenAI(
    base_url="http://localhost:11434/v1",
    api_key="ollama" # Required by the client, but Ollama ignores it
)

# Load from environment variable
MODEL_NAME = os.getenv("AI_MODEL", "gemma4:latest")

@app.command()
def main(prompt: str = typer.Argument(None, help="The prompt to send to the AI")):
    # 1. Handle Piped Input (stdin)
    piped_data = ""
    if not sys.stdin.isatty():
        piped_data = sys.stdin.read()
    
    # 2. Build the system and user messages
    messages = [
        {"role": "system", "content": "You are an expert developer. Provide extremely concise, direct answers. Give me exactly what I asked for with zero filler, greetings, or conversational fluff. Output markdown."}
    ]
    
    user_content = ""
    if piped_data:
        user_content += f"Here is the context/code:\n\n{piped_data}\n\n"
    if prompt:
        user_content += f"Request: {prompt}"
    
    if not user_content.strip():
        console.print("[bold red]Please provide a prompt or pipe some data into the command.[/bold red]")
        raise typer.Exit()

    messages.append({"role": "user", "content": user_content})

    # 3. Stream the response and handle the spinner logic
    response = client.chat.completions.create(
        model=MODEL_NAME,
        messages=messages,
        stream=True,
        extra_body={"keep_alive": "24h"} # Prevents cold starts
    )

    console.print()
    
    # Manually start the status spinner
    status = console.status(f"[bold green]Thinking ({MODEL_NAME})...", spinner="dots")
    status.start()
    
    first_chunk_received = False
    
    try:
        # 4. Render the streamed output elegantly
        for chunk in response:
            if chunk.choices[0].delta.content:
                # The moment we get our first piece of text, stop the spinner
                if not first_chunk_received:
                    status.stop()
                    first_chunk_received = True
                
                # Print chunks as they arrive for that "typing" effect
                print(chunk.choices[0].delta.content, end="", flush=True)
    finally:
        # Ensure the spinner always stops, even if the model errors out
        if not first_chunk_received:
            status.stop()
            
    console.print("\n")

if __name__ == "__main__":
    app()
