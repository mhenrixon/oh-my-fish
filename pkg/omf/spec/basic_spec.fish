function describe_basic_tests
  function it_has_a_help_command
    set -l output (omf help)
    assert_exit_code 0
    # Help output highlights the short alias of each command with color
    # codes (e.g. "d" in "describe"); strip them (including the terminfo
    # reset "\e(B" some terminals emit) before matching.
    set -l output (string replace -ra '\e(\[[0-9;]*m|\(B)' '' -- $output)
    assert_match "cd.+Change to root or package directory" "$output"
    assert_match "channel.+Get or change the update channel" "$output"
    assert_match "describe.+Show information about a package" "$output"
    assert_match "destroy.+Uninstall Oh My Fish" "$output"
    assert_match "doctor.+Troubleshoot Oh My Fish" "$output"
    assert_match "help.+Shows help about a command" "$output"
    assert_match "install.+Install one or more packages" "$output"
    assert_match "list.+List installed packages" "$output"
    assert_match "new.+Create a new package from a template" "$output"
    assert_match "reload.+Reload the current shell" "$output"
    assert_match "remove.+Remove a package" "$output"
    assert_match "repositories.+Manage package repositories" "$output"
    assert_match "search.+Search for a package or theme" "$output"
    assert_match "theme.+Activate and list available themes" "$output"
    assert_match "update.+Update Oh My Fish" "$output"
    assert_match "version.+Display version and exit" "$output"
  end

  function it_has_a_doctor_command
    set -l output (omf doctor)
    assert_exit_code 0
    assert_match "Oh My Fish version" "$output"
    assert_match "Checking for a sane environment..." "$output"
  end

  function it_installs_packages
    set -l remove_output (omf remove apt 2> /dev/null)
    set -l install_output (omf install apt)
    assert_exit_code 0
    assert_match "apt successfully installed." "$install_output"
  end

  function it_removes_packages
    set -l install_output (omf install apt 2> /dev/null)
    set -l remove_output (omf remove apt)
    assert_exit_code 0
    assert_match "apt successfully removed." "$remove_output"
  end
end
