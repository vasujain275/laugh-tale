return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup {
      check_ts = true,
      ts_config = {
        lua = { 'string' },
        javascript = { 'template_string' },
      },
      disable_filetype = { 'TelescopePrompt', 'vim' },
      fast_wrap = {},
    }
  end,
}
