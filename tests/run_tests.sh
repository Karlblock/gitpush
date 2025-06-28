#!/bin/bash

# Simple test suite for gitpush
# Tests basic functionality without complex dependencies

set -e

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
NC="\033[0m"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test framework
assert_equals() {
  local expected="$1"
  local actual="$2"
  local test_name="$3"
  
  ((TESTS_RUN++))
  
  if [[ "$expected" == "$actual" ]]; then
    echo -e "${GREEN}✅ PASS${NC}: $test_name"
    ((TESTS_PASSED++))
  else
    echo -e "${RED}❌ FAIL${NC}: $test_name"
    echo "    Expected: $expected"
    echo "    Actual: $actual"
    ((TESTS_FAILED++))
  fi
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local test_name="$3"
  
  ((TESTS_RUN++))
  
  if [[ "$haystack" =~ $needle ]]; then
    echo -e "${GREEN}✅ PASS${NC}: $test_name"
    ((TESTS_PASSED++))
  else
    echo -e "${RED}❌ FAIL${NC}: $test_name"
    echo "    Should contain: $needle"
    ((TESTS_FAILED++))
  fi
}

assert_file_exists() {
  local file="$1"
  local test_name="$2"
  
  ((TESTS_RUN++))
  
  if [[ -f "$file" ]]; then
    echo -e "${GREEN}✅ PASS${NC}: $test_name"
    ((TESTS_PASSED++))
  else
    echo -e "${RED}❌ FAIL${NC}: $test_name"
    echo "    File not found: $file"
    ((TESTS_FAILED++))
  fi
}

# Test basic functionality
test_basic_functionality() {
  echo -e "\n${CYAN}Testing Basic Functionality${NC}"
  
  # Test help output
  local help_output=$(../gitpush.sh --help 2>&1)
  assert_contains "$help_output" "Usage: gitpush" "Help command works"
  assert_contains "$help_output" "--version" "Help shows version option"
  assert_contains "$help_output" "--simulate" "Help shows simulate option"
  
  # Test version
  local version=$(../gitpush.sh --version 2>&1)
  assert_contains "$version" "v1.2.0" "Version command works"
}

# Test file structure
test_file_structure() {
  echo -e "\n${CYAN}Testing File Structure${NC}"
  
  # Core files
  assert_file_exists "../gitpush.sh" "Main script exists"
  assert_file_exists "../README.md" "README exists"
  assert_file_exists "../CHANGELOG.md" "CHANGELOG exists"
  assert_file_exists "../CONTRIBUTING.md" "CONTRIBUTING guide exists"
  assert_file_exists "../install.sh" "Install script exists"
  
  # Package files
  assert_file_exists "../package.json" "npm package.json exists"
  assert_file_exists "../brew/gitpush.rb" "Homebrew formula exists"
}

# Test AI features availability
test_ai_features() {
  echo -e "\n${CYAN}Testing AI Features${NC}"
  
  # Check if AI modules exist
  if [[ -f "../lib/ai/ai_manager.sh" ]]; then
    echo -e "${GREEN}✅ PASS${NC}: AI manager exists"
    ((TESTS_PASSED++))
  else
    echo -e "${YELLOW}⚠️ SKIP${NC}: AI manager not found (optional)"
  fi
  ((TESTS_RUN++))
}

# Test configuration
test_configuration() {
  echo -e "\n${CYAN}Testing Configuration${NC}"
  
  # Check environment files
  assert_file_exists "../.env.example" "Environment example exists"
  
  # Test executable permissions
  if [[ -x "../gitpush.sh" ]]; then
    echo -e "${GREEN}✅ PASS${NC}: Main script is executable"
    ((TESTS_PASSED++))
  else
    echo -e "${RED}❌ FAIL${NC}: Main script is not executable"
    ((TESTS_FAILED++))
  fi
  ((TESTS_RUN++))
}

# Performance test
test_performance() {
  echo -e "\n${CYAN}Testing Performance${NC}"
  
  # Test help command speed
  local start=$(date +%s%N)
  ../gitpush.sh --help > /dev/null 2>&1
  local end=$(date +%s%N)
  local duration=$(( (end - start) / 1000000 ))
  
  if [[ $duration -lt 1000 ]]; then
    echo -e "${GREEN}✅ PASS${NC}: Help command < 1000ms ($duration ms)"
    ((TESTS_PASSED++))
  else
    echo -e "${YELLOW}⚠️ SLOW${NC}: Help command took $duration ms"
  fi
  ((TESTS_RUN++))
}

# Integration test
test_integration() {
  echo -e "\n${CYAN}Testing Integration${NC}"
  
  # Create test repo
  local test_dir="/tmp/gitpush_test_$$"
  mkdir -p "$test_dir"
  cd "$test_dir"
  git init > /dev/null 2>&1
  git config user.name "Test User" > /dev/null 2>&1
  git config user.email "test@example.com" > /dev/null 2>&1
  
  # Test simulation mode
  echo "test content" > test.txt
  git add test.txt
  local sim_output=$("$(cd - > /dev/null && pwd)/gitpush.sh" --simulate --message "test commit" --yes 2>&1)
  
  if [[ "$sim_output" =~ (Simulate|simulation) ]]; then
    echo -e "${GREEN}✅ PASS${NC}: Simulation mode works"
    ((TESTS_PASSED++))
  else
    echo -e "${RED}❌ FAIL${NC}: Simulation mode doesn't work"
    echo "    Output: $sim_output"
    ((TESTS_FAILED++))
  fi
  ((TESTS_RUN++))
  
  # Cleanup
  cd - > /dev/null
  rm -rf "$test_dir"
}

# Run all tests
run_all_tests() {
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}🧪 GITPUSH TEST SUITE v1.2.0${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  
  # Change to tests directory
  cd "$(dirname "${BASH_SOURCE[0]}")"
  
  # Run test suites
  test_basic_functionality
  test_file_structure
  test_ai_features
  test_configuration
  test_performance
  test_integration
  
  # Summary
  echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}📊 TEST SUMMARY${NC}"
  echo -e "Total tests: $TESTS_RUN"
  echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
  echo -e "${RED}Failed: $TESTS_FAILED${NC}"
  
  local pass_rate=$((TESTS_PASSED * 100 / TESTS_RUN))
  echo -e "Pass rate: ${GREEN}${pass_rate}%${NC}"
  
  if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}🎉 ALL TESTS PASSED!${NC}"
    exit 0
  else
    echo -e "\n${RED}❌ SOME TESTS FAILED${NC}"
    exit 1
  fi
}

# Run tests
run_all_tests