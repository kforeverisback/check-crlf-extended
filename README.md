# GitHub Action to check for files with CRLF line endings

A GitHub Action designed to ensure developers maintain consistent line endings, preventing issues caused by developers who may overlook or misunderstand Git's line ending settings (particularly autocrlf setting in Windows).

By default checks all files in the repository (excluding the `.git` folder), but can be given a list of separate directories to check include exclude glob/regex pattern and a dir depth to search.

## References

Some references to line endings functionality included in `git`:

- how to set specific line endings for each file by using gitattributes: <https://git-scm.com/docs/gitattributes#_text>
- <https://docs.github.com/en/free-pro-team@latest/github/using-git/configuring-git-to-handle-line-endings>
- <https://adaptivepatchwork.com/2012/03/01/mind-the-end-of-your-line/>

## Inputs

- `directory`: Directory/Folder path to check. that represents the root of repo ($GITHUB_WORKSPACE).
               [default: "."]
- `line_ending_type`: Check CRLF/LF or mixed line ending.
                Possible values are CRLF, LF or MIXED (case insensitive).
                - CRLF: Checks files only with CRLF line endings.
                - LF: Checks files only with LF line endings.
                - MIXED: Checks files both with CRLF and LF (mixed) line endings.
                [default: "crlf"]
- `include_pattern`: Include pattern for including files (using `find -regex` or `find -name`).
                Note: When pattern_type is `regex`, this is used as regex pattern.
                When pattern_type is `shell_glob`, this is used as shell glob pattern.
                For `regex` pattern_type, the match happens on the whole path.
                For `shell_glob` pattern_type, the path with the leading directories is removed and is operated on base filenames only.
                The default value `*` is used with the default pattern_type `shell_glob`.
                See https://man7.org/linux/man-pages/man1/find.1.html for more information.
                [default: ""]
- `exclude_pattern`: Regular expression for excluding files (using `find -not -regex` or `find -not -name`).
                Note: see `include_pattern` note section.
                [default: ""]
- `pattern_type`: Type of pattern match to use for `include_pattern` and `exclude_pattern`.
            Possible values are either `shell_glob` or `regex`. Default is `shell_glob`.
            For `regex` pattern_type, the match happens on the whole path.
            For `shell_glob` pattern_type, the path with the leading directories
            is removed and match happens on base filenames only.
            The regex pattern follows egrep syntax. See `man egrep` for more information.
            [default: "shell_glob"]
- `max_dir_depth`: Max depth of folder to search for files. Repo root directory `./` is at depth 1. See `man find` for more information.
                [default: "999"]

## Example

```yml
name: Example usage

on: push

jobs:
  example-workflow:
    name: Example workflow using the Check CRLF action
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository contents
        uses: actions/checkout@v4

      - name: Use action to check for CRLF endings
        uses: kforeverisback/check-crlf-extended@v2
        with: # omit this mapping to use default path
          directory: ./test-files
          line_ending_type: 'LF'
      - name: Check CRLF files with include+exclude glob
        uses: kforeverisback/check-crlf-extended@v2
        continue-on-error: true
        with:
          directory: ./test-files-2
          line_ending_type: 'cRLf'
          include_pattern: 'CRLF*'
          exclude_pattern: '*only'
      - name: Check CRLF files with exclude regex
        uses: kforeverisback/check-crlf-extended@v2
        continue-on-error: true
        with:
          directory: ./test-files
          line_ending_type: 'CRLF'
          exclude_pattern: '.*(EXCLUDE|exclude).*'
          pattern_type: 'regex'
```

## Appreciation

> This action is based on `https://github.com/erclu/check-crlf.git` with some extended functionality.
> As well as some help from ChatGPT and Gemini for logging and bash variable manipulation.
