#!/bin/bash
# Test fixtures for native-tools-enforcer hook script testing
# ============================================================
# Extends the shared test helper with native-tools-enforcer specific configuration.

# Load shared core helper (handles REPO_ROOT, libraries, and base functions)
# Path: from test file (plugin-tests/native-tools-enforcer) up 1 level to plugin-tests/
load "${BATS_TEST_DIRNAME}/../test_helper/common_setup"

# Path to native-tools-enforcer hook scripts
SCRIPTS_DIR="${REPO_ROOT}/plugins/native-tools-enforcer/hooks/scripts"
