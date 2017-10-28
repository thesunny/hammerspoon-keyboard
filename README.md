# README

There is one small step you have to take outside of Hammerspoon for this to
work. In any newer version of a Mac OS, you must remap the `CAPS LOCK` to the
`ESCAPE` key.

As of 2017-08-19, It is

```
System Preferences >
Keyboard >
Modifier Keys >

Then set:

Caps Lock Key: Escape
```


## Overloading Caps Lock to SUPER

Tapping Caps Lock will invoke the ESCAPE keystroke.

However, if you hold the ESCAPE key while pressing other keys, you will have
access to a number of keystrokes that are otherwise impossible or difficult
to access without taking your hands off of home row.

Technically, how it works is if the CAPSLOCK key is held for more than about 0.2 seconds, then it becomes the SUPER key. This is a made up modifier to give us access to more functions.

Also, if you press CAPSLOCK and press any SUPER key combination, it disables its ESCAPE function.



## VIM Navigation

While holding down SUPER hit:

  h -> left
  j -> down
  k -> up
  l -> right


## Backtick

Backticks are hard to type. We use SUPER+' to get `.

  ' -> `

Makes a lot of sense her too because a backtick is basically just a modifier single quote. It's the same but facing backwards. Also makes sense because all the String keys are on the same key `quote`, `single quote` and `backtick`.


## Braces

While regular brackets are fairly easy to type, the curly braces and the square brackets are more difficult. I think this is partially due to the Microsoft Keyboard I'm using but never-the-less, I've remapped them like so:

  u -> {
  i -> }
  , -> [
  . -> ]

The logic for this is that I type {} a lot so having them easy to access with my two strongest fingers is great.

Arrays are typed less often so I've assign them to , and . because these are actually very similar to SHIFT+, and SHIFT+. which equate to <>. In my version, SUPER+, and SUPER+. equate to [].

Another option was to use o and p but because these are weaker fingers and also there is some confusion about their placement near {}. Putting them completely separate actually created a nice mental separation.


## COMING SOON

  s -> SHIFT

While playing with the VIM Navigation, I was originally going to remap all the modifier keys but really found that only SHIFT was a little problematic. I think I can fix most of my problems by just mapping `s` to `SHIFT` which works well because it's a good chording finger and also `s` happens to be the firs letter in `SHIFT`.