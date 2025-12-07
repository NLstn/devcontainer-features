#!/bin/bash

# This test file will be executed against the scenario defined in scenarios.json
# that installs the 'go-air' Feature with version set to 'latest'.

set -e

# Optional: Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "air command exists" bash -c "command -v air"
check "air version output" air -v
check "air executable is in GOPATH" bash -c "which air | grep -q 'go/bin/air'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
