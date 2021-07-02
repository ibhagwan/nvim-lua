" https://github.com/junegunn/fzf.vim#advanced-customization
" FzfRg only starts ripgrep after the query is entered
" the below version delegates all work to ripgrep and
" will restart ripgrep every query modification
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang FzfRG
    \ lua require('utils').ensure_loaded_cmd({'fzf.vim'}, {[[
    \ call RipgrepFzf(<q-args>, <bang>0)
    \]]})

" customize FzfRg
" we add ' || true' so rg never raises error
let g:rg_nonfail = ' || true'
command! -bang -nargs=* FzfRg 
    \ lua require('utils').ensure_loaded_cmd({'fzf.vim'}, {[[
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>).g:rg_nonfail, 1,
    \   fzf#vim#with_preview(), <bang>0)
    \]]})

" workaround for :FzfBuffers not working after nvim-reload
command! -bar -bang -nargs=? -complete=buffer FzfBuffers
    \ lua require('utils').ensure_loaded_cmd({'fzf.vim'}, {[[
    \ call fzf#vim#buffers(<q-args>,
    \   fzf#vim#with_preview({ "placeholder": "{1}" }), <bang>0)
    \]]})

" Files + devicons
function! FZFWithDevIcons()
  let l:fzf_files_options = ' -m --bind shift-down:preview-page-down,shift-up:preview-page-up --preview-window=down --preview "bat --color always --style numbers {2..}"'

  function! s:files()
    let l:files = split(system($FZF_DEFAULT_COMMAND), '\n')
    return s:prepend_icon(l:files)
  endfunction

  function! s:prepend_icon(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:filename = fnamemodify(l:candidate, ':p:t')
      let l:extension = fnamemodify(l:candidate, ':e')
      " let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
      if empty(l:extension)
        let l:extension = 'ini'
      end
      let l:icon = luaeval(printf("require'nvim-web-devicons'.get_icon('%s', '%s')", l:filename, l:extension))
      call add(l:result, printf('%s %s', l:icon!=v:null?l:icon:' ', l:candidate))
    endfor

    return l:result
  endfunction

  function! s:edit_file(items)
    let items = a:items
    let i = 1
    let ln = len(items)
    while i < ln
      let item = substitute(items[i], '^\s*\(.\{-}\)\s*$', '\1', '')
      let pos = stridx(item, ' ')
      let file_path = item[pos+1:-1]
      let items[i] = file_path
      let i += 1
    endwhile
    call s:Sink(items)
  endfunction

  let opts = fzf#wrap({})
  let opts.source = <sid>files()
  let s:Sink = opts['sink*']
  let opts['sink*'] = function('s:edit_file')
  let opts.options .= l:fzf_files_options
  call fzf#run(opts)
endfunction

command! -nargs=* -bang FzfDevicons
    \ lua require('utils').ensure_loaded_cmd({'fzf.vim'}, {[[
    \ call FZFWithDevIcons()
    \]]})
