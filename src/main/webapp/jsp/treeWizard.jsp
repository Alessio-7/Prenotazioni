<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<style>
.tab {
	display: none;
}

.btn {
	margin: 5px;
}

.branchBtn{
	display: block;
    width: 100%;
    border: none;
    background-color: var(--bs-primary);
    padding: 30px;
    font-size: 30px; 
    border-radius: 10px;
	color: white;
}
</style>
<form id="${param.formId}" action="${param.action}"
	onsubmit="${param.onsubmit}">
	<h1>${param.title}</h1>

	${param.tabs}

	<div style="overflow: auto;">
		<div style="float: right;">
			<a class="btn btn-danger" href="${param.returnPage}">Annulla</a>
			<button type="button" class="btn btn-secondary" id="prevBtn"
				onclick="nextPrev(-1)">Precedente</button>
			<button type="button" class="btn btn-primary" id="nextBtn"
				onclick="nextPrev(0)">Avanti</button>
		</div>
	</div>
</form>
<script>
	${param.tabsObject}

	var currentTab = document.getElementById("root");
	showTab();

	function showTab() {
		currentTab.style.display = "block";
		//... and fix the Previous/Next buttons:

		if (currentTab.id == "root") {
			document.getElementById("prevBtn").disabled = true;
		} else {
			document.getElementById("prevBtn").disabled = false;
		}

		if (oTabs[currentTab.id][1].length > 1) {
			document.getElementById("nextBtn").disabled = true;
		} else {
			document.getElementById("nextBtn").disabled = false;

			if (oTabs[currentTab.id][1].length == 0) {
				document.getElementById("nextBtn").innerHTML = "Fine";
			} else {
				document.getElementById("nextBtn").innerHTML = "Avanti";
			}
		}
	}

	function nextPrev(n) {
		currentTab.style.display = "none";

		if (n != -1) {
			if (document.getElementById("nextBtn").innerHTML == "Fine") {
				// ... the form gets submitted:
				//document.getElementById("${param.formId}").submit();
				document.getElementById("${param.formId}").onsubmit();
				return false;
			}
			currentTab = document.getElementById(oTabs[currentTab.id][1][n]);
		} else {
			document.getElementById("nextBtn").innerHTML = "Avanti";
			currentTab = document.getElementById(oTabs[currentTab.id][0]);
		}

		showTab();
	}
</script>