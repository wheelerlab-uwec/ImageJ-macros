// Get names and paths

// input = File.openDialog("Select a direction of files...");
// file_name = File.name;
// basename = File.getNameWithoutExtension(file_name)
// basename = replace(basename, "_crop", '');
// dir = File.getDirectory(file_path);

// input = "/Users/njwheeler/Desktop/macro_testing/";
// output = "/Users/njwheeler/Desktop/macro_testing/output/";

#@ File (label = "Input directory", style = "directory") input
input = input + "/"
#@ File (label = "Output directory", style = "directory") output
output = output + "/"

// Run function

function crop_track(input, output, filename) {
	
	basename = File.getNameWithoutExtension(filename);
	open(input + filename);

	makeOval(0, 0, 1616, 1616);
	run("Crop");
	setBackgroundColor(0, 0, 0);
	run("Clear Outside", "stack");
	run("Z Project...", "projection=[Max Intensity]");
	imageCalculator("Difference create stack", filename,"MAX_" + filename);
	selectWindow("Result of " + filename);
	run("Auto Threshold", "method=MaxEntropy white show stack use_stack_histogram");
	run("Make Binary", "method=Default background=Dark");
	run("MTrack2 ", "minimum=50 maximum=750 maximum_=25 minimum_=20 save display show show_0 show_1 save=" + output + basename + "_track.txt");
	selectWindow("Paths");
	save(output + basename + "_paths.jpg");
	close("*");

}

setBatchMode(true); 

file_list = getFileList(input);
avi_list = Array.filter(file_list, '.avi')
Array.print(avi_list);
for (i = 0; i < avi_list.length; i++){
        crop_track(input, output, avi_list[i]);
}

setBatchMode(false);