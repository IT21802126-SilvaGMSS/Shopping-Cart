<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Cart Details</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body style="background-color: #f3f3f3;">

	<%
	/* Checking the user credentials */
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userName == null || password == null) {

		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

	}

	String addS = request.getParameter("add");
	if (addS != null) {

		int add = Integer.parseInt(addS);
		String uid = request.getParameter("uid");
		String pid = request.getParameter("pid");
		int avail = Integer.parseInt(request.getParameter("avail"));
		int cartQty = Integer.parseInt(request.getParameter("qty"));
		CartServiceImpl cart = new CartServiceImpl();

		if (add == 1) {
			//Add Product into the cart
			cartQty += 1;
			if (cartQty <= avail) {
		cart.addProductToCart(uid, pid, 1);
			} else {
		response.sendRedirect("./AddtoCart?pid=" + pid + "&pqty=" + cartQty);
			}
		} else if (add == 0) {
			//Remove Product from the cart
			cart.removeProductFromCart(uid, pid);
		}
	}
	%>



	<jsp:include page="header.jsp" />

	<div class="text-center"
		style="color: black; font-size: 24px; font-weight: bold;">Cart
		Items</div>
	<!-- <script>document.getElementById('mycart').innerHTML='<i data-count="20" class="fa fa-shopping-cart fa-3x icon-white badge" style="background-color:#333;margin:0px;padding:0px; margin-top:5px;"></i>'</script>
 -->
	<!-- Start of Product Items List -->
	<div class="container">

		<table class="table table-hover">
			<thead
				style="background-color: #5F9EA0; color: white; font-size: 16px; font-weight: bold;">
				<tr>
					<th style="color: black; padding: 15px;">Picture</th>
        			<th style="color: black; padding: 15px;">Products</th>
        			<th style="color: black; padding: 15px;">Price</th>
        			<th style="color: black; padding: 15px;">Quantity</th>
        			<th style="color: black; padding: 15px;">Add</th>
        			<th style="color: black; padding: 15px;">Remove</th>
        			<th style="color: black; padding: 15px;">Amount</th>
				</tr>
			</thead>
			<tbody
				style="background-color: white; font-size: 15px; font-weight: bold;">



				<%
				CartServiceImpl cart = new CartServiceImpl();
				List<CartBean> cartItems = new ArrayList<CartBean>();
				cartItems = cart.getAllCartItems(userName);
				double totAmount = 0;
				for (CartBean item : cartItems) {

					String prodId = item.getProdId();

					int prodQuantity = item.getQuantity();

					ProductBean product = new ProductServiceImpl().getProductDetails(prodId);

					double currAmount = product.getProdPrice() * prodQuantity;

					totAmount += currAmount;

					if (prodQuantity > 0) {
				%>

				<tr>
					<td><img src="./ShowImage?pid=<%=product.getProdId()%>"
        style="width: 100px; height: 100px;"></td>
					<td><%=product.getProdName()%></td>
					<td>Rs. <%=String.format("%.2f", product.getProdPrice())%></td>
					<td><form method="post" action="./UpdateToCart">
							<input type="number" name="pqty" value="<%=prodQuantity%>"
								style="max-width: 70px;" min="0"> <input type="hidden"
								name="pid" value="<%=product.getProdId()%>"> <input
								type="submit" name="Update" value="Update"
								style="max-width: 80px;">
						</form></td>
					<td><a href="cartDetails.jsp?add=1&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQuantity%>"><i class="fa fa-plus" style="color: red; "></i></a></td>
					<td><a href="cartDetails.jsp?add=0&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQuantity%>"><i class="fa fa-minus" style="color: red;"></i></a></td>

					<td><%= "Rs. " + String.format("%.2f", currAmount) %></td>


				</tr>

				<%
				}
				}
				%>

				<tr style="background-color: white; color: black;">
					<td colspan="6" style="text-align: right; color: red;">Total Amount to
						Pay</td>
					<td style="color: black;"><%= "Rs. " + String.format("%.2f", totAmount) %></td>

				</tr>
				<%
				if (totAmount != 0) {
				%>
				<tr style="background-color: white; color: white;">
					<td colspan="4" style="text-align: center;">
					<td><form method="post">
							<button formaction="userHome.jsp"
								style="background-color: #0047AB; color: white;">Cancel</button>
						</form></td>
					<td colspan="2" align="center"><form method="post">
							<button style="background-color: orange; color: white;"
								formaction="payment.jsp?amount=<%=totAmount%>">Pay Now</button>
						</form></td>

				</tr>
				<%
				}
				%>
			</tbody>
		</table>
	</div>
	<!-- ENd of Product Items List -->


	<%@ include file="footer.html"%>

</body>
</html>