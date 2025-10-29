vim.loader.enable()
require("lsp")

local nix_profiles = os.getenv("NIX_PROFILES")
if nix_profiles then
  if package.path:sub(-1) ~= ";" then
    package.path = package.path .. ";"
  end
  if package.cpath:sub(-1) ~= ";" then
    package.cpath = package.cpath .. ";"
  end
  for _, profile in ipairs(vim.split(nix_profiles, " ")) do
    if profile ~= "" then
      if profile:sub(-1) ~= "/" then
        profile = profile .. "/"
      end
      local share_lua_path = profile .. "share/lua/5.1"
      if vim.fn.isdirectory(share_lua_path) == 1 then
        package.path = package.path
          .. share_lua_path
          .. "/?.lua;"
          .. share_lua_path
          .. "/?/init.lua;"
      end
      local lib_lua_path = profile .. "lib/lua/5.1"
      if vim.fn.isdirectory(lib_lua_path) == 1 then
        package.cpath = package.cpath .. lib_lua_path .. "/?.so;"
      end
    end
  end
end
