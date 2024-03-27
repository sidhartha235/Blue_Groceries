$(document).ready(function(){
	const date = new Date();
	const year = date.getFullYear();
	const month = (date.getMonth() + 1).toString().padStart(2, '0');
	const day = date.getDate().toString().padStart(2, '0');
	const dateString = year + "-" + month + "-" + day;
	
	$("#fromDate").attr("value", dateString);
	$("#fromDate").attr("max", dateString);
	
	$("#toDate").attr("value", dateString);
	$("#toDate").attr("max", dateString);
	
	
	$("#options").change(function(){
		let selectedValue = $("#options").val();

		if(selectedValue == "Create Item"){
			$("#itemName").val("");
			$("#itemCategory").val("");
			$("#itemPrice").val("");
			$("#itemUnitQuantity").val("");
			$("#itemStock").val("");
			$("#itemDescription").val("");
			$("#itemImage").val("");
			
			$("#createItemDiv").css("display", "flex");
			$("#create").css("display", "block");
			$("#updateItemsDiv").css("display", "none");
			$("#produceReportDiv").css("display", "none");
		}
		else if(selectedValue == "Update Items"){
			$("#newStock").val("");
			
			$("#createItemDiv").css("display", "none");
			$("#updateItemsDiv").css("display", "flex");
			$("#produceReportDiv").css("display", "none");
		}
		else if(selectedValue == "Produce Report"){
			$("#buyers").val("");
			
			$("#createItemDiv").css("display", "none");
			$("#updateItemsDiv").css("display", "none");
			$("#produceReportDiv").css("display", "flex");
		}
	});
});

/*const date = new Date();
const year = date.getFullYear();
const month = (date.getMonth() + 1).toString().padStart(2, '0');
const day = date.getDate().toString().padStart(2, '0');
const dateString = year + "-" + month + "-" + day;

document.getElementById("fromDate").setAttribute("value", dateString);
document.getElementById("fromDate").setAttribute("max", dateString);

document.getElementById("toDate").setAttribute("value", dateString);
document.getElementById("toDate").setAttribute("max", dateString);*/

/*change = () => {
	
	let dropDownList = document.getElementById("options");
	let selectedValue = dropDownList.options[dropDownList.selectedIndex].value;
	
	if(selectedValue == "Create Item"){
		document.forms["shopkeeperForm1"]["itemName"].value = "";
		document.forms["shopkeeperForm1"]["itemCategory"].value = "";
		document.forms["shopkeeperForm1"]["itemPrice"].value = "";
		document.forms["shopkeeperForm1"]["itemUnitQuantity"].value = "";
		document.forms["shopkeeperForm1"]["itemStock"].value = "";
		document.forms["shopkeeperForm1"]["itemDescription"].value = "";
		document.forms["shopkeeperForm1"]["itemImage"].value = "";
		
		document.getElementById("createItemDiv").style.display = "flex";
		document.getElementById("create").style.display = "block";
		document.getElementById("updateItemsDiv").style.display = "none";
		document.getElementById("produceReportDiv").style.display = "none";
	}
	else if(selectedValue == "Update Items"){
		document.getElementById("createItemDiv").style.display = "none";
		document.getElementById("updateItemsDiv").style.display = "flex";
		document.getElementById("produceReportDiv").style.display = "none";
	}
	else if(selectedValue == "Produce Report"){
		document.getElementById("createItemDiv").style.display = "none";
		document.getElementById("updateItemsDiv").style.display = "none";
		document.getElementById("produceReportDiv").style.display = "flex";
	}
}*/