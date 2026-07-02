# Bash Template

```sh
#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function_name() {
    local arg1="${1:?Error: arg1 required}"
    local arg2="${2:-default}"
    # Implementation
}

trap 'echo "Error on line $LINENO"' ERR
```
