$(document).ready(function(){
	$("#displayCount").change(function(){
		let user = test_input($("#user").val());
		let ID = test_input($("#ID").val());
		let displayCount = test_input($("#displayCount").val());
		let page = 1;
		
		$("#buyerForm").attr("action", "Buyer.jsp?user=" + user + "&ID=" + ID + "&page=" + page + "&displayCount=" + displayCount);
	});
	
	$("#searchForm").submit(function(event){
		//event.preventDefault();
		
		let images = $(".image");
		console.log(images);
		
		images.each(function(index, element){
			let itemID = $(element).attr("name");
			console.log(itemID);
			
			$.get("fetchImage?itemID=" + itemID + "&timestamp=" + new Date().getTime(), function(data, status){
				if(status == "success"){
					$(element).attr("src", "data:image/jpeg;base64," + data);
				}
				else{
					console.error("Request failed with status code: " + status);
				}
			});
		});
	});
});

function sleep(milliseconds) {
    return new Promise(resolve => setTimeout(resolve, milliseconds));
}


/*updateFormAction = () => {
    let user = document.getElementById("user").value;
    let ID = document.getElementById("ID").value;
    let displayCount = document.getElementById("displayCount").value;
    let page = 1;

    let newAction = "Buyer.jsp?user=" + user + "&ID=" + ID + "&page=" + page + "&displayCount=" + displayCount;
    document.forms.buyerForm.action = newAction;
}*/