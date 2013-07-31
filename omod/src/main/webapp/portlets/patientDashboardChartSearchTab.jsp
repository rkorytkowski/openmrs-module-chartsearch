<%@ include file="/WEB-INF/template/include.jsp" %>

<openmrs:htmlInclude file="/dwr/interface/DWRChartSearchService.js"/>
<openmrs:htmlInclude file="/scripts/jquery/dataTables/css/dataTables_jui.css"/>
<openmrs:htmlInclude file="/scripts/jquery/dataTables/js/jquery.dataTables.min.js"/>
<openmrs:htmlInclude file="/moduleResources/chartsearch/js/chartSearch.js"/>
<!-- <openmrs:htmlInclude file="/scripts/jquery-ui/js/openmrsSearch.js" /> -->
<openmrs:htmlInclude file="/moduleResources/chartsearch/css/chartsearch.css"/>

<script type="text/javascript">
	var lastSearch;
	$j(document).ready(function() {
		new ChartSearch("patientChartWidget", false, doObsSearch, doSelectionHandler, 
				[{fieldName:"conceptName", header:" "}, 
				{fieldName:"obsDate", header:" "},
				{fieldName:"highlights", header:" "},
				{fieldName:"obsId", header:" "}],
				{searchLabel: '',
                    searchPlaceholder:'', 
					columnRenderers: [nameColumnRenderer, linkColumnRenderer, null, null], 
					showSearchButton: true,
					columnVisibility: [true, true, false, false],
					searchPhrase:'<request:parameter name="searchPhrase"/>',
					showIncludeVerbose: false
				});
	});
	
	function doSelectionHandler(index, data) {
		DWRChartSearchService.getDetails(data.obsId, renderDetails);
	}
	
	
	//searchHandler
	function doObsSearch(text, resultHandler, getMatchCount, opts) {
		lastSearch = text;
		DWRChartSearchService.findObsAndCount(${model.patient.patientId}, text, opts.includeVoided, null, null, null, null, opts.start, opts.length, getMatchCount, resultHandler);
	}
	
	function nameColumnRenderer(oObj){
		return "<div>"+oObj.aData[0]+"</div><div style='font-style: italic;'>"+oObj.aData[1]+"</div><div>"+oObj.aData[2]+"</div>";
	}
	
	function linkColumnRenderer(oObj){
		return "<div><a href='admin/observations/obs.form?obsId=" + oObj.aData[3] + "&=searchPhrase=" + lastSearch + "'>Link</a></div>";
	}
	
	function renderDetails(data){	
		//todo localization
		jQuery("#chartSearchDetails").html(data);
	}
	
</script>

<openmrs:hasPrivilege privilege="Patient Dashboard - View Chart Search Section">

<div id="chartSearchWrapper">
	<div id="chartSearchResults">
		<b class="boxHeader"><spring:message code="Obs.find"/></b>
		<div class="box">
			<div class="searchWidgetContainer" id="patientChartWidget"></div>			
		</div>
	</div>
	
	<div id="chartSearchDetails"></div>
</div>
	
</openmrs:hasPrivilege>