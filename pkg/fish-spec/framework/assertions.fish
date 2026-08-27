# Record the outcome of an assertion.
#
# Every assert_* helper runs its check directly and passes the resulting
# $status here together with a success and a failure message. No `eval` is
# involved, so assertion arguments containing quotes, parentheses or regex
# metacharacters are never re-parsed as fish code.
function __fish_spec_assert_result -a result success_message failure_message
  set __fish_spec_total_assertions_in_file (math $__fish_spec_total_assertions_in_file + 1)

  if test "$result" -ne 0
    set __fish_spec_failed_assertions_in_file (math $__fish_spec_failed_assertions_in_file + 1)
    set __fish_spec_last_assertion_failed yes
    __fish_spec.color.echo.failure "$failure_message"
    return 1
  end
  if test "$FISH_SPEC_VERBOSE" = 1
    __fish_spec.color.echo.success "$success_message"
  end
  return 0
end

# assert <test arguments...>
# Passes each argument to `test` separately, e.g. `assert 1 = 2`.
function assert
  test $argv
  __fish_spec_assert_result $status \
    "Assertion \"test $argv\" passed!" \
    "Assertion failed: \"test $argv\" evaluated to false."
end

function assert_equal -a expected actual
  test "$expected" = "$actual"
  __fish_spec_assert_result $status \
    "Assertion \"$expected\" == \"$actual\" passed!" \
    "Assertion failed: Expected \"$expected\", but got \"$actual\"."
end

function assert_not_equal -a expected actual
  test "$expected" != "$actual"
  __fish_spec_assert_result $status \
    "Assertion \"$expected\" != \"$actual\" passed!" \
    "Assertion failed: Expected \"$actual\" to be different from \"$expected\"."
end

# assert_exit_code <expected>
# Checks the exit status of the command that ran immediately before it.
function assert_exit_code -a expected_status
  set -l actual_status $status
  test "$expected_status" -eq "$actual_status"
  __fish_spec_assert_result $status \
    "Assertion exit code $actual_status == $expected_status passed!" \
    "Assertion failed: Expected exit code $expected_status, but got $actual_status."
end

function assert_ok
  set -l actual_status $status
  test "$actual_status" -eq 0
  __fish_spec_assert_result $status \
    "Assertion exit code $actual_status == 0 passed!" \
    "Assertion failed: Expected exit code 0, but got $actual_status."
end

function assert_true -a condition
  test -n "$condition" -a "$condition" != 0 -a "$condition" != false
  __fish_spec_assert_result $status \
    "Assertion \"$condition\" is true passed!" \
    "Assertion failed: Expected true, but got \"$condition\"."
end

function assert_false -a condition
  test -z "$condition" -o "$condition" = 0 -o "$condition" = false
  __fish_spec_assert_result $status \
    "Assertion \"$condition\" is false passed!" \
    "Assertion failed: Expected false, but got \"$condition\"."
end

function assert_match -a pattern string
  string match -qr -- "$pattern" "$string"
  __fish_spec_assert_result $status \
    "Assertion string \"$string\" matches pattern \"$pattern\" passed!" \
    "Assertion failed: string \"$string\" does not match pattern \"$pattern\"."
end

function assert_not_match -a pattern string
  not string match -qr -- "$pattern" "$string"
  __fish_spec_assert_result $status \
    "Assertion string \"$string\" does not match pattern \"$pattern\" passed!" \
    "Assertion failed: string \"$string\" matches pattern \"$pattern\"."
end

function assert_file_exists -a file
  test -f "$file"
  __fish_spec_assert_result $status \
    "Assertion file \"$file\" exists passed!" \
    "Assertion failed: File \"$file\" does not exist."
end

function assert_file_does_not_exist -a file
  not test -f "$file"
  __fish_spec_assert_result $status \
    "Assertion file \"$file\" does not exist passed!" \
    "Assertion failed: File \"$file\" exists."
end

function assert_directory_exists -a dir
  test -d "$dir"
  __fish_spec_assert_result $status \
    "Assertion directory \"$dir\" exists passed!" \
    "Assertion failed: Directory \"$dir\" does not exist."
end

function assert_directory_does_not_exist -a dir
  not test -d "$dir"
  __fish_spec_assert_result $status \
    "Assertion directory \"$dir\" does not exist passed!" \
    "Assertion failed: Directory \"$dir\" exists."
end

function assert_file_empty -a file
  not test -s "$file"
  __fish_spec_assert_result $status \
    "Assertion file \"$file\" is empty passed!" \
    "Assertion failed: File \"$file\" is not empty."
end

function assert_file_contains -a file content
  grep -qF -- "$content" "$file"
  __fish_spec_assert_result $status \
    "Assertion $file contains \"$content\" passed!" \
    "Assertion failed: File \"$file\" does not contain \"$content\"."
end

function assert_file_contains_regex -a file pattern
  grep -qE -- "$pattern" "$file"
  __fish_spec_assert_result $status \
    "Assertion $file content matches regex \"$pattern\" passed!" \
    "Assertion failed: File \"$file\" does not contain a string matching the pattern \"$pattern\"."
end

function assert_not_file_contains -a file content
  not grep -qF -- "$content" "$file"
  __fish_spec_assert_result $status \
    "Assertion $file does not contain \"$content\" passed!" \
    "Assertion failed: File \"$file\" contains \"$content\"."
end

function assert_not_file_contains_regex -a file pattern
  not grep -qE -- "$pattern" "$file"
  __fish_spec_assert_result $status \
    "Assertion $file content does not match regex \"$pattern\" passed!" \
    "Assertion failed: File \"$file\" contains a string matching the pattern \"$pattern\"."
end

function assert_in_array -a value
  set -l array $argv[2..-1]
  contains -- "$value" $array
  __fish_spec_assert_result $status \
    "Assertion \"$value\" in [$array] passed!" \
    "Assertion failed: Value \"$value\" is not in the array [$array]."
end

function assert_not_in_array -a value
  set -l array $argv[2..-1]
  not contains -- "$value" $array
  __fish_spec_assert_result $status \
    "Assertion \"$value\" not in [$array] passed!" \
    "Assertion failed: Value \"$value\" is in the array [$array]."
end
