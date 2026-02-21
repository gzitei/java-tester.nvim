local assert = require('luassert')

describe('java-tester', function()
    it('can be required', function()
        require('java-tester')
    end)
    
    it('can run setup', function()
        local test_runner = require('java-tester')
        test_runner.setup()
        assert.truthy(test_runner.config)
        assert.is_true(test_runner.config.enable_autocmds)
        assert.is_true(test_runner.config.prompt_on_save)
        assert.is_true(test_runner.config.create_commands)
    end)

    it('can modify options via setup', function()
        local test_runner = require('java-tester')
        test_runner.setup({
            prompt_on_save = false
        })
        assert.truthy(test_runner.config)
        assert.is_false(test_runner.config.prompt_on_save)
    end)
end)
