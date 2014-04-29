$( document ).ready(function() {
		// connect to node
		var socket = io.connect(node_address);

		socket.emit('getProjectName');
		socket.emit('raspimjpeg', 'stop');

		var exposureValue = document.getElementById('exposure').value;
		var cameraHeightValue = document.getElementById('cameraHeight').value;
		var cameraWidthValue = document.getElementById('cameraWidth').value;
		socket.emit('configureCamera', {
			exposure: exposureValue,
			cameraHeight: cameraHeightValue,
			cameraWidth: cameraWidthValue
});


		socket.on('projectName', function (projectName) {
			if(projectName != "")
			document.getElementById('projectName').innerHTML = projectName;
			else
			document.getElementById('projectName').innerHTML = 'default';
			});

socket.on('newImage', function (filename) {
		document.getElementById('snapshotImage').src = document.getElementById('snapshotImage').src+ '?' + Math.random();
		document.getElementById('snapshotImage').style.visibility='visible';
		$( "#dialog" ).dialog("close");
		});

socket.on('stillWorking', function(){
		document.getElementById('alertText').innerHTML = 'Camera is working please wait ...';
		$( "#dialog" ).dialog("open");
		});

socket.on('cameraStopped', function(){
		$( "#dialog" ).dialog("close");
		});

socket.on('renderingStopped', function(){
		$( "#dialog" ).dialog("close");
		});

socket.on('mencoderStdout', function(data){
		document.getElementById('alertText').innerHTML = '<p>Waiting for the movie to be render ...</p><p>Note: it can take some while.</p>';
		});

// default timelapse values
var spinnerMinutes = $( "#minutes" ).spinner(); 
spinnerMinutes.spinner("value", 0);
var spinnerHours = $( "#hours" ).spinner(); 
spinnerHours.spinner("value", 3);
var spinnerSeconds = $( "#seconds").spinner(); 
spinnerSeconds.spinner("value", 0);
var spinnerInterval = $( "#interval").spinner(); 
spinnerInterval.spinner("value", 1000);
spinnerInterval.spinner("option", "min", 10);

/* Button to submit */

// start render button
$( "#startRendering" ).button().click(function( event ) {
		event.preventDefault();
		socket.emit('startRendering', {
fps:document.getElementById('fps').value,
bitrate:document.getElementById('bitrate').value
});
		document.getElementById('alertText').innerHTML = '<p>Waiting for the movie to be render ...</p><p>Note: it can take some while.</p>';
		$( "#dialog" ).dialog("open");
		});

// DEPRECATED
// start timelapse button
/*$( "#startTimelaps" ).button().click(function( event ) {
  event.preventDefault();
  document.getElementById('alertText').innerHTML = 'Timelapse running ...';
  $( "#dialog" ).dialog("open");
  socket.emit('startTimelaps', { 
interval: spinnerInterval.spinner('value'),
hours: spinnerHours.spinner('value'),
minutes: spinnerMinutes.spinner('value'),
seconds: spinnerSeconds.spinner('value')
});
});*/

$( "#seeProjects" ).button().click(function( event ) {
		event.preventDefault();
		window.location.href = '/timelapse_movies';
		});

$( "#accordion" ).accordion({ active: false, collapsible: true });
// Take snapshot when accordion 'take snapshot' is active
$( "#accordion" ).accordion({
	activate: function( event, ui ){
		if(ui.oldHeader.attr("id") == 'configureCamera'){
			var exposureValue = document.getElementById('exposure').value;
			var cameraHeightValue = document.getElementById('cameraHeight').value;
			var cameraWidthValue = document.getElementById('cameraWidth').value;
			socket.emit('configureCamera', {
				exposure: exposureValue,
				cameraHeight: cameraHeightValue,
				cameraWidth: cameraWidthValue
			});
		}
		if(ui.oldHeader.attr("id") == 'timerControler'){
			socket.emit('changeTimelapseTiming', {
				interval: spinnerInterval.spinner('value'),
				hours: spinnerHours.spinner('value'),
				minutes: spinnerMinutes.spinner('value'),
				seconds: spinnerSeconds.spinner('value')
			});

		}

		if(ui.newHeader.attr("id") == 'takeSnapshot'){
			// In case of RaspiMJPEG running, stop it
			socket.emit('raspimjpeg', 'stop');
			document.getElementById('alertText').innerHTML = 'Waiting for the picture to be taken ...';
			$( "#dialog" ).dialog("open");
			socket.emit('takeSnapshot');
		}
		if(ui.oldHeader.attr("id") == 'preview_accordion'){
			socket.emit('raspimjpeg', 'stop');
			stop_preview();
		}
		if(ui.newHeader.attr("id") == 'preview_accordion'){
			socket.emit('raspimjpeg', 'start');
			start_preview();
		}

	}
});

$( "#dialog" ).dialog({
	dialogClass: "no-close",
});
$( "#dialog" ).dialog("close");

document.getElementById('snapshotImage').style.visibility='hidden';

$( "#whenRunTimelapse" ).combobox();

$( "#runTimelapse").button().click(function( event ) {
		var running = document.getElementById('whenRunTimelapse').value;
		var usingServo = document.getElementById('servoMotor').checked;
		socket.emit('applyTimelapse', {runTimelapse: running, useServo: usingServo});
		});

timelapseConfigurationChangedDialog

// If position have been set, notify it
socket.on('timelapseConfigurationChanged', function(){$( "#timelapseConfigurationChangedDialog" ).dialog("open");});

$( "#timelapseConfigurationChangedDialog" ).dialog({
	modal: true,
	autoOpen: false,
	buttons: {
		Ok: function() {
			$( this ).dialog( "close" );
		}
	}
});


});
