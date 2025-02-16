<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="security"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<div class="d-flex align-items-center mb-3">
	<div>
		<ul class="breadcrumb">
			<c:url value="/franchise/franchisePosCancleHistory" var="franchisePosCancleHistoryUrl" />
			<li class="breadcrumb-item"><a href="${franchisePosCancleHistoryUrl }">포스기 내역</a></li>
			<li class="breadcrumb-item active">포스기 환불내역</li>
		</ul>
		<h1 class="page-header mb-0">포스기 환불내역</h1>
	</div>
</div>
<div class="card p-3 mb-5">
<div class="tab-content p-4">
<div class="table-responsive">
	<div class="input-group">
		<input type="text" class="form-control" id="datepicker"
			placeholder="날짜선택"> <label class="input-group-text"
			for="datepicker"> <i class="fa fa-calendar"></i>
		</label>
	</div>
	<table class="table" id="possetldetail">
		<thead>
			<tr>
				<th class="order-border">결제번호</th>
				<th class="order-border">상품정보</th>
				<th class="order-border">결제날짜</th>
				<th class="order-border">환불날짜</th>
				<th class="order-border">결제가격</th>
				<th class="order-border">결제수량</th>
				<th class="order-border-top">
				<span>상태</span>
				</th>
			</tr>
		</thead>
		<tbody class="bodycontent">
			<c:forEach items="${posCancleList }" var="posCancle">
				<tr class="body">
					<td class="order-border">${posCancle.franprodsetl.franprodSetlNo }</td>
					<td class="franprod text-start order-border"> <c:forEach items="${posCancle.franprod}" var="franprod">
						<div class="d-flex mb-1" style="align-items: center;">
							<img src="${franprod.franprodImage }" width="80px"
								height="80px" />
							<p class="px-2 mb-0 align-middle">${franprod.franprodNm }</p>
						</div>
						</c:forEach></td>
					<td class="date order-border"><fmt:parseDate
							value="${posCancle.franprodsetl.franprodSetlDe }"
							pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
						<fmt:formatDate pattern="yyyy-MM-dd HH:mm"
							value="${ parsedDateTime }" /></td>
					<td class="date order-border"><fmt:parseDate
							value="${posCancle.cancle.cancleDe }"
							pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime1" type="both" />
						<fmt:formatDate pattern="yyyy-MM-dd HH:mm"
							value="${ parsedDateTime1 }" /></td>
					<fmt:formatNumber value="${posCancle.franprodsetl.franchiseSetlPc  }" pattern="#,###" var="franchiseSetlPc" />
					<td class="text-end order-border">${franchiseSetlPc }원</td>
					<td class="order-border" style="text-align: center;">${posCancle.fsmDtlsQy }</td>
					<td class="align-middle">
					<span class="badge text-success bg-primary bg-opacity-15 px-2 py-6px rounded fs-12px d-inline-flex align-items-center">
                        <i class="fa fa-circle fs-9px fa-fw me-5px"></i>환불완료
                    </span></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>
</div>
</div>

<script>
  $('#datepicker').datepicker({
    autoclose: true,
    format: "yyyy-mm-dd",
    language : "ko"

  }).on("changeDate", function(e) {
      //picker_event는 "이벤트명" 이런 식으로 적는다.
      //하고 싶은 행동
      console.log(e.target.value.toString());
      var date = e.target.value.toString();

      var body = $(".bodycontent");



      console.log(date);
      $.ajax({
    	 url: `${cPath}/franchise/posCancleDate`,
    	 data :{ "date" : date},
    	 type : "POST",
    	 success:(data)=>{
				console.log(data);
// 				console.log(data[1].franprodsetl.franprodSetlDe);
// 				console.log(data[0].franprod.length);
				body.empty();

				if(data.length ===0){
					var tdTags =`
					<td>상품 정보가 없습니다.</td>
					`;
					body.append(tdTags);
				}else{



				for(var i=0; i<data.length; i++){
					let bodyName = "body"+i;
					console.log(bodyName);
					var setlPc = data[i].franprodsetl.franchiseSetlPc;
					pcComma = setlPc.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
					var trTags = `
					<tr class="\${bodyName}">
						<td class="order-border">\${data[i].franprodsetl.franprodSetlNo }</td>
						<td class="franprod text-start order-border"></td>
						<td class="date order-border">\${data[i].franprodsetl.franprodSetlDe }</td>
						<td class="date order-border">\${data[i].cancle.cancleDe }</td>
						<td class="text-end order-border">\${pcComma }원</td>
						<td class="order-border">\${data[i].fsmDtlsQy }</td>
						<td class="align-middle">
						<span class="badge text-success bg-primary bg-opacity-15 px-2 py-6px rounded fs-12px d-inline-flex align-items-center">
	                        <i class="fa fa-circle fs-9px fa-fw me-5px"></i>환불완료
	                    </span></td>
					</tr>
					`;

					body.append(trTags);
					 var prodbody = $(`.body`+i).find(".franprod");
					 console.log(prodbody);

					for(var j=0; j<data[i].franprod.length; j++){
						var prodTrTags = `
							<div class="d-flex mb-1" style="align-items: center;">
							<img src="\${data[i].franprod[j].franprodImage }" width="80px"
							height="80px" />
							<p class="px-2 mb-0 align-middle">\${data[i].franprod[j].franprodNm }</p>
							</div>
						`;
						prodbody.append(prodTrTags);
					}

				}
				}
			},
			error: (jqXHR, textStatus, errorThrown)=>{
						console.log("textStatus", textStatus);
			}
		});
  });
</script>

<script src="${cPath }/resources/js/app/franchise/franPosHistory.js"></script>