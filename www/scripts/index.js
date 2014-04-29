// connect to node
var socket = io.connect(node_address);

$( document ).ready(function() {
socket.emit('raspimjeg', 'stop');

$( "#accordion" ).accordion({ active: false, collapsible: true });
$( "#accordion" ).accordion({
        activate: function( event, ui ){
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


$( "#createProject" ).button().click(function( event ) {
        event.preventDefault();
        socket.emit('createProject', document.getElementById('projectName').value);
});

$( "#continueProject" ).button().click(function( event ) {
        event.preventDefault();
        socket.emit('continueProject', document.getElementById('projectName').value);
});

$( "#seeProjects" ).button().click(function( event ) {
        event.preventDefault();
	window.location.href = '/timelapse_movies';
});

$( "#synchroniseCamettes" ).button().click(function( event ) {
        event.preventDefault();
        window.location.href = '/server/sync.html';
});


$( "#seeSnapshots" ).button().click(function( event ) {
        event.preventDefault();
        window.location.href = '/snapshots';
});

$( "#recordedSounds" ).button().click(function( event ) {
        event.preventDefault();
        window.location.href = '/recordedsounds';
});

socket.on('projectCreated', function(){window.location.href = 'timelapse.html';});
socket.on('projectAlreadyExist', function(){alert('Project already exist, please choose an other name.');});
socket.on('projectDoesntExist', function(){alert('Project Doesnt exist, please choose an other name.');});

});
