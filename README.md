# check-crlf-extended

> GitHub Action to detect files with CRLF, LF, or mixed line endings

Maintain consistent line endings across your repository and prevent platform-induced issues caused by misconfigured Git settings (especially `core.autocrlf` on Windows).

## Features

- ✅ Detect CRLF, LF, or mixed line endings
- 🎯 Flexible file filtering with glob or regex patterns
- 📁 Configurable directory depth scanning
- ⚡ Lightweight implementation using standard POSIX tools

---

## Quick Start

```yaml
name: Check Line Endings
on: [push, pull_request]

jobs:
  check-line-endings:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Check for CRLF files
        uses: kforeverisback/check-crlf-extended@v2
        with:
          line_ending_type: CRLF
```

## Configuration

### Inputs

| Parameter | Description | Default |
|-----------|-------------|---------|
| `directory` | Directory to scan (relative to `$GITHUB_WORKSPACE`) | `.` |
| `line_ending_type` | Line ending type to detect: `CRLF`, `LF`, or `MIXED` (case-insensitive) | `crlf` |
| `include_pattern` | Include files matching this pattern | `*` |
| `exclude_pattern` | Exclude files matching this pattern | `` |
| `pattern_type` | Pattern matching type: `shell_glob` or `regex` | `shell_glob` |
| `max_dir_depth` | Maximum directory depth to search (root = depth 1) | `999` |

### Pattern Matching

- **`shell_glob`**: Matches against base filenames only (e.g., `*.txt`)
- **`regex`**: Matches against full file paths using `egrep` syntax

> **Note**: When using `regex`, see the [find manual](https://man7.org/linux/man-pages/man1/find.1.html) for pattern syntax.

## Usage Examples

### Basic CRLF Detection

```yaml
- name: Check for Windows line endings
  uses: kforeverisback/check-crlf-extended@v2
  with:
    line_ending_type: CRLF
```

### Advanced Pattern Filtering

```yaml
- name: Check specific file types with exclusions
  uses: kforeverisback/check-crlf-extended@v2
  with:
    directory: ./src
    line_ending_type: LF
    include_pattern: '*.{js,ts,py}'
    exclude_pattern: '*.min.*'
    pattern_type: shell_glob
```

### Regex-based Filtering

```yaml
- name: Check with regex exclusions
  uses: kforeverisback/check-crlf-extended@v2
  with:
    line_ending_type: MIXED
    exclude_pattern: '.*(test|spec).*\.(js|ts)$'
    pattern_type: regex
```

### Non-blocking Check

```yaml
- name: Check line endings (allow failures)
  uses: kforeverisback/check-crlf-extended@v2
  continue-on-error: true
  with:
    directory: ./docs
    line_ending_type: MIXED
```

## How It Works

This action uses standard POSIX utilities (`find`, `egrep`, `hexdump`) to:

1. Scan the specified directory (excluding `.git` by default)
2. Apply include/exclude patterns to filter files
3. Analyze line endings in matching files
4. Report files that match the specified line ending type

**Exit Behavior:**

- Returns exit code `0` when no matching files are found
- Returns non-zero exit code when matching files are detected (fails the workflow step unless `continue-on-error: true`)

## References

- [Git attributes for line ending control](https://git-scm.com/docs/gitattributes#_text)
- [GitHub's guide to Git line endings](https://docs.github.com/en/get-started/getting-started-with-git/configuring-git-to-handle-line-endings)
- [Understanding line endings](https://adaptivepatchwork.com/2012/03/01/mind-the-end-of-your-line/)

## Credits

Built upon [erclu/check-crlf](https://github.com/erclu/check-crlf) with extended functionality and enhanced logging capabilities.
