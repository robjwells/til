# How to call xargs with each argument in turn

#til #til-shell

By default xargs will pass all of standard out as arguments to the command (up to some limit; the man page says 5000).

The `-n` option allows you to specify how many arguments to take for each invocation of the command.

```sh
xargs -n 1 COMMAND
```
