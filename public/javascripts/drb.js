function progressPercent(bar, percentage) {
  document.getElementById(bar).style.width =  parseInt(percentage*2)+"px";
  document.getElementById(bar).innerHTML= "<div align='center'>"+percentage+"%</div>"
}

function statusUpdate(status){
  document.getElementById("status").innerHTML = "Status: " +  status;
}