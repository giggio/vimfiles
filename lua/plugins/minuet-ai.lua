-- Minuet offers code completion as-you-type from popular LLMs including OpenAI, Gemini, Claude, Ollama, Llama.cpp, Codestral, and more.
-- https://github.com/milanglacier/minuet-ai.nvim
return {
  "milanglacier/minuet-ai.nvim",
  dependencies = {
    { "hrsh7th/nvim-cmp" },
  },
  enabled = not vim.g.is_server,
  config = function()
    require("minuet").setup({
      provider = "openai_fim_compatible",
      n_completions = 2,
      context_window = 1024,
      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM",
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = "qwen2.5-coder:7b",
          optional = {
            max_tokens = 56,
            top_p = 0.9,
          },
        },
      },
    })
  end,
}
