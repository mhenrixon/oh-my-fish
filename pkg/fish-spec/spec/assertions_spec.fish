function __fish_spec_undo_expected_failure
  # Only undo when the preceding `assert_exit_code 1` succeeded, i.e. the
  # assertion under test really did fail. Otherwise the failure is real.
  test $status -eq 0; or return 1
  set __fish_spec_failed_assertions_in_file (math $__fish_spec_failed_assertions_in_file - 1)
  set __fish_spec_last_assertion_failed no
end

function describe_assertions
  function before_all
    set -g __spec_tmp (mktemp -d)
    echo "hello world" > $__spec_tmp/full
    touch $__spec_tmp/empty
  end

  function after_all
    rm -rf $__spec_tmp
    set -e __spec_tmp
  end

  function it_assert_passes_arguments_separately
    assert 1 = 2
    assert_exit_code 1
    __fish_spec_undo_expected_failure

    assert -n ""
    assert_exit_code 1
    __fish_spec_undo_expected_failure

    assert -z ""
    assert_exit_code 0
  end

  function it_assert_equal_and_not_equal
    assert_equal abc abc
    assert_exit_code 0
    assert_not_equal abc abd
    assert_exit_code 0

    assert_equal abc abd
    assert_exit_code 1
    __fish_spec_undo_expected_failure
    assert_not_equal abc abc
    assert_exit_code 1
    __fish_spec_undo_expected_failure
  end

  function it_assert_exit_code_reads_previous_status
    false
    assert_exit_code 1
    true
    assert_ok
    sh -c 'exit 7'
    assert_exit_code 7

    false
    assert_ok
    assert_exit_code 1
    __fish_spec_undo_expected_failure
  end

  function it_assert_match_and_not_match
    assert_match '^abc' abcdef
    assert_exit_code 0
    assert_not_match '^abc' zzz
    assert_exit_code 0

    assert_match '^abc' zzz
    assert_exit_code 1
    __fish_spec_undo_expected_failure
    assert_not_match '^abc' abcdef
    assert_exit_code 1
    __fish_spec_undo_expected_failure
  end

  function it_assert_match_joins_multiple_arguments
    set -l lines first second third
    assert_match 'second' $lines
    assert_exit_code 0
    assert_match '^first second third$' $lines
    assert_exit_code 0
  end

  function it_does_not_undo_a_real_failure
    set -l failed_before $__fish_spec_failed_assertions_in_file
    assert 1 = 1
    assert_exit_code 1
    __fish_spec_undo_expected_failure
    assert_exit_code 1
    # The wrongly expected failure above is genuine and must remain counted.
    assert_equal (math $failed_before + 1) $__fish_spec_failed_assertions_in_file
    # Undo it for real now that the bookkeeping has been verified.
    set __fish_spec_failed_assertions_in_file (math $__fish_spec_failed_assertions_in_file - 1)
    set __fish_spec_last_assertion_failed no
  end

  function it_assert_match_treats_arguments_as_data
    assert_match '\(' 'a(b'
    assert_exit_code 0
    assert_match '-x' 'a-x'
    assert_exit_code 0
  end

  function it_assert_file_and_directory_helpers
    assert_file_exists $__spec_tmp/full
    assert_exit_code 0
    assert_file_does_not_exist $__spec_tmp/missing
    assert_exit_code 0
    assert_directory_exists $__spec_tmp
    assert_exit_code 0
    assert_directory_does_not_exist $__spec_tmp/missing
    assert_exit_code 0
    assert_file_empty $__spec_tmp/empty
    assert_exit_code 0

    assert_directory_exists $__spec_tmp/missing
    assert_exit_code 1
    __fish_spec_undo_expected_failure
    assert_file_empty $__spec_tmp/full
    assert_exit_code 1
    __fish_spec_undo_expected_failure
    assert_file_exists $__spec_tmp/missing
    assert_exit_code 1
    __fish_spec_undo_expected_failure
  end

  function it_assert_file_contents
    assert_file_contains $__spec_tmp/full world
    assert_exit_code 0
    assert_not_file_contains $__spec_tmp/full mars
    assert_exit_code 0
    assert_file_contains_regex $__spec_tmp/full '^hello'
    assert_exit_code 0
    assert_not_file_contains_regex $__spec_tmp/full '^world'
    assert_exit_code 0

    assert_file_contains $__spec_tmp/full mars
    assert_exit_code 1
    __fish_spec_undo_expected_failure
  end

  function it_assert_arrays
    assert_in_array b a b c
    assert_exit_code 0
    assert_not_in_array z a b c
    assert_exit_code 0

    assert_in_array z a b c
    assert_exit_code 1
    __fish_spec_undo_expected_failure
  end

  function it_assert_true_and_false
    assert_true 1
    assert_exit_code 0
    assert_false 0
    assert_exit_code 0
    assert_false ""
    assert_exit_code 0

    assert_true 0
    assert_exit_code 1
    __fish_spec_undo_expected_failure
  end
end
