# collect f0 listing by gender.praat
# Dr. Cong Zhang, Radboud University, cong.zhang@ru.nl
# July 2021
# This script collects the f0 listing of the reference tier (ref_tier) and specify different ranges for different genders.
# This script also collects intensity. Formants are possible by uncommenting relevant sections.
# It works in Praat and comand line. 
# Make sure you change all the parameters before you run the script.

# To run a script in command line, modify and paste in your cmd:
# "C:/Users/path_to_praat/Praat.exe" --run "C:\Users\path_to_script\collect all f0 listing.praat"

# specify where your .wav and .TextGrid files are respectively
sound_directory$ = "C:\Users\wav\"
textGrid_directory$ = "C:\Users\tg\"

# search for the following strings for different genders
male_str$ = "M"
female_str$ = "F"

# f0 range settings
m_minimum_pitch = 60
m_maximum_pitch = 350

f_minimum_pitch = 70
f_maximum_pitch = 500

# Which tier do you want to analyze?
ref_tier = 2

 
########### Configurable settings. Usually no need to change.
Text writing preferences: "UTF-8"
sound_file_extension$ = ".wav"
textGrid_file_extension$ = ".TextGrid"
time_step = 0.01
preemphasis_from = 50
window_length = 0.025
### uncomment the following two parameters to extract formants (remember to also modify the titleline$ and resultline$)
# number_of_formants = 5
# maximum_formant = 6000



############################################
	## F0 for male speakers (file name contains "M")
	strings = Create Strings as file list: "list", sound_directory$ + "*"+ male_str$ + "*.wav"
	pause check whether all male speakers and only male speakers are included 
	numberOfFiles = Get number of strings
	
	# Check if the result file exists:
	if fileReadable (resultfile_m$)
		pause The result file 'resultfile_m$' already exists! Do you want to overwrite it?
		filedelete 'resultfile_m$'
	endif

	# Write a row with column titles to the result file(Tab-delimited):
	# (remember to edit this if you add or change the analyses!)
	titleline$ = "filename	text	StartTime	EndTime	time	f0	intensity 'newline$'"
	fileappend "'resultfile_m$'" 'titleline$'
	
	
	for ifile to numberOfFiles
	select Strings list
	filename$ = Get string: ifile
	# A sound file is opened from the listing:
	Read from file... 'sound_directory$''filename$'
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	soundname$ = selected$ ("Sound", 1)
	
	To Pitch: time_step, m_minimum_pitch, m_maximum_pitch

	select Sound 'soundname$'
	To Intensity: m_minimum_pitch, 0.01
	
	#### uncomment this section to also include formants(but remember to also modify the titleline$ and resultline$)
	# select Sound 'soundname$'
	# To Formant (burg): 0.001, number_of_formants, maximum_formant, window_length, preemphasis_from

	# Open a TextGrid by the same name:
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		

		numberOfIntervals = Get number of intervals... ref_tier
		# Pass through all intervals in the selected segment_tier:
		for interval to numberOfIntervals
			ref_label$ = Get label of interval... ref_tier interval
			

			if ref_label$ <> ""
			# if the interval has an unempty label, get its start and end, and duration:
				ref_start = Get starting point... ref_tier interval
				ref_end = Get end point... ref_tier interval
				# duration = ref_end - ref_start

				
								
				for i to (ref_end - ref_start)/0.01
					time = ref_start + i * 0.01
					select Pitch 'soundname$'
					f0 = Get value at time: time, "Hertz", "linear"
					select Intensity 'soundname$'
					intensity = Get value at time: time, "cubic"
					#### uncomment this section to also include formants(but remember to also modify the titleline$ and resultline$)
					# select Formant 'soundname$'
					# f1 = Get value at time: 1, time, "hertz", "linear"
					# f2 = Get value at time: 2, time, "hertz", "linear"
					# f3 = Get value at time: 3, time, "hertz", "linear"
					
					resultline$ = "'soundname$'	'ref_label$'	'ref_start'	'ref_end'	'time'	'f0'	'intensity' 'newline$'"

					fileappend "'resultfile_m$'" 'resultline$'
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
	plus Intensity 'soundname$'
	Remove
	select Strings list
	# and go on with the next sound file!
	writeInfoLine: ifile, "/", numberOfFiles
endfor
Remove

############################################
	## F0 for female speakers (file name contains "F")
	strings = Create Strings as file list: "list", sound_directory$ + "*"+ female_str$ + "*.wav"
	pause check whether all female speakers and only female speakers are included
	numberOfFiles = Get number of strings
	
	# Check if the result file exists:
	if fileReadable (resultfile_f$)
		pause The result file 'resultfile_f$' already exists! Do you want to overwrite it?
		filedelete 'resultfile_f$'
	endif

	# Write a row with column titles to the result file(Tab-delimited):
	# (remember to edit this if you add or change the analyses!)
	titleline$ = "filename	text	StartTime	EndTime	time	f0	intensity 'newline$'"
	fileappend "'resultfile_f$'" 'titleline$'
	
	for ifile to numberOfFiles
	select Strings list
	filename$ = Get string: ifile
	# A sound file is opened from the listing:
	Read from file... 'sound_directory$''filename$'
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	soundname$ = selected$ ("Sound", 1)
	To Pitch: time_step, f_minimum_pitch, f_maximum_pitch

	select Sound 'soundname$'
	To Intensity: f_minimum_pitch, 0.01
	
	#### uncomment this section to also include formants(but remember to also modify the titleline$ and resultline$)
	# select Sound 'soundname$'
	# To Formant (burg): 0.001, number_of_formants, maximum_formant, window_length, preemphasis_from

	# Open a TextGrid by the same name:
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		

		numberOfIntervals = Get number of intervals... ref_tier
		# Pass through all intervals in the selected segment_tier:
		for interval to numberOfIntervals
			ref_label$ = Get label of interval... ref_tier interval

			if ref_label$ <> ""
			# if the interval has an unempty label, get its start and end, and duration:
				ref_start = Get starting point... ref_tier interval
				ref_end = Get end point... ref_tier interval
				# duration = ref_end - ref_start
				
								
				for i to (ref_end - ref_start)/0.01
					time = ref_start + i * 0.01
					select Pitch 'soundname$'
					f0 = Get value at time: time, "Hertz", "linear"
					select Intensity 'soundname$'
					intensity = Get value at time: time, "cubic"
					#### uncomment this section to also include formants(but remember to also modify the titleline$ and resultline$)
					# select Formant 'soundname$'
					# f1 = Get value at time: 1, time, "hertz", "linear"
					# f2 = Get value at time: 2, time, "hertz", "linear"
					# f3 = Get value at time: 3, time, "hertz", "linear"

					resultline$ = "'soundname$'	'ref_label$'	'ref_start'	'ref_end'	'time'	'f0'	'intensity' 'newline$'"

					fileappend "'resultfile_f$'" 'resultline$'
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
	plus Intensity 'soundname$'
	Remove
	select Strings list
	# and go on with the next sound file!
	writeInfoLine: ifile, "/", numberOfFiles
endfor

############################################
Remove
