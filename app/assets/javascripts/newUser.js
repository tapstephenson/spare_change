$(document).ready(function(){
  eventBundler();
})

function eventBundler(){

  spareChangeRegistration();
}

function spareChangeRegistration(){

  $("main").on('submit', '#spareChangeRegistration', function(event){
    debugger
    var data = $("#spareChangeRegistration :input").serializeArray();
    console.log(data);
  })
}
