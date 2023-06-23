local M = {}

function M.setup()
    -- An attempt to save qfix context, not worth it
    -- local qfix_save_hook = function()
    --     local qfix_save_cmds = {}
    --     local nr_qfix = vim.fn.getqflist({ nr = '$' }).nr
    --
    --     -- Iterate over qfix buffers and get items
    --     if nr_qfix > 0 then
    --         for qfix_id = 1, nr_qfix do
    --             local qfix = vim.fn.getqflist({ nr = qfix_id, items = 0 }).items
    --             -- Save the filename, buffers will not be loaded (unlisted)
    --             for _, item in ipairs(qfix) do
    --                 item.filename = vim.fn.bufname(item.bufnr)
    --                 item.bufnr = nil
    --             end
    --             local restore_cmd = "call setqflist([], ' ', {'items': " .. vim.fn.string(qfix) .. "})"
    --             table.insert(qfix_save_cmds, restore_cmd)
    --         end
    --     end
    --     return qfix_save_cmds
    -- end

    -- local has_tree = false

    -- local nvim_pre_save_hook = function()
    --     local nvim_tree_visible = require('nvim-tree.view').is_visible()
    --     print(nvim_tree_visible)
    --     has_tree = nvim_tree_visible
    -- end
    --
    -- local nvim_tree_hook = function()
    --     if has_tree then
    --         return "let g:has_tree = 1"
    --     else
    --         return "let g:has_tree = 0"
    --     end
    -- end

    -- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = function()
    --     print("AUTOCMD" .. tostring(vim.g.has_tree))
    --         -- if vim.g.has_tree == 1 then
    --         --     print("HEY")
    --         --     require("nvim-tree.api").tree.open()
    --         -- end
    --     end
    -- })

    -- local nvim_post_restore_hook = function()
    --     if vim.g.has_tree == 1 then
    --         vim.schedule(function()
    --         --     -- require("nvim-tree.api").tree.toggle({focus = false})
    --         require("nvim-tree.api").tree.open()
    --         end)
    --     end
    -- end

    require('auto-session').setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        -- Try to save NVIM-TREE state
        -- pre_save_cmds = {
        --     nvim_pre_save_hook,
        --     "NvimTreeClose"
        -- },
        -- save_extra_cmds = {
        --     nvim_tree_hook,
        --     -- another_hook
        -- },
        -- post_restore_cmds = {
        --     nvim_post_restore_hook
        -- }
        -- This needs some modifications to allow table instead of string
        -- save_extra_cmds = {
        --     qfix_save_hook
        -- }
    })
end

-- M.setup()
return M
