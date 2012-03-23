" Smart keyboard switching

" Properties

" Index of default keyboard layout 
if !exists("g:kls_defaultInputSourceIndex")
    let g:kls_defaultInputSourceIndex = 0 " Use 0 if you are using default english keyboard layout (U.S.)
endif

" Path to KeyboardLayoutSwitcher binary
if !exists("g:kls_switcherPath")
    let g:kls_switcherPath = "/home/e-max/tmp/vim/KeyboardLayoutSwitcher/bin/KeyboardLayoutSwitcher"
endif

" Layout storing when Vim’s focus is lost / gained
if !exists("g:kls_focusSwitching")
    let g:kls_focusSwitching = 1 " Enabled
endif

if $DISPLAY !=""

python << EOF

import vim
import os

buffers_layouts = {}

def get_layout():
    return os.popen(vim.eval("g:kls_switcherPath")).read().strip()

def set_layout(layout):
    return os.popen("%s %s"%(vim.eval("g:kls_switcherPath"), layout)).read().strip()

def save():
    buffers_layouts[vim.current.buffer.number] = get_layout()

def restore():
    if vim.current.buffer.number in buffers_layouts:
        set_layout(buffers_layouts[vim.current.buffer.number])

def set_default():
    save()
    set_layout(vim.eval("g:kls_defaultInputSourceIndex"))


EOF
" Events



if g:kls_focusSwitching != 0
    autocmd! FocusLost
    autocmd FocusLost  * python save()
    autocmd! FocusGained
    autocmd FocusGained * python restore()
endif


autocmd VimEnter * python set_default()

autocmd InsertLeave * python set_default()
autocmd InsertEnter * python restore()

" Keys mappings

"noremap : :silent call g:KLS.SwitchToDefaultInputSource()<CR>:
"noremap <silent> <Esc><Esc> :silent call g:KLS.SwitchToDefaultInputSource()<Esc><Esc>

endif
