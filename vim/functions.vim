" Echo warning message with highlighting enabled
function s:echo_warning(message)
  echohl WarningMsg
  echo a:message
  echohl None
endfunction

