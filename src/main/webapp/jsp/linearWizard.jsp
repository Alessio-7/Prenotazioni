<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<style>
/* Mark input boxes that gets an error on validation: */
input.invalid {
	background-color: #ffdddd;
}

/* Hide all steps by default: */
.tab {
	display: none;
}

/* Make circles that indicate the steps of the form: */
.step {
	height: 15px;
	width: 15px;
	margin: 0 2px;
	background-color: #bbbbbb;
	border: none;
	border-radius: 50%;
	display: inline-block;
	opacity: 0.5;
}

.step.active {
	opacity: 1;
}

.step.finish {
	background-color: var(--bs-primary);;
}

.btn {
	margin: 5px;
}
</style>
<form id="${param.formId}" action="${param.action}" onsubmit="${param.onsubmit}">
	<h1>${param.title}</h1>

	${param.tabs}

	<div style="overflow: auto;">
		<div style="float: right;">
			<a class="btn btn-danger" href="${param.returnPage}">Annulla</a>
			<button type="button" class="btn btn-secondary" id="prevBtn"
				onclick="nextPrev(-1)">Precedente</button>
			<button type="button" class="btn btn-primary" id="nextBtn"
				onclick="nextPrev(1)">Avanti</button>
		</div>
	</div>
	<!-- Circles which indicates the steps of the form: -->
	<div style="text-align: center; margin-top: 40px;">
		<%
		int n = request.getParameter("tabs").split("<div class=\"tab\">").length-1;
		for (int i = 0; i < n; i++) {
		%>
		<span class="step"></span>
		<%
		}
		%>
	</div>
</form>
<script>
	var currentTab = 0; // Current tab is set to be the first tab (0)
	showTab(currentTab); // Display the current tab

	function showTab(n) {
		// This function will display the specified tab of the form...
		var x = document.getElementsByClassName("tab");
		x[n].style.display = "block";
		//... and fix the Previous/Next buttons:
		if (n == 0) {
			document.getElementById("prevBtn").disabled = true;
		} else {
			document.getElementById("prevBtn").disabled = false;
		}
		if (n == (x.length - 1)) {
			document.getElementById("nextBtn").innerHTML = "Fine";
		} else {
			document.getElementById("nextBtn").innerHTML = "Avanti";
		}
		//... and run a function that will display the correct step indicator:
		fixStepIndicator(n)
	}

	function nextPrev(n) {
		// This function will figure out which tab to display
		var x = document.getElementsByClassName("tab");
		// Hide the current tab:
		x[currentTab].style.display = "none";
		// Increase or decrease the current tab by 1:
		currentTab = currentTab + n;
		// if you have reached the end of the form...
		if (currentTab >= x.length) {
			// ... the form gets submitted:
				document.getElementById("nextBtn").type = "submit";
			return false;
		}
		// Otherwise, display the correct tab:
		showTab(currentTab);
	}

	function validateForm() {
		// This function deals with validation of the form fields
		var x, y, i, valid = true;
		x = document.getElementsByClassName("tab");
		y = x[currentTab].getElementsByTagName("input");
		// A loop that checks every input field in the current tab:
		for (i = 0; i < y.length; i++) {
			// If a field is empty...
			if (y[i].value == "") {
				// add an "invalid" class to the field:
				y[i].className += " invalid";
				// and set the current valid status to false
				valid = false;
			}
		}
		// If the valid status is true, mark the step as finished and valid:
		if (valid) {
			document.getElementsByClassName("step")[currentTab].className += " finish";
		}
		return valid; // return the valid status
	}

	function fixStepIndicator(n) {
		// This function removes the "active" class of all steps...
		var i, x = document.getElementsByClassName("step");
		for (i = 0; i < x.length; i++) {
			x[i].className = x[i].className.replace(" active", "");
			x[i].className = x[i].className.replace(" finish", "");
			if(i < n){
				x[i].className += " finish";
			}
		}
		//... and adds the "active" class on the current step:
		x[n].className += " active";
	}
</script>