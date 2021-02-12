#!/usr/local/bin/zsh

PATH="/usr/local/bin:$PATH"

cat preamble.md

fd . -t d --exact-depth=1 | sort | while read directory; do
	echo "\n## $directory\n"
	git ls-files "$directory" | sort | while read filename; do
		topic="`rg '.*\d{12} ([^./]+).md' -r '$1' <<< "$filename"`"
		linksafe="`sd ' ' '%20' <<< "$filename"`"
		echo "- [$topic]($linksafe)"
	done
done
