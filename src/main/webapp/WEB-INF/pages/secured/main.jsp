<%@ page contentType="text/html; charset=UTF-8" session="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	
<!DOCTYPE html>
<html>
<jsp:include page="../include/head.jsp" />
<body class="skin-blue">
	<!-- header logo: style can be found in header.less -->
	<jsp:include page="../include/header.jsp" />
	<div class="wrapper row-offcanvas row-offcanvas-left">
		<!-- Left side column. contains the logo and sidebar -->
		<jsp:include page="../include/leftmenu.jsp" />

		<!-- Right side column. Contains the navbar and content of the page -->
		<aside class="right-side">
			<!-- Content Header (Page header) -->
			<section class="content-header">
				<h1>Kontrol Paneli</h1>
				<ol class="breadcrumb">
					<li><a href="${pageContext.request.contextPath}/indexPage"><i
							class="fa fa-dashboard"></i> Ana Sayfa</a></li>
					<li><a href="${pageContext.request.contextPath}/secured/main">Kontrol
							Paneli</a></li>
				</ol>
			</section>

			<!-- Main content -->
			<section class="content">
				<sec:authorize access="hasRole('ROLE_ADMIN')">
					<jsp:include page="admin.jsp" />
				</sec:authorize>
				<sec:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_USER')">
					<jsp:include page="user.jsp" />
				</sec:authorize>
			</section>
			<!-- /.content -->
		</aside>
		<!-- /.right-side -->
	</div>
	<!-- ./wrapper -->
	<jsp:include page="../include/footer.jsp" />

	<script type="text/javascript">
		$(function() {
			$("#example1").dataTable();
			$('#users').dataTable({
				"bPaginate" : true,
				"bLengthChange" : false,
				"bFilter" : false,
				"bSort" : true,
				"bInfo" : true,
				"bAutoWidth" : false
			});
		});
	</script>


	<!-- FLOT CHARTS -->
	<script
		src="<c:url value="/resources/js/plugins/flot/jquery.flot.min.js" />"
		type="text/javascript"></script>
	<!-- FLOT RESIZE PLUGIN - allows the chart to redraw when the window is resized -->
	<script
		src="<c:url value="/resources/js/plugins/flot/jquery.flot.resize.min.js" />"
		type="text/javascript"></script>
	<!-- FLOT PIE PLUGIN - also used to draw donut charts -->
	<script
		src="<c:url value="/resources/js/plugins/flot/jquery.flot.pie.min.js" />"
		type="text/javascript"></script>
	<!-- FLOT CATEGORIES PLUGIN - Used to draw bar charts -->
	<script
		src="<c:url value="/resources/js/plugins/flot/jquery.flot.categories.min.js" />"
		type="text/javascript"></script>

	<script
		src="<c:url value="/resources/js/plugins/timepicker/bootstrap-timepicker.min.js" />"
		type="text/javascript"></script>

	<script type="text/javascript">
		$(function() {

			//Date range picker with time picker
			$('#bartime').daterangepicker({
				timePicker : true,
				timePickerIncrement : 30,
				format : 'MM/DD/YYYY h:mm A',
				startDate: '12/23/2013 11:12:32',
			    endDate: '12/31/2013 11:12:32'
			});
			$("#bartime").val("${defaultStartTime} - ${defaultEndTime}");
			//Date range picker with time picker
			$('#donuttime').daterangepicker({
				timePicker : true,
				timePickerIncrement : 30,
				format : 'MM/DD/YYYY h:mm A',
				startDate: '12/23/2013 11:12:32',
			    endDate: '12/31/2013 11:12:32'
			});
			$("#donuttime").val("${defaultStartTime} - ${defaultEndTime}");
		});
	</script>

	<!-- Page script -->
	<script type="text/javascript">
		$(function() {

			/*
			 * BAR CHART
			 * ---------
			 */
			Morris.Bar({
				element : 'bar-chart',
				
				data: [
						<c:forEach items="${monthlyActivityMap}" var="monthlyActivityEntry">
							{
								<fmt:formatDate value="${monthlyActivityEntry.key}" var="dateString" pattern="MMM" />
								y : '${dateString}',
									<c:forEach items="${monthlyActivityEntry.value}" var="monthlyEntry">
								    	<c:if test="${not empty monthlyEntry}">
								    		${monthlyEntry.key} : ${monthlyEntry.value},
										</c:if>
									</c:forEach>
							},
						</c:forEach>
	                 ],
				xkey : 'y',
				ykeys : [ <c:forEach items="${monthlyActivityMap}" var="monthlyActivityEntry">
							<c:forEach items="${monthlyActivityEntry.value}" var="monthlyEntry">
								<c:if test="${not empty monthlyEntry}">
									'${monthlyEntry.key}',
								</c:if>
						    </c:forEach>
						  </c:forEach> 
				        ],
				labels : [ 
						<c:forEach items="${monthlyActivityMap}" var="monthlyActivityEntry">
							<c:forEach items="${monthlyActivityEntry.value}" var="monthlyEntry">
								<c:if test="${not empty monthlyEntry}">
								'${monthlyEntry.key.label}',
								</c:if>
							</c:forEach>
						</c:forEach> 
				  		  ]
			});

			/* END BAR CHART */

			/*
			 * DONUT CHART
			 * -----------
			 */
            var donut = new Morris.Donut({
                 element: 'donut-chart',
                 resize: true,
                 data: [
            		<c:forEach items="${activityMap}" var="entry">
            			{
            				label : "${entry.key.label}",
            				value :  ${entry.value}
            			},			    
            		</c:forEach>
                 ],
                 formatter:function(value,data)
                 {return value + '%';},
                 hideHover: 'auto'
             });
			/*
			 * END DONUT CHART
			 */

		});
	</script>

</body>
</html>