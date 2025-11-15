-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

return {
	ensure_installed = vim.list_extend({
		"lua-language-server",
		"stylua",
		"prettier",
		"typescript-language-server",
		"tailwindcss-language-server",
		"html-lenguage-server",
		"css-lenguage-server",
		"json-lenguage-server",
		"prisma-language-server",
		"rust-analyzer",
		"eslint-lenguage-server",
		"astro-lenguage-server",
		"markdown-oxide-languge-server",
		--"omnisharp", Only if required
	}, vim.fn.has("unix") == 1 and {
		"rust-analyzer",
	} or {}),
	max_concurrent_installers = 10,
}
