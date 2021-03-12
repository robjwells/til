# git ignores aliases that shadow existing commands

I added an alias for `git commit --amend` to my `.gitconfig` so that (I hoped!) I could just type `git am`.

Unfortunately [`git am` already exists as a build-in command][git-am], and [git ignores aliases that shadow existing commands][aliases].

So now my alias is just `git m`.

[git-am]: https://git-scm.com/docs/git-am
[aliases]: https://git-scm.com/docs/git-config#Documentation/git-config.txt-alias

#til #til-git