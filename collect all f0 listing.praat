# collect all f0 listing.praat
# Dr. Cong Zhang, Radboud University, cong.zhang@ru.nl
# July 2021
# This script collects the f0 listing of the reference tier (ref_tier).
# It works in Praat and comand line. 
# Make sure you change all the parameters before you run the script.

# To run a script in command line, modify and paste in your cmd::
# "C:/Users/path_to_praat/Praat.exe" --run "C:\Users\path_to_script\collect all f0 listing.praat"



# specify where your .wav and .TextGrid files are respectively
sound_directory$ = "C:\Users\wav\"
textGrid_directory$ = "C:\Users\tg\"

# specify where you would like to save your result file (a .txt file)
resultfile$ = "C:\Users\result\raw.txt"

# specify which tier you would like to use as a reference tier (the values will only be extracted where an interval is NOT blank on this tier)
ref_tier = 4

# speficy the max and min f0 values for extraction
minimum_pitch = 75
maximum_pitch = 500

# you can change the following settings if you know what they are (same as in praat commands)	
Text writing preferences: "UTF-8"
sound_file_extension$ = ".wav"
textGrid_file_extension$ = ".TextGrid"

preemphasis_from = 50
window_length = 0.025
time_step = 0.01

# creating a list of .wav files 
strings = Create Strings as file list: "list", sound_directory$ + "*.wav"
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete 'resultfile$'
endif

# Write a row with column titles to the result file(tab-delimited):
# (remember to edit this if you add or change the analyses!)

titleline$ = "filename	text	StartTime	EndTime	time	f0 'newline$'"
fileappend "'resultfile$'" 'titleline$'

# Go through all the sound files, one by one:
for ifile to numberOfFiles
	select Strings list
	filename$ = Get string: ifile
	
	# A sound file is opened from the listing:
	Read from file... 'sound_directory$''filename$'
	
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	soundname$ = selected$ ("Sound", 1)
	To Pitch: 0.001, minimum_pitch, maximum_pitch
	
	#### uncomment this section to also include intensity and/or formants(but remember to also modify the titleline$ and resultline$)
	# To Intensity: minimum_pitch, 0.01
	# select Sound 'soundname$'
	# To Formant (burg): 0.001, number_of_formants, maximum_formant, window_length, preemphasis_from

	# Open a TextGrid with the same name:
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		

		numberOfIntervals = Get number of intervals... ref_tier
		# Pass through all intervals in the selected segment_tier:
		for interval to numberOfIntervals
			ref_label$ = Get label of interval... ref_tier interval
			

			if ref_label$ <> ""
			# if the interval has a label that is not blank, get its start and end, and duration:
				ref_start = Get starting point... ref_tier interval
				ref_end = Get end point... ref_tier interval
				# duration = ref_end - ref_start
				
								
				for i to (ref_end - ref_start)/0.01
					time = ref_start + i * 0.01
					select Pitch 'soundname$'
					f0 = Get value at time: time, "Hertz", "linear"
					#### also uncomment this section to also include intensity and/or formants(but remember to also modify the titleline$ and resultline$)
					# select Intensity 'soundname$'
					# intensity = Get value at time: time, "cubic"
					# select Formant 'soundname$'
					# f1 = Get value at time: 1, time, "hertz", "linear"
					# f2 = Get value at time: 2, time, "hertz", "linear"
					# f3 = Get value at time: 3, time, "hertz", "linear"
					
					resultline$ = "'soundname$'	'ref_label$'	'ref_start'	'ref_end'	'time'	'f0' 'newline$'"

					fileappend "'resultfile$'" 'resultline$'
				select TextGrid 'soundname$'
				
				endfor

			endif
		endfor
		# Remove the TextGrid object from the object list
		select TextGrid 'soundname$'
		Remove
	endif
	# Remove the temporary objects from the object list
	select Sound 'soundname$'
	plus Pitch 'soundname$'
	Remove
	select Strings list
	# and go on with the next sound file!
	appendInfoLine: ifile, "/", numberOfFiles
endfor

Remove
