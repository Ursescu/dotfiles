local M = {}

local SaveQfix_DebugPrefix = 'SaveQfix:'

local write_file = function(message)
    io.output(log_file)
    io.write(message)
    io.close(log_file)
end

function M.save_qfix()
    local nr_qfix = vim.fn.getqflist({ nr = '$' }).nr

    vim.notify(vim.fn.join({
        SaveQfix_DebugPrefix,
        'NR Qfix lists:',
        tostring(nr_qfix)
    }), vim.log.levels.INFO)

    -- Iterate over qfix buffers and get items
    if nr_qfix > 0 then
        local log_file_path = 'test.qfix'
        local log_file = io.open(log_file_path, "w+")
        io.output(log_file)
        io.write('[')
        for qfix_id = 1, nr_qfix do
            local qfix = vim.fn.getqflist({ nr = qfix_id, items = 0 }).items
            -- local qfix_fixes = 
            for _, item in ipairs(qfix) do
                item.filename = vim.fn.bufname(item.bufnr)
                item.bufnr = nil
                -- vim.pretty_print(item)
            end
            io.write(vim.fn.string(qfix))
            io.write(',')
            -- io.write('\n')
            -- vim.notify(vim.fn.join({
            --     SaveQfix_DebugPrefix,
            --     'Qfix', tostring(qfix_id),
            --     vim.inspect(qfix)
            -- }), vim.log.levels.INFO)


        end
        io.write(']')
        io.close(log_file)
    end
end

function M.restore_qfix()

    local log_file_path = 'test.qfix'
    local log_file = io.open(log_file_path, 'r')

    io.input(log_file)
    local contents = io.read("*a")
    io.close(log_file)
    local data = vim.fn.eval(contents)
    local qfix_id = 1
    for _, qfix in ipairs(data) do
        -- vim.pretty_print(qfix)
        vim.pretty_print(qfix_id)

        vim.fn.setqflist({}, ' ', { nr = 0, items = qfix})
        qfix_id = qfix_id + 1
    end

    -- vim.pretty_print(data)
    -- vim.fn.setqflist(data)


end

return M
