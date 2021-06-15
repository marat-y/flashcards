$(document).ready(function(){
    setInterval(updateTimePassed,1000);
});

updateTimePassed = function () {
    old_value = parseInt($('#test_response_time').val());
    $('#test_response_time').val(old_value + 1);
};