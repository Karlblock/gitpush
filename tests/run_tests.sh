#!/bin/bash

# 🧪 Gitpush Test Suite
# Automated testing for all features

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
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
    echo -e "${GREEN}✅ PASS${NC} : $test_name"
    ((TESTS_PASSED++))
  else
    echo -e "${RED}❌ FAIL${NC} : $test_name"
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
  
  if [[ "$haystack" =~ "$needle" ]]; then
    echo -e "${GREEN}✅ PASS${NC} : $test_name"
    ((TESTS_PASSED++))
  else
    echo -e "${RED}❌ FAIL${NC} : $test_name"
    echo "    Should contain: $needle"
    ((TESTS_FAILED++))
  fi
}

assert_file_exists() {
  local file="$1"
  local test_name="$2"
  
  ((TESTS_RUN++))
  
  if [[ -f "$file" ]]; then
    echo -e "${GREEN}✅ PASS${NC} : $test_name"
    ((TESTS_PASSED++))
  else
    echo -e "${RED}❌ FAIL${NC} : $test_name"
    echo "    File not found: $file"
    ((TESTS_FAILED++))
  fi
}

# Test basic functionality
test_basic_functionality() {
  echo -e "\n${CYAN}🧪 Testing Basic Functionality${NC}"
  
  # Test help output
  local help_output=$(../gitpush.sh --help 2>&1)
  assert_contains "$help_output" "Usage: gitpush" "Help command works"
  assert_contains "$help_output" "--version" "Help shows version option"
  assert_contains "$help_output" "--ai" "Help shows AI option"
  
  # Test version
  local version=$(../gitpush.sh --version 2>&1)
  assert_contains "$version" "v0." "Version command works"
}

# Test AI features
test_ai_features() {
  echo -e "\n${CYAN}🧪 Testing AI Features${NC}"
  
  # Check AI manager exists
  assert_file_exists "../lib/ai/ai_manager.sh" "AI manager exists"
  
  # Test AI availability check
  source ../lib/ai/ai_manager.sh
  local ai_available=$(check_ai_available)
  assert_equals "false" "$ai_available" "AI availability check works"
}

# Test analytics
test_analytics() {
  echo -e "\n${CYAN}🧪 Testing Analytics${NC}"
  
  # Check analytics manager exists
  assert_file_exists "../lib/analytics/stats_manager.sh" "Analytics manager exists"
  
  # Test stats initialization
  source ../lib/analytics/stats_manager.sh
  init_stats
  assert_file_exists "$HOME/.gitpush/stats.json" "Stats file created"
}

# Test plugin system
test_plugin_system() {
  echo -e "\n${CYAN}🧪 Testing Plugin System${NC}"
  
  # Check plugin manager exists
  assert_file_exists "../lib/plugins/plugin_manager.sh" "Plugin manager exists"
  
  # Check example plugin
  assert_file_exists "../plugins/emoji-prefix/plugin.json" "Example plugin exists"
}

# Test team features
test_team_features() {
  echo -e "\n${CYAN}🧪 Testing Team Features${NC}"
  
  # Check team manager exists
  assert_file_exists "../lib/team/team_manager.sh" "Team manager exists"
  
  # Test team initialization
  source ../lib/team/team_manager.sh
  init_team
  assert_file_exists "$HOME/.gitpush/team.json" "Team config created"
}

# Test file structure
test_file_structure() {
  echo -e "\n${CYAN}🧪 Testing File Structure${NC}"
  
  # Core files
  assert_file_exists "../gitpush.sh" "Main script exists"
  assert_file_exists "../README.md" "README exists"
  assert_file_exists "../ROADMAP.md" "ROADMAP exists"
  assert_file_exists "../CONTRIBUTING.md" "CONTRIBUTING guide exists"
  
  # GUI files
  assert_file_exists "../gui/package.json" "GUI package.json exists"
  assert_file_exists "../gui/src/main.js" "GUI main.js exists"
}

# Performance tests
test_performance() {
  echo -e "\n${CYAN}🧪 Testing Performance${NC}"
  
  # Test help command speed
  local start=$(date +%s%N)
  ../gitpush.sh --help > /dev/null 2>&1
  local end=$(date +%s%N)
  local duration=$(( (end - start) / 1000000 ))
  
  if [[ $duration -lt 100 ]]; then
    echo -e "${GREEN}✅ PASS${NC} : Help command < 100ms ($duration ms)"
    ((TESTS_PASSED++))
  else
    echo -e "${YELLOW}⚠️ SLOW${NC} : Help command took $duration ms"
  fi
  ((TESTS_RUN++))
}

# Security tests
test_security() {
  echo -e "\n${CYAN}🧪 Testing Security${NC}"
  
  # Check for hardcoded secrets
  local secrets_found=$(grep -r "api_key\|password\|secret" ../lib/ 2>/dev/null | grep -v "check_security_issues" | wc -l)
  assert_equals "0" "$secrets_found" "No hardcoded secrets in lib/"
  
  # Check file permissions
  local exec_files=$(find .. -name "*.sh" -type f)
  for file in $exec_files; do
    if [[ -x "$file" ]]; then
      echo -e "${GREEN}✅ PASS${NC} : $file is executable"
      ((TESTS_PASSED++))
    else
      echo -e "${YELLOW}⚠️ WARN${NC} : $file should be executable"
    fi
    ((TESTS_RUN++))
  done
}

# Integration tests
test_integration() {
  echo -e "\n${CYAN}🧪 Testing Integration${NC}"
  
  # Create test repo
  local test_dir="/tmp/gitpush_test_$$"
  mkdir -p "$test_dir"
  cd "$test_dir"
  git init > /dev/null 2>&1
  
  # Test simulation mode
  local sim_output=$(../gitpush.sh --simulate --message "test commit" --yes 2>&1)
  assert_contains "$sim_output" "Simulate:" "Simulation mode works"
  
  # Cleanup
  cd - > /dev/null
  rm -rf "$test_dir"
}

# Run all tests
run_all_tests() {
  echo -e "${MAGENTA}🧪 GITPUSH TEST SUITE v1.0${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  
  # Change to tests directory
  cd "$(dirname "${BASH_SOURCE[0]}")"
  
  # Run test suites
  test_basic_functionality
  test_ai_features
  test_analytics
  test_plugin_system
  test_team_features
  test_file_structure
  test_performance
  test_security
  test_integration
  
  # Summary
  echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${MAGENTA}📊 TEST SUMMARY${NC}"
  echo -e "Total tests: $TESTS_RUN"
  echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
  echo -e "${RED}Failed: $TESTS_FAILED${NC}"
  
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