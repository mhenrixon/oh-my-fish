set -g OMF_MISSING_ARG   1
set -g OMF_UNKNOWN_OPT   2
set -g OMF_INVALID_ARG   3
set -g OMF_UNKNOWN_ERR   4

# Colour helpers. They are used as `echo (omf::em)"text"(omf::off)`, and a
# command substitution that prints nothing expands to zero elements, which
# makes the whole argument disappear. `set_color` prints nothing when there
# is no usable terminal (TERM unset or dumb, CI, `ssh host cmd`), so each
# helper ends with `echo` to always yield exactly one element.
function omf::em
  set_color cyan 2> /dev/null
  echo
end

function omf::dim
  set_color 555 2> /dev/null
  echo
end

function omf::err
  set_color red --bold 2> /dev/null
  echo
end

function omf::under
  set_color --underline 2> /dev/null
  echo
end

function omf::off
  set_color normal 2> /dev/null
  echo
end

autoload $path/functions/{compat,core,index,packages,themes,bundle,util,repo,cli,search}
