function omf.cli.list
  switch (count $argv)
  case 0
    echo (omf::under)Plugins(omf::off)
    omf.packages.list --plugin | column
    echo
    echo (omf::under)Themes(omf::off)
    omf.packages.list --theme | column
  case '*'
    omf.packages.list $argv | column
  end
end
