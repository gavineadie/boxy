###Boxy

I admit it; I'm obsessive!  Many years ago I used a compiler that would 'prettyprint' code as it compiled it so that the listings, on paper, would look nice -- actually it made it much easier to read as well.

A few years ago I decided I wanted to pretty up my Objective-C in a similar way.  Since I wasn't quite crazy enough to actually modify the clang compiler, I wrote `boxy` which only ormaments files. The `boxy` app is an Objective-C shell command which replaces certain directives in any file with pretty boxes.

For example, the following text:

	/*box
		This method is a ghastly mistake
	*/

is transformed into:

	┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
	┃	This method is a ghastly mistake             ┃
	┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

Since Markdown may have trouble with rendering this, that's a solid box made from unicode symbols which surrounds the text.

If your manager hates such foolishness then `unboxy` will reverse the process.

Both `boxy` and `unboxy` take one parameter - the name of the file to be dolled up, ie:

		boxy file_that_was_ugly.m
		unboxy file_to_be_made_ugly.m

There are a few variations of the box style, double, heavy, normal and dotted; more about those when I'm not running to supper.

There's also `boxer` which changes local ascii-art boxes into really arty boxes, for example:

    		+---+
    		|abc|
    		+---+

becomes:

			┏━━━┓
    		┃abc┃
    		┗━━━┛
		
	

_draft: 2015-04-03_