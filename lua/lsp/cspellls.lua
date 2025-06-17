-- originally from:
-- https://github.com/quolpr/nvim-config/blob/0ffedf1a75c26508a3e94673c11def63e8488676/lua/cspell-lsp/init.lua
-- see also gist from same user: https://gist.github.com/quolpr/2d9560c0ad5e77796a068061c8ea439c

-- Function to decode a URI to a file path
local function decode_uri(uri)
  return string.gsub(uri, 'file://', '')
end

-- JSON Formatter implementation
local JsonFormatter = {}

function JsonFormatter:escape_chars(str)
  return str:gsub('[\\"\a\b\f\n\r\t\v]', {
    ['\\'] = '\\\\',
    ['"'] = '\\"',
    ['\a'] = '\\a',
    ['\b'] = '\\b',
    ['\f'] = '\\f',
    ['\n'] = '\\n',
    ['\r'] = '\\r',
    ['\t'] = '\\t',
    ['\v'] = '\\v',
  })
end

function JsonFormatter:format_string(value)
  local result = self.escape_special_chars and self:escape_chars(value) or value
  self:emit(([["%s"]]):format(result), true)
end

function JsonFormatter:format_table(value, add_indent)
  local tbl_count = vim.tbl_count(value)
  self:emit('{\n', add_indent)
  self.indent = self.indent + 2
  local prev_indent = self.indent
  local i = 1
  for k, v in self.pairs_by_keys(value, self.compare[self.indent / 2] or self.default_compare) do
    self:emit(('"%s": '):format(self.escape_special_chars and self:escape_chars(k) or k), true)
    if type(v) == 'string' then
      self.indent = 0
    end
    self:format_value(v)
    self.indent = prev_indent
    if i == tbl_count then
      self:emit '\n'
    else
      self:emit ',\n'
    end
    i = i + 1
  end
  self.indent = self.indent - 2
  self:emit('}', true)
end

function JsonFormatter:format_array(value)
  local array_count = #value
  self:emit '[\n'
  self.indent = self.indent + 2
  for i, item in ipairs(value) do
    self:format_value(item, true)
    if i == array_count then
      self:emit '\n'
    else
      self:emit ',\n'
    end
  end
  self.indent = self.indent - 2
  self:emit(']', true)
end

