//define input Directory
DirPath = getDir("select input files Directory");
fileList = getFileList(DirPath);
//define output directories

DirPath_DAPI = getDir("select DAPI output");
DirPath_C1qc = getDir("select C1qc output");
DirPath_SPP1 = getDir("select SPP1 output");
DirPath_JPEG = getDir("select JPEG output");

//general Information
print("in total "+fileList.length+" images");

//forloop 
for (i = 0; i < fileList.length; i++) {
	//blank
	run("Close All");

	//open file
	open(DirPath + fileList[i]);
	Title = getTitle();
	
	//Max-IP Z-Projection
	selectWindow(Title);
	run("Z Project...", "projection=[Max Intensity]");

	selectWindow(Title);
	close();
	//Split channels
	selectWindow("MAX_" + Title);
	run("Split Channels");

	//run("Brightness/Contrast...");
	selectWindow("C1-MAX_" + Title);
	setMinAndMax(550, 3600);
	rename("DAPI");
	selectWindow("C2-MAX_"+Title);
	rename("Background");
	selectWindow("C3-MAX_" + Title);
	setMinAndMax(1800, 3500);
	rename("C1qc-Cy3");
	selectWindow("C4-MAX_"+Title);
	setMinAndMax(500, 2000);
	rename("SPP1-Cy5");


	//merge channels for JPEG
	run("Merge Channels...", "c1=[SPP1-Cy5] c3=[DAPI] c4=[C1qc-Cy3] create keep ");
	//save Duo and Mono as tiff
	selectWindow("Composite");
	saveAs("jpeg", DirPath_JPEG + Title);
	close();

	//save single-Maps
   	selectWindow("DAPI");
	saveAs("tiff", DirPath_DAPI + Title + "_DAPI");
	selectWindow("C1qc-Cy3");
	saveAs("tiff", DirPath_C1qc + Title + "_C1qc");
	selectWindow("SPP1-Cy5");
	saveAs("tiff", DirPath_SPP1 + Title + "_SPP1");

	
	//Log-ID
	print(i+1 + " of " + fileList.length + " processed - " + (i+1)/fileList.length*100 + "%");
	run("Close All");

}
//


