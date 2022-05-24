set number
let g:elite_mode = 1                     " Set arrow-keys to window resize
let g:global_symbol_padding = '  '       " Padding after nerd symbols
let g:tabline_plugin_enable = 0          " Disable built-in tabline
let g:enable_universal_quit_mapping = 0  " Disable normal 'q' mapping
let g:disable_mappings = 0               " Disable config/mappings.vim

let g:ale_lint_on_text_changed = 'never'
let g:ale_linters_explicit = 1

" https://docs.buf.build/editor-integration#vim
let g:ale_linters = {
\   'proto': ['buf-lint',],
\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters_explicit = 1
