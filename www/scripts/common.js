// To be implemented

$( document ).ready(function() {

$( "#synchroniseCamettes" ).button().click(function( event ) {
        event.preventDefault();
        window.location.href = '/server/sync.html';
});

$( "#backMain" ).button().click(function( event ) {
        event.preventDefault();
        window.location.href = '/index.html';
});

$( "#resetCamette" ).button().click(function( event ) {
        event.preventDefault();
        socket.emit('resetCamette');
});

});
