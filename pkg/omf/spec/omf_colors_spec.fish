function describe_omf_colors
  function it_keeps_messages_when_there_is_no_terminal
    # A command substitution that prints nothing expands to zero elements
    # and swallows the whole argument, so the helpers must always print.
    for term in "" dumb
      set -l output (env TERM=$term fish -c 'echo (omf::em)"em"(omf::off) (omf::err)"err"(omf::off) (omf::dim)"dim"(omf::off) (omf::under)"under"(omf::off)' 2>/dev/null | string replace -ra '\e(\[[0-9;]*m|\(B)' '')
      assert_equal "em err dim under" "$output"
    end
  end

  function it_prints_headings_without_a_terminal
    set -l output (env TERM=dumb fish -c 'omf list' 2>/dev/null | string replace -ra '\e(\[[0-9;]*m|\(B)' '')
    assert_match 'Plugins' "$output"
    assert_match 'Themes' "$output"
  end
end
