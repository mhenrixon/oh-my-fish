# Undo the bookkeeping of an assertion that was *expected* to fail, so a
# deliberately failing assertion does not mark the test or the run as failed.
function __fish_spec_undo_expected_failure
  # Only undo when the preceding `assert_exit_code 1` succeeded, i.e. the
  # assertion under test really did fail. Otherwise the failure is real.
  test $status -eq 0; or return 1
  set __fish_spec_failed_assertions_in_file (math $__fish_spec_failed_assertions_in_file - 1)
  set __fish_spec_last_assertion_failed no
end

function describe_results
  function it_succeeds_when_single_assertion_succeeds
    assert 1 = 1
    assert_exit_code 0
  end

  function it_succeeds_when_multiple_assertion_succeeds
    assert 1 = 1
    assert 2 = 2
  end

  function it_fails_when_single_assertion_fails
    set -l failed_before $__fish_spec_failed_assertions_in_file
    assert 1 = 2
    assert_exit_code 1
    assert_equal (math $failed_before + 1) $__fish_spec_failed_assertions_in_file
    assert_equal yes $__fish_spec_last_assertion_failed
    __fish_spec_undo_expected_failure
  end

  function it_fails_when_one_of_the_assertions_fails
    set -l failed_before $__fish_spec_failed_assertions_in_file
    assert 1 = 2
    assert_exit_code 1
    assert 2 = 2
    assert_exit_code 0
    assert_equal (math $failed_before + 1) $__fish_spec_failed_assertions_in_file
    __fish_spec_undo_expected_failure
  end

  function it_counts_every_assertion
    set -l total_before $__fish_spec_total_assertions_in_file
    assert 1 = 1
    assert_equal a a
    assert_equal (math $total_before + 2) $__fish_spec_total_assertions_in_file
  end
end
