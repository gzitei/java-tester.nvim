local test_runner = require('java-tester.test_runner')

local M = {}

---@class JavaTesterConfig
---@field enable_autocmds? boolean @Enable BufWritePost autocmds for running tests. Default: true
---@field prompt_on_save? boolean @Prompt to run/debug test on save. Default: true
---@field create_commands? boolean @Create user commands (JavaFindTest, etc.). Default: true

---@type JavaTesterConfig
local default_config = {
    enable_autocmds = true,
    prompt_on_save = true,
    create_commands = true,
}

---Setup java-tester plugin
---@param opts? JavaTesterConfig
M.setup = function(opts)
    M.config = vim.tbl_deep_extend('force', default_config, opts or {})

    if M.config.create_commands then
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'java',
            callback = function(args)
                local bufnr = args.buf

                vim.api.nvim_buf_create_user_command(
                    bufnr,
                    'JavaFindTest',
                    test_runner.list_java_tests,
                    { desc = 'Find tests for Java Class or Method' }
                )

                vim.api.nvim_buf_create_user_command(
                    bufnr,
                    'JavaRunTest',
                    function()
                        test_runner.prompt_run_mode(function(mode)
                            if mode then
                                test_runner.run_test({
                                    bufnr = bufnr,
                                    debug = mode == 'debug',
                                    method_name = nil,
                                })
                            end
                        end)
                    end,
                    { desc = 'Run Java test class' }
                )

                vim.api.nvim_buf_create_user_command(
                    bufnr,
                    'JavaPickTest',
                    function()
                        local methods = test_runner.get_test_methods()
                        if #methods == 0 then
                            vim.notify('No @Test methods found in current buffer', vim.log.levels.WARN)
                            return
                        end
                        test_runner.prompt_test_method(methods, function(method)
                            if method then
                                test_runner.prompt_run_mode(function(mode)
                                    if mode then
                                        test_runner.run_test({
                                            bufnr = bufnr,
                                            debug = mode == 'debug',
                                            method_name = method,
                                        })
                                    end
                                end)
                            end
                        end)
                    end,
                    { desc = 'Pick and run a specific Java test method' }
                )
            end,
            group = vim.api.nvim_create_augroup('JavaTesterCommands', { clear = true }),
            desc = 'Create java-tester buffer commands',
        })
    end

    if M.config.enable_autocmds then
        local group = vim.api.nvim_create_augroup('JavaTesterAutoGroup', { clear = true })
        vim.api.nvim_create_autocmd('BufWritePost', {
            group = group,
            pattern = { '*Test.java', '*IT.java' },
            callback = function(args)
                if M.config.prompt_on_save then
                    vim.ui.select({ 'Run', 'Debug', 'Don\'t run' }, {
                        prompt = 'Run Java Test?',
                    }, function(choice)
                        if choice == 'Run' then
                            test_runner.run_test({
                                bufnr = args.buf,
                                debug = false,
                                method_name = nil,
                            })
                        elseif choice == 'Debug' then
                            test_runner.run_test({
                                bufnr = args.buf,
                                debug = true,
                                method_name = nil,
                            })
                        end
                    end)
                end
            end,
        })
    end
end

M.test_runner = test_runner

return M
