function available
  echo (status -t)[5] | read -la caller
  printf 'warning: function %savailable%s is deprecated and will be removed soon.\n' \
  (omf::under) (omf::off)

  contains input $caller
    or echo $caller

  type -q $argv
end
