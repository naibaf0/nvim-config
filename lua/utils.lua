local M = {}

    M.is_buffer_empty = function()
        -- Check whether the current buffer is empty
        return vim.fn.empty(vim.fn.expand('%:t')) == 1
    end

    M.has_width_gt = function(cols)
        -- Check if the windows width is greater than a given number of columns
        return vim.fn.winwidth(0) / 2 > cols
    end

    M.get_visual_selection = function()
        local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
        local end_row,   end_col   = unpack(vim.api.nvim_buf_get_mark(0, '>'))
        -- print(vim.inspect({start_row, start_col, end_row, end_col}))
        local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})
        -- print(vim.inspect(lines))
        return table.concat(lines, '\n')
    end

    M.search_for_visual_selection = function(forward)
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local selection = M.get_visual_selection()
        local escaped = vim.fn.escape(selection, '/\\')
        if forward then
            pcall(vim.cmd, '/' .. escaped)
        else
            pcall(vim.cmd, '?' .. escaped)
        end
        vim.api.nvim_win_set_cursor(0, cursor_pos)
    end

    M.project_files = function()
        local opts = {require('telescope.themes').get_dropdown({})} -- define here if you want to define something
        local ok = pcall(require"telescope.builtin".git_files, opts)
        if not ok then require"telescope.builtin".find_files(opts) end
    end

    M.toggle_opt = function(prop, scope, on, off)
        if on == nil then
            on = true
        end

        if off == nil then
            off = false
        end

        if scope == nil then
            scope = 'o'
        end

        return function()
            if vim[scope][prop] == on then
                vim[scope][prop] = off
            else
              vim[scope][prop] = on
            end
        end
    end

    M.delete_trailing_ws = function()
        -- Save cursor position to later restore
        local curpos = vim.api.nvim_win_get_cursor(0)

        -- Search and replace trailing whitespace
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, curpos)
    end

    M.job_output = function(cid, data, name)
        for i, val in pairs(data) do
            print(val)
        end
    end

    M.edit_macro = function()
        local register = 'i'

        local opts = {default = vim.g.edit_macro_last or ''}

        if opts.default == '' then
            opts.prompt = 'Create Macro'
        else
            opts.prompt = 'Edit Macro'
        end

        vim.ui.input(opts, function(value)
            if value == nil then return end

            local macro = vim.fn.escape(value, '"')
            vim.cmd(string.format('let @%s="%s"', register, macro))

            vim.g.edit_macro_last = value
        end)
    end

    M.set_autoindent = function()
        require('guess-indent').setup({auto_cmd = true, verbose = 1})

        vim.defer_fn(function()
            local bufnr = vim.fn.bufnr()
            vim.cmd('silent! bufdo GuessIndent')
            vim.cmd('buffer ' .. bufnr)
        end, 3)
    end

return M
