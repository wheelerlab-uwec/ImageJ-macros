// Get names and paths

#@ File (label = "Input directory", style = "directory") input
input = input + "/"
#@ File (label = "Output directory", style = "directory") output
output = output + "/"


function arena_track(input, output) {

	File.openSequence(input, "virtual bitdepth=8 filter=tif");
	folder = File.getNameWithoutExtension(input)
	run("Z Project...", "projection=[Average Intensity]");
	imageCalculator("Difference create stack", folder,"AVG_" + folder);
	selectImage("Result of " + folder);
	setAutoThreshold("Default dark");
	setThreshold(8,255,"raw");
	setOption("BlackBackground",false);
	run("Convert to Mask", "method=MaxEntropy background=Dark list create");
	run("MTrack2 ", "minimum=50 maximum=200 maximum_=25 minimum_=5 save display show show_0 show_1 save=" + output + "track.txt");
	selectWindow("Paths");
	save(output + "paths.jpg");
	close("*");

}

// Run function
//setBatchMode(true); 
arena_track(input, output);
//setBatchMode(false);