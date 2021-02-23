# How to wrap bc to do calculations

I find [`bc`][] trips me up when I try to calculations at the shell, so I wrapped it.

There are two hazards for me:

1. Failure to handle expressions without a final newline.
2. Integer division.

## Final newline missing

No 1 often occurs when I produce a list of numbers in [BBEdit][], usually extracted and transformed via regexes.

For example, we get a PDF receipt from Sainbury’s for our online shopping, and to work out my share I like to edit the text from [`pdftotext`][] in BBEdit, then run the line totals through a pipeline to calculate the total.

That used to look like this:

```sh
$ pbpaste | paste -s -d '+' - | bc
609
```

`pbpaste` pastes the macOS system clipboard, [`paste`][] joins those lines with `+`, and `bc` (should!) print the total.

Except this happens if you’re missing a final newline:

```sh
$ pbpaste | paste -s -d '+' - | bc
(standard_in) 1: parse error
```

## Integer division

And secondly, with the default settings, `bc` does integer division:

```sh
$ bc <<< 9/2
4
```

Which can be fixed by setting `scale`

```sh
$ bc <<< 'scale=2; 9/2'
4.50
```

(`<<<` starts a “here-string”, which you can learn more about at `man -P "less -p '<<<'" zshmisc`, which will take you directly to the right part of the `zshmisc` man page. Search the `bash` man page if you’re using `bash`, but it’s significantly more terse than the `zsh` explanation.)

## Wrapping `bc`

So I wrote a simple wrapper script, `calc`:

```sh
#!/usr/local/bin/zsh
set -euo pipefail

# Read expression from $1 or stdin.
if [ $# -ge 1 ]; then
    expression=$1
else
    read expression
fi

# Default scale to 3 (.123) if $2 is not given.
bc <<< "scale=${2:-3}; $expression"
```

The conditional in the middle just handles being called in a pipe, with the expression coming on standard input, or having the expression provided as the first argument.

I set the scale to 3 by default (showing 3 decimal places), but you can configure that with the second argument.

Using a here-string for `bc`’s input means that it should work whether or not there is a final newline.

[`bc`]: https://www.gnu.org/software/bc/
[BBEdit]: https://www.barebones.com/products/bbedit/
[`pdftotext`]: https://linux.die.net/man/1/pdftotext
[`paste`]: https://linux.die.net/man/1/paste

#til #til-shell