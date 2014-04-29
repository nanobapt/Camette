$( document ).ready(function() {
// connect to node
var socket = io.connect(node_address);

$( "#sendSyncCommand" ).button().click(function( event ) {
        event.preventDefault();
        socket.emit('sendSyncCommand', document.getElementById('syncCommandName').value);
});

socket.on('orderSent', function(){$( "#dialog-message" ).dialog("open");});

$(function() {
	$( "#dialog-message" ).dialog({
		modal: true,
		autoOpen: false,
		buttons: {
			Ok: function() {
				$( this ).dialog( "close" );
			}
		}
	});
});


$( "#syncCommandName" ).combobox();

});

