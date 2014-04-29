// connect to node
var socket = io.connect(node_address);

$( document ).ready(function() {

	var servoPosX = 90;
	var servoPosY = 90;

	$( "#servo_y_pos" ).slider({
		orientation: "vertical",
		range: "min",
		min: 0,
		max: 180,
		value: 90,
		slide: function( event, ui ) {
			$( "#YValue" ).val( ui.value );
			socket.emit('controlServoY', ui.value);
			servoPosY = ui.value;
		}
	});

	 $( "#servo_x_pos" ).slider({
		orientation: "horizontal",
		range: "min",
		min: 0,
		max: 180,
		value: 90,
		slide: function( event, ui ) {
			$( "#XValue" ).val( ui.value );
			socket.emit('controlServoX', ui.value);
			servoPosX = ui.value;
		}
	});

	$( "#setNewPos" ).button().click(function( event ){
		socket.emit('setNewServoPos', {x: servoPosX, y: servoPosY});
	});

	$( "#resetAllPos" ).button().click(function( event ) {
		socket.emit('resetAllServoPos');
	});

	// If position have been set, notify it
	socket.on('servoPositionSet', function(){$( "#positionSetDialog" ).dialog("open");});

        $( "#positionSetDialog" ).dialog({
                modal: true,
                autoOpen: false,
                buttons: {
                        Ok: function() {
                                $( this ).dialog( "close" );
                        }
                }
        });

	// If positions have been resetted, notify it
	socket.on('servoPositionResetted', function(){$( "#resetPositionDialog" ).dialog("open");});

        $( "#resetPositionDialog" ).dialog({
                modal: true,
                autoOpen: false,
                buttons: {
                        Ok: function() {
                                $( this ).dialog( "close" );
                        }
                }
        });


	$( "#YValue" ).val( $( "#servo_y_pos" ).slider( "value" ) );
	$( "#XValue" ).val( $( "#servo_x_pos" ).slider( "value" ) );

	socket.emit('controlServoY', 90);
	socket.emit('controlServoX', 90);

});
