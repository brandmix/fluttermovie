map <leader>bb <esc>:wa<cr>:call VimuxRunCommand("pushd `git rev-parse --show-toplevel`; clear; bash build.sh; popd") <cr>
