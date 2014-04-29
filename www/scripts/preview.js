
var mjpeg_img;

function reload_img () {
	//if(!halted) 
	mjpeg_img.src = "preview.jpg?time=" + new Date().getTime();
	//else setTimeout("reload_img()", 500);
}

// Automatically reload preview image
function start_preview() {

	// mjpeg
	mjpeg_img = document.getElementById("preview_img");
	mjpeg_img.onload = reload_img;
	reload_img();
}

function stop_preview(){
	mjpeg_img = document.getElementById("preview_img");
	mjpeg_img.onload = "";
}

