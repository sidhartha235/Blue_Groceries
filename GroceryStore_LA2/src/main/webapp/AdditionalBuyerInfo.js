$(document).ready(function(){
	$("#buyerForm").submit(function(event){
		let mobile = test_input($("#mobile").val());
		let pincode = test_input($("#pincode").val());
		
		if(!/^[1-9][0-9]{9}$/.test(mobile)){
			alert("Mobile number should contain digits only!");
			event.preventDefault();
		}
		else if(!/^[0-9]{6}$/.test(pincode)){
			alert("Pin code should contain digits only!");
			event.preventDefault();
		}
	});
});

test_input = (value) => {
	value = value.trim();
	return value;
}