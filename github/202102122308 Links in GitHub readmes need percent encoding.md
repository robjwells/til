# Links in GitHub READMEs need percent encoding

#til #til-github

While GitHub _does_ support relative links into the repo structure from the readme, any spaces in filenames need to be percent-encoded, ie replace them with `%20`.

This can easily be done with `sed`:

    sed 's/ /%20/g'

Or [`sd`](https://github.com/chmln/sd), which I prefer:

    sd ' ' '%20'
