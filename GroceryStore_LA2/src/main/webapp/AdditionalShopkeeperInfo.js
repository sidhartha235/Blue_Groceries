$(document).ready(function(){
	$("#shopkeeperForm").submit(function(event){
		let mobile = test_input($("#mobile").val());
		
		if(!/^[1-9][0-9]{9}$/.test(mobile)){
			alert("Mobile number should contain digits only!");
			event.preventDefault();
		}
	});
});

test_input = (value) => {
	value = value.trim();
	return value;
}