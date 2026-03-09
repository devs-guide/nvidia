(*
ChatGPT: 5.2 Thinking (extended) 03/01/26

Tic-Tac-Toe (Dialog-Only) — Pure AppleScript

- No external apps, no terminal commands, no GUI scripting.
- Interface uses only display dialog.
- User plays X, Computer plays O (simple strategy: win, block, center, corners, sides).
- Slots are numbered 1–9 when empty.

Run in Script Editor.
*)

property kTitle : "Tic-Tac-Toe"
property winTriples : {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9}, {3, 5, 7}}

on run
	set board to {"", "", "", "", "", "", "", "", ""}
	
	display dialog "Welcome to Tic-Tac-Toe!" & return & return & "You are X. Computer is O." & return & "Enter a number 1–9 to place your X." buttons {"Start"} default button "Start" with title kTitle
	
	try
		repeat
			-- Player turn
			set board to playerMove(board)
			set status to evaluateBoard(board)
			if status is not "none" then exit repeat
			
			-- Computer turn
			set board to computerMove(board)
			set status to evaluateBoard(board)
			if status is not "none" then exit repeat
		end repeat
		
		-- Final message
		set finalBoardText to boardText(board)
		if status is "X" then
			display dialog finalBoardText & return & return & "You win!" buttons {"OK"} default button "OK" with title kTitle
		else if status is "O" then
			display dialog finalBoardText & return & return & "Computer wins." buttons {"OK"} default button "OK" with title kTitle
		else
			display dialog finalBoardText & return & return & "It's a draw." buttons {"OK"} default button "OK" with title kTitle
		end if
	on error number -128
		-- User canceled / Quit
		return
	end try
end run


-- =========================
-- Player Move
-- =========================
on playerMove(board)
	repeat
		set promptText to boardText(board) & return & return & "Your move (X):" & return & "Type an available slot number (1–9)."
		
		try
			set resp to display dialog promptText default answer "" buttons {"Quit", "Play"} default button "Play" cancel button "Quit" with title kTitle
		on error number -128
			error number -128
		end try
		
		set inputText to my trimText(text returned of resp)
		if inputText is "" then
			display dialog "Please type a number from 1 to 9." buttons {"OK"} default button "OK" with title kTitle
		else
			set moveIndex to my parseMoveIndex(inputText)
			if moveIndex is 0 then
				display dialog "Invalid input. Please enter a single number from 1 to 9." buttons {"OK"} default button "OK" with title kTitle
			else if item moveIndex of board is not "" then
				display dialog "That slot is already taken. Choose an empty slot." buttons {"OK"} default button "OK" with title kTitle
			else
				set item moveIndex of board to "X"
				exit repeat
			end if
		end if
	end repeat
	return board
end playerMove


-- =========================
-- Computer Move
-- =========================
on computerMove(board)
	set available to my availableMoves(board)
	if (count of available) is 0 then return board
	
	-- Strategy:
	-- 1) Win if possible
	set winMove to my findWinningMove(board, "O")
	if winMove is not 0 then
		set item winMove of board to "O"
		return board
	end if
	
	-- 2) Block player's win
	set blockMove to my findWinningMove(board, "X")
	if blockMove is not 0 then
		set item blockMove of board to "O"
		return board
	end if
	
	-- 3) Take center if available
	if item 5 of board is "" then
		set item 5 of board to "O"
		return board
	end if
	
	-- 4) Take a corner if available
	set corners to {1, 3, 7, 9}
	set cornerPick to my firstAvailableFrom(board, corners)
	if cornerPick is not 0 then
		set item cornerPick of board to "O"
		return board
	end if
	
	-- 5) Take a side if available
	set sides to {2, 4, 6, 8}
	set sidePick to my firstAvailableFrom(board, sides)
	if sidePick is not 0 then
		set item sidePick of board to "O"
		return board
	end if
	
	-- Fallback: first available
	set item (item 1 of available) of board to "O"
	return board
end computerMove


-- =========================
-- Board Rendering
-- =========================
on boardText(board)
	set a to my cellText(board, 1)
	set b to my cellText(board, 2)
	set c to my cellText(board, 3)
	set d to my cellText(board, 4)
	set e to my cellText(board, 5)
	set f to my cellText(board, 6)
	set g to my cellText(board, 7)
	set h to my cellText(board, 8)
	set i to my cellText(board, 9)
	
	set line1 to " " & a & " | " & b & " | " & c & " "
	set line2 to "---+---+---"
	set line3 to " " & d & " | " & e & " | " & f & " "
	set line4 to "---+---+---"
	set line5 to " " & g & " | " & h & " | " & i & " "
	
	return line1 & return & line2 & return & line3 & return & line4 & return & line5
end boardText

on cellText(board, idx)
	set v to item idx of board
	if v is "" then
		return (idx as string)
	else
		return v
	end if
end cellText


-- =========================
-- Game Evaluation
-- Returns: "X", "O", "draw", or "none"
-- =========================
on evaluateBoard(board)
	repeat with triple in winTriples
		set i1 to item 1 of triple
		set i2 to item 2 of triple
		set i3 to item 3 of triple
		
		set v1 to item i1 of board
		set v2 to item i2 of board
		set v3 to item i3 of board
		
		if v1 is not "" and v1 is v2 and v2 is v3 then
			return v1 -- "X" or "O"
		end if
	end repeat
	
	-- Draw?
	repeat with idx from 1 to 9
		if item idx of board is "" then return "none"
	end repeat
	return "draw"
end evaluateBoard


-- =========================
-- Helpers: Move selection
-- =========================
on availableMoves(board)
	set moves to {}
	repeat with i from 1 to 9
		if item i of board is "" then set end of moves to i
	end repeat
	return moves
end availableMoves

on firstAvailableFrom(board, indexList)
	repeat with n in indexList
		set ix to (n as integer)
		if item ix of board is "" then return ix
	end repeat
	return 0
end firstAvailableFrom

on findWinningMove(board, mark)
	-- Return index (1–9) that completes a win for mark, else 0
	repeat with triple in winTriples
		set i1 to item 1 of triple
		set i2 to item 2 of triple
		set i3 to item 3 of triple
		
		set v1 to item i1 of board
		set v2 to item i2 of board
		set v3 to item i3 of board
		
		if v1 is mark and v2 is mark and v3 is "" then return i3
		if v1 is mark and v3 is mark and v2 is "" then return i2
		if v2 is mark and v3 is mark and v1 is "" then return i1
	end repeat
	return 0
end findWinningMove


-- =========================
-- Helpers: Input parsing & trimming
-- =========================
on parseMoveIndex(t)
	-- Accept only a single digit 1–9; otherwise 0
	if (count of characters of t) is not 1 then return 0
	set ch to character 1 of t
	if ch is in "123456789" then return (ch as integer)
	return 0
end parseMoveIndex

on trimText(t)
	-- Trim leading/trailing spaces, tabs, and returns
	set ws to {space, tab, return}
	set s to t as string
	
	-- Leading
	repeat while (length of s) > 0 and (character 1 of s) is in ws
		if (length of s) is 1 then
			set s to ""
		else
			set s to text 2 thru -1 of s
		end if
	end repeat
	
	-- Trailing
	repeat while (length of s) > 0 and (character -1 of s) is in ws
		if (length of s) is 1 then
			set s to ""
		else
			set s to text 1 thru -2 of s
		end if
	end repeat
	
	return s
end trimText