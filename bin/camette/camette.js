// RaspiCam module via node.js

var rootDirectory = '/var/www/'
var imageDirectory = '/timelapse_movies/'
var defaultDirectory = 'default'
var picturesName = 'snapshot%04d.jpg'
var currentWebDirectory = imageDirectory + defaultDirectory;
var fs=require('fs');
var projectName ="default";

var RaspiCam = require('raspicam');
var io = require('socket.io').listen(1234);

var exec = require('child_process').exec;

var camera = new RaspiCam({
	mode: 'timelapse',
	output: rootDirectory + imageDirectory + defaultDirectory + picturesName,
	timeout: 3000,
	timelapse: 1000
});

// camera Lock variable
camera.lock = false;

camera.on("exit", function(timestamp){
        camera.lock = false;
});



// Socket handle

io.sockets.on('connection', function (socket) {
	if(camera.lock){
		console.log('started');
		socket.emit('stillWorking');
	} else console.log('stopped');

console.log(projectName);

	// Get the project name
	socket.on('getProjectName', function(){
		socket.emit('projectName', projectName);
	});

	// Timelapse command
	socket.on('startTimelaps', function(conf){
		if(!camera.lock){
			var workingDirectory;			
			currentWebDirectory = imageDirectory + projectName + '/';
			workingDirectory = rootDirectory + currentWebDirectory;
			if(!fs.existsSync(workingDirectory))
				fs.mkdirSync(workingDirectory);
                	camera.opts.mode= 'timelapse';
	                camera.opts.output= workingDirectory + '/' + picturesName;
			camera.opts.timelapse= conf.interval;
			camera.opts.timeout= (conf.hours * 3600 + conf.minutes * 60 + conf.seconds) * 1000;
			camera.lock = true;
			camera.start();
		}
	});

	// Take a snapshot command
	socket.on('takeSnapshot', function(conf){
		if(!camera.lock){
			delete camera.opts.timelapse;
			delete camera.opts.timeout;
			camera.opts.mode = 'photo';
			camera.opts.output = rootDirectory + imageDirectory + 'snapshot.png';
			currentWebDirectory = imageDirectory;
			camera.lock = true;
			camera.start();
		}
        });

	socket.on('createProject', function(_projectName){
		projectName = _projectName;
		if(!fs.existsSync(rootDirectory + imageDirectory + projectName)){
		        fs.mkdirSync(rootDirectory + imageDirectory + projectName);
			socket.emit('projectCreated');
		} else socket.emit('projectAlreadyExist');
	});

	socket.on('continueProject', function(_projectName){
		 projectName = _projectName;
                if(fs.existsSync(rootDirectory + imageDirectory + projectName)){
                        socket.emit('projectCreated');
                } else socket.emit('projectDoesntExist');
        });

	socket.on('configureCamera', function(data){
		camera.opts.width = data.cameraWidth;
		camera.opts.height = data.cameraHeight;
		camera.opts.exposure = data.exposure;
	});

	socket.on('startRendering', function(data){
		var workingDirectory;
		currentWebDirectory = imageDirectory + projectName + '/';
		workingDirectory = rootDirectory + currentWebDirectory;

		spawn = require("child_process").spawn;
		var child_process = spawn('mencoder', ['mf://'+ workingDirectory +'/*.jpg', '-mf', 'fps=' + data.fps, '-o', workingDirectory+'/' + projectName + 'movie.avi', '-ovc', 'x264', '-x264encopts', 'bitrate='+data.bitrate]);

		child_process.stdout.on('data', function (data) {
			socket.emit('mencoderStdout', data);
			console.log(data);
			dout = data;
		});

		child_process.stderr.on('data', function (data) {
			console.log('stderr: ' + data);
			derr = data;
		});


		child_process.on('close', function (code) {
			// Tell client rendering is done
			socket.emit( "renderingStopped" );
			child_process = null;
		});
	});


	socket.on('raspimjpeg', function(_command){
		if(_command == "start"){
			exec('echo ru 0 > /var/www/raspimjpeg_FIFO', function(err) {
                                if(err) {
                                        console.log(err);
                                } else {
                                        console.log("RaspiMJPEG started");
                                }
                        });
		} else if(_command == "stop") {
			exec('echo ru 1 > /var/www/raspimjpeg_FIFO', function(err) {
                                if(err) {
                                        console.log(err);
                                } else {
                                        console.log("RaspiMjpeg stopped");
                                }
                        }); 
		}
	});


	socket.on('sendSyncCommand', function(_command){
		var fs = require('fs');
		//LAUNCH timestamp width heigth delay duration project_name starttime
		if(_command == "launch"){
			var timestamp = Math.round(new Date().getTime()/1000);
			var timestamp2 = timestamp + 10;
			
			var command = "LAUNCH " + timestamp + " 1920 1080 3000 14400000 test " + timestamp2;
			fs.writeFile("/var/www/server/order", command, function(err) {
                                if(err) {
                                        console.log(err);
                                } else {
                                        socket.emit("orderSent");
                                        console.log("Order \"" + command + "\" send.");
                                }
                        });
		} else {
			fs.writeFile("/var/www/server/order", _command, function(err) {
				if(err) {
					console.log(err);
				} else {
					socket.emit("orderSent");
					console.log("Order \"" + _command + "\" send.");
				}
			});
		} 
	});

	camera.on('read', function(err, timestamp, filename){
                if(filename.search('~') == -1)
                        socket.emit('newImage', currentWebDirectory + filename)
        });

	camera.on("exit", function(timestamp){
	        camera.lock = false;
        	socket.emit('cameraStopped');
	});

	

});

// Remove existing snapshot
if(fs.existsSync(rootDirectory + imageDirectory + 'snapshot.png'))
	fs.unlinkSync(rootDirectory + imageDirectory + 'snapshot.png');

