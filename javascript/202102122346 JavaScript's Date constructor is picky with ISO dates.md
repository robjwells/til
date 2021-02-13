# JavaScript’s Date constructor is picky with ISO dates

#til #til-javascript

I have a LaunchBar action that constructed a new `Date` from a filename, but the format changed.

Originally, the date was given as `2021-02-12` but now it’s `20210212` without hyphens.

JavaScript’s `Date` constructor fails in the condensed format, but it’s easy to work around:

```javascript
// Before - 2021-02-12
const isoString = fn.substring(0, 10)
// After - 20210212
const [_, year, month, day] = fn.match(/^(\d{4})(\d{2})(\d{2})/)
const isoString = `${year}-${month}-${day}`
```