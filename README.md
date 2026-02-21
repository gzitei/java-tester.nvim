# java-tester.nvim

A Neovim plugin to easily find, pick, and run Java tests using DAP and build tools (Gradle, Maven).

## Features
- Provides easy commands to Run, Pick, and Find Java tests.
- Integrates with DAP for easy debugging.
- Extracted and enhanced from native Neovim configurations.
- Prompt-on-save for Java test files (`*Test.java`, `*IT.java`).
- Provides real-time virtual text annotations on test status (passed, skipped, failed) by reading Surefire/Gradle XML reports.
- Includes EmmyLua types and plugin configuration API.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'gzitei/java-tester.nvim',
  config = function()
    require('java-tester').setup({
      -- Default options
      enable_autocmds = true,
      prompt_on_save = true,
      create_commands = true,
    })
  end
}
```

## Configuration

You can configure the behavior in the `setup()` function:

```lua
require('java-tester').setup({
    enable_autocmds = true, -- Enable BufWritePost autocmds for running tests automatically
    prompt_on_save = true,  -- Prompt to run/debug test upon save
    create_commands = true, -- Create user commands (JavaFindTest, JavaRunTest, JavaPickTest)
})
```

## Commands

- `:JavaFindTest` - Lists all test methods referenced for the given Java class or method.
- `:JavaRunTest` - Prompts to Run or Debug the entire test class.
- `:JavaPickTest` - Shows a prompt to select a specific test method in the buffer, and then Runs or Debugs it.
