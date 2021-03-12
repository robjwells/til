# `git` add takes an `--update` flag

`git add --all` will stage all changed and untracked files in the working tree.

`git add --update`, however, will only stage files that are already tracked in git.

I discovered this when trying to stage an edit to one of my dotfiles (my `.gitconfig` actually!), where doing `add --all` attempted to add everything in the working tree (my home directory).

`add --update` however will just "refresh" the tracked files  so that any changes you’ve made will be reflected in the index, ready to commit.

[See the documentation for `git add --update` here][update].

[update]: https://git-scm.com/docs/git-add#Documentation/git-add.txt--u

#til #til-git