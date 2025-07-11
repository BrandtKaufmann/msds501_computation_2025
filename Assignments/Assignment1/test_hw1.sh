#!/bin/bash

# Test script for hw1.sh
# This script tests all the requirements outlined in the homework

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_PATH="./hw1.sh"
TEST_REPO="https://github.com/BrandtKaufmann/CS112-Lab20"
TEST_DIR="test_repo_dir"
# Variables for test tracking
FAILED_TESTS=0
TOTAL_TESTS=0

# Helper function to run a test, check both exit code and output
run_full_test() {
local test_name="$1"
local expected_exit="$2" # 0 for success, 1 for fail
local expected_output="$3"
local command="$4"
echo -e "${YELLOW}Test $((TOTAL_TESTS + 1)) of 11${NC}"
echo -e "${YELLOW}Running test: $test_name${NC}"
echo "Command: $command"
output=$(eval "$command" 2>&1) # redirect stderr to stdout, where stderr is 2 and stdout is 1 i.e. both error messages and output go to the same place, since we want to capture both success and error messages.
exit_code=$?
echo "Output: $output"
echo "Exit code: $exit_code"
if [ $exit_code -eq $expected_exit ]; then
if [[ "$output" == *"$expected_output"* ]]; then
echo -e "${GREEN}✓ PASS${NC}"
else
echo -e "${RED}✗ FAIL (output mismatch)${NC}"
echo -e "Expected output to contain: $expected_output"
echo -e "Actual output: $output"
FAILED_TESTS=$((FAILED_TESTS + 1))
fi
else
echo -e "${RED}✗ FAIL (exit code mismatch)${NC}"
echo -e "Expected exit code: $expected_exit"
echo -e "Actual exit code: $exit_code"
FAILED_TESTS=$((FAILED_TESTS + 1))
fi
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo "----------------------------------------"
}

# Helper for directory listing test
run_dir_listing_test() {
local test_name="$1"
local expected_exit="$2"
local command="$3"
echo -e "${YELLOW}Test $((TOTAL_TESTS + 1)) of 11${NC}"
echo -e "${YELLOW}Running test: $test_name${NC}"
echo "Command: $command"
output=$(eval "$command" 2>&1)
exit_code=$?
echo "Output: $output"
echo "Exit code: $exit_code"
if [ $exit_code -eq $expected_exit ]; then
if echo "$output" | grep -Eq '^d|^-'; then
echo -e "${GREEN}✓ PASS${NC}"
else
echo -e "${RED}✗ FAIL (directory listing missing)${NC}"
echo -e "Expected: Output containing lines starting with 'd' or '-' (directory listing format)"
echo -e "Actual output: $output"
FAILED_TESTS=$((FAILED_TESTS + 1))
fi
else
echo -e "${RED}✗ FAIL (exit code mismatch)${NC}"
echo -e "Expected exit code: $expected_exit"
echo -e "Actual exit code: $exit_code"
FAILED_TESTS=$((FAILED_TESTS + 1))
fi
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo "----------------------------------------"
}

# Cleanup function
cleanup() {
echo "Cleaning up test directories..."
rm -rf "$TEST_DIR" 2>/dev/null
rm -rf "test_nonexistent_dir" 2>/dev/null
rm -rf "test_existing_dir" 2>/dev/null
}

# Start tests
echo -e "${YELLOW}Starting tests for hw1.sh${NC}"
echo "========================================"

# Test 1: No parameters
run_full_test "No parameters provided (should fail)" 1 $'Please check the format.\nExample: "sh ./hw1.sh git_url folder_path"' "$SCRIPT_PATH"

# Test 2: One parameter
run_full_test "One parameter provided (should fail)" 1 $'Please check the format.\nExample: "sh ./hw1.sh git_url folder_path"' "$SCRIPT_PATH $TEST_REPO"

# Test 3: Three parameters
run_full_test "Three parameters provided (should fail)" 1 $'Please check the format.\nExample: "sh ./hw1.sh git_url folder_path"' "$SCRIPT_PATH $TEST_REPO test_dir extra_param"

# Test 4: Clone to new directory
cleanup
run_full_test "Clone to new directory" 0 "Success: Cloned from $TEST_REPO to test_nonexistent_dir" "$SCRIPT_PATH $TEST_REPO test_nonexistent_dir"

# Test 5: Clone to existing directory (should pull)
cleanup
$SCRIPT_PATH $TEST_REPO test_existing_dir >/dev/null 2>&1
run_full_test "Pull from existing repo" 0 "Success: Pulled from $TEST_REPO to test_existing_dir" "$SCRIPT_PATH $TEST_REPO test_existing_dir"

# Test 6: Invalid repository URL (should fail)
cleanup
run_full_test "Invalid repository URL (should fail)" 1 "Failed to clone from https://invalid-url-that-does-not-exist.com/repo.git to test_nonexistent_dir" "$SCRIPT_PATH https://invalid-url-that-does-not-exist.com/repo.git test_nonexistent_dir"

# Test 7: Pull from non-git directory
cleanup
mkdir test_existing_dir
echo "dummy file" > test_existing_dir/test.txt

# Assignment Version (uncomment for basic requirements):
run_full_test "Pull from non-git directory (should fail)" 1 \
"Failed to pull from $TEST_REPO to test_existing_dir" \
"$SCRIPT_PATH $TEST_REPO test_existing_dir"

# Robust Version (uncomment for better real-world handling):
# run_full_test "Pull from non-git directory (should initialize and pull)" 0 \
# "Success: Initialized and pulled from $TEST_REPO to test_existing_dir" \
# "$SCRIPT_PATH $TEST_REPO test_existing_dir"

# Test 8: Script is executable
if [ -x "$SCRIPT_PATH" ]; then
echo -e "${GREEN}✓ Script is executable${NC}"
else
echo -e "${RED}✗ Script is not executable${NC}"
FAILED_TESTS=$((FAILED_TESTS + 1))
fi
TOTAL_TESTS=$((TOTAL_TESTS + 1))

# Test 9: Directory exists after clone
cleanup
run_full_test "Directory exists after clone" 0 "Success: Cloned from $TEST_REPO to test_nonexistent_dir" "$SCRIPT_PATH $TEST_REPO test_nonexistent_dir"

# Test 10: Directory listing in long format after clone
cleanup
run_dir_listing_test "Directory listing in long format after clone" 0 "$SCRIPT_PATH $TEST_REPO test_nonexistent_dir"

# Test 11: Directory listing in long format after pull
cleanup
$SCRIPT_PATH $TEST_REPO test_existing_dir >/dev/null 2>&1
run_dir_listing_test "Directory listing in long format after pull" 0 "$SCRIPT_PATH $TEST_REPO test_existing_dir"

# Cleanup
cleanup

# Summary
echo "========================================"
echo "Test Summary:"
echo "Total tests: $TOTAL_TESTS"
echo "Passed: $((TOTAL_TESTS - FAILED_TESTS))"
echo "Failed: $FAILED_TESTS"

if [ $FAILED_TESTS -eq 0 ]; then
echo -e "${GREEN}All tests passed!${NC}"
exit 0
else
echo -e "${RED}Some tests failed!${NC}"
exit 1
fi 