function JsonFormatter:emit(value, add_indent)
  if add_indent then
    self.out[#self.out + 1] = (' '):rep(self.indent)
  end
  self.out[#self.out + 1] = value
end

function JsonFormatter:format_value(value, add_indent)
  if value == nil then
    self:emit 'null'
  end
  local _type = type(value)
  if _type == 'string' then
    self:format_string(value)
  elseif _type == 'number' then
    self:emit(tostring(value), add_indent)
  elseif _type == 'boolean' then
    self:emit(value == true and 'true' or 'false', add_indent)
  elseif _type == 'table' then
    local count = vim.tbl_count(value)
    if count == 0 then
      self:emit '{}'
    elseif #value > 0 then
      self:format_array(value)
    else
      self:format_table(value, add_indent)
    end
  end
end

function JsonFormatter:pretty_print(data, keys_orders, escape_special_chars)
  self.compare = {}
  if keys_orders then
    for indentation_level, keys_order in pairs(keys_orders) do
      local order = {}
      for i, key in ipairs(keys_order) do
        order[key] = i
      end
      local max_pos = #keys_order + 1
      self.compare[indentation_level] = function(a, b)
        return (order[a] or max_pos) - (order[b] or max_pos) < 0
      end
    end
  end
  self.default_compare = function(a, b)
    return a:lower() < b:lower()
  end
  self.escape_special_chars = escape_special_chars
  self.indent = 0
  self.out = {}
  self:format_value(data, false)
  return table.concat(self.out)
end

-- Helper for sorting pairs by keys
JsonFormatter.pairs_by_keys = function(tbl, compare)
  local keys = {}
  for key, _ in pairs(tbl) do
    table.insert(keys, key)
  end
  compare = compare or function(a, b)
    return a:lower() < b:lower()
  end
  table.sort(keys, compare)
  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], tbl[keys[i]]
    end
  end
end

-- Function to read and parse JSON from a file
local function read_json_file(path)
  local file = io.open(path, 'r')
  if not file then
    error('Failed to open file: ' .. path)
  end
  local data = file:read '*a'
  file:close()

  local decoded = vim.json.decode(data)
  return decoded
end

-- Function to write formatted JSON data to a file
local function write_json_file(path, table)
  local formatted = JsonFormatter:pretty_print(table, nil, true)

  local file = io.open(path, 'w')
  if not file then
    error('Failed to open file for writing: ' .. path)
  end
  file:write(formatted)
  file:close()
end

local function line_byte_from_position(lines, lnum, col, offset_encoding)
  if not lines or offset_encoding == 'utf-8' then
    return col
  end

  local line = lines[lnum + 1]
  local ok, result = pcall(vim.str_byteindex, line, col, offset_encoding == 'utf-16')
  if ok then
    return result --- @type integer
  end

  return col
end

---@param bufnr integer
---@return string[]?
local function get_buf_lines(bufnr)
  if vim.api.nvim_buf_is_loaded(bufnr) then
    return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  local f = io.open(filename)
  if not f then
    return
  end

  local content = f:read '*a'
  if not content then
    -- Some LSP servers report diagnostics at a directory level, in which case
    -- io.read() returns nil
    f:close()
    return
  end

  local lines = vim.split(content, '\n')
  f:close()
  return lines
end

return {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  cmd = {
    'cspellls',
    '--stdio',
  },
  filetypes = { 'markdown', 'html', 'gitcommit' },
  root_markers = {
    '.git',
    '.cSpell.json',
    '.cspell.json',
    'cSpell.json',
    'cspell.config.cjs',
    'cspell.config.js',
    'cspell.config.json',
    'cspell.config.yaml',
    'cspell.config.yml',
    'cspell.json',
    'cspell.json',
    'cspell.yaml',
    'cspell.yml',
  },
  single_file_support = true,
  settings = {
    cSpell = { -- see more here: https://streetsidesoftware.com/vscode-spell-checker/docs/configuration
      enabled = true,
      language = { 'pt_BR', 'en' },
      trustedWorkspace = true, -- Enable loading JavaScript CSpell configuration files. https://github.com/streetsidesoftware/vscode-spell-checker/blob/main/website/docs/configuration/auto_advanced.md#cspelltrustedworkspace
      checkOnlyEnabledFileTypes = false, -- https://github.com/streetsidesoftware/vscode-spell-checker/blob/main/website/docs/configuration/auto_files-folders-and-workspaces.md#cspellcheckonlyenabledfiletypes
      doNotUseCustomDecorationForScheme = true, -- Use VS Code to Render Spelling Issues. https://github.com/streetsidesoftware/vscode-spell-checker/blob/main/website/docs/configuration/auto_appearance.md#cspelldonotusecustomdecorationforscheme
      useCustomDecorations = false, -- Draw custom decorations on Spelling Issues. https://github.com/streetsidesoftware/vscode-spell-checker/blob/main/website/docs/configuration/auto_appearance.md#cspellusecustomdecorations
    },
  },
  handlers = {
    ['_onDiagnostics'] = function(err, result, ctx, config)
      vim.lsp.handlers['textDocument/publishDiagnostics'](err, result[1][1], ctx, config)
      vim.lsp.diagnostic.on_publish_diagnostics(err, result[1][1], ctx, config)
    end,
    ['_onWorkspaceConfigForDocumentRequest'] = function()
      return {
        ['uri'] = nil,
        ['workspaceFile'] = nil,
        ['workspaceFolder'] = nil,
        ['words'] = {},
        ['ignoreWords'] = {},
      }
    end,
  },
  on_init = function()
    vim.lsp.commands['cSpell.editText'] = function(command, scope)
      local buf_lines = get_buf_lines(scope.bufnr)

      local range = command.arguments[3][1].range
      local new_text = command.arguments[3][1].newText

      local start_line = range.start.line
      local start_ch = line_byte_from_position(buf_lines, range.start.line, range.start.character, 'utf-16')
      local end_line = range['end'].line
      local end_ch = line_byte_from_position(buf_lines, range['end'].line, range['end'].character, 'utf-16')

      local lines = vim.api.nvim_buf_get_lines(scope.bufnr, start_line, end_line + 1, false)

      local start_line_content = lines[1]
      local end_line_content = lines[#lines]

      local before_range = start_line_content:sub(1, start_ch)
      local after_range = end_line_content:sub(end_ch + 1)

      lines[1] = before_range .. new_text .. after_range

      if #lines > 1 then
        for i = 2, #lines do
          lines[i] = nil
        end
      end

      vim.api.nvim_buf_set_lines(scope.bufnr, start_line, start_line + 1, false, lines)
    end

    vim.lsp.commands['cSpell.addWordsToConfigFileFromServer'] = function(command)
      local words = command.arguments[1]
      local config_file_uri = command.arguments[3].uri
      local config_file_path = decode_uri(config_file_uri)
      vim.notify('CSpell file path: ' .. config_file_path)
      local ext = vim.fn.fnamemodify(config_file_path, ':e')
      if ext == 'yaml' or ext == 'yml' then
        if not vim.fn.executable('yq') then
          vim.notify('yq is not installed or not in the PATH, cannot update ' .. config_file_path)
          return
        end
        -- example of command:
        -- yq '(.words += ["Foo"]) | .words |= sort_by(. | ascii_downcase)' --yaml-roundtrip --in-place cspell.yaml
        local result = os.execute([[yq '(.words += ["]] .. table.concat(words, '", "') .. [["]) | .words |= sort_by(. | ascii_downcase)' --yaml-roundtrip --in-place ]] .. config_file_path)
        if result ~= 0 then
          vim.notify('Failed to update YAML file: ' .. config_file_path)
        end
      elseif ext == 'json' then
        local json_data = read_json_file(config_file_path)
        vim.list_extend(json_data.words, words)
        write_json_file(config_file_path, json_data)
      elseif ext == 'cjs' or ext == 'js' then
        vim.notify('JavaScript files not supported for updating configuration (file ' .. config_file_path .. ')')
      else
        vim.notify('Unsupported file type: ' .. ext .. ' (file ' .. config_file_path .. ')')
      end
    end

    vim.lsp.commands['cSpell.addWordsToDictionaryFileFromServer'] = function()
      vim.notify 'Not supported'
    end

    vim.lsp.commands['cSpell.addWordsToVSCodeSettingsFromServer'] = function()
      vim.notify 'Not supported'
    end
  end,
}
