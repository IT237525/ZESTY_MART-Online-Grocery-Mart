<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Security check - only allow admin access
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || !Boolean.TRUE.equals(sessionObj.getAttribute("isAdmin"))) {
        response.sendRedirect("index.jsp?error=unauthorized");
        return;
    }

  
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Management</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #FFF;
            --panel-color: #FFF;
            --text-color: #000;
            --black-light-color: #707070;
            --border-color: #e6e5e5;
            --toggle-color: #DDD;
            --title-icon-color: #fff;
            --table-bg: #f8fafc;
            --table-header-bg: #1e3a8a;
            --table-hover-bg: #eff6ff;
            --card-bg: #ffffff;
            --shadow-color: rgba(0,0,0,0.1);
        }

        body.dark {
            --primary-color: #3A3B3C;
            --panel-color: #242526;
            --text-color: #CCC;
            --black-light-color: #CCC;
            --border-color: #4D4C4C;
            --toggle-color: #FFF;
            --title-icon-color: #CCC;
            --table-bg: #1f2937;
            --table-header-bg: #1e40af;
            --table-hover-bg: #374151;
            --card-bg: #1f2937;
            --shadow-color: rgba(0,0,0,0.3);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--primary-color);
            color: var(--text-color);
            transition: all 0.3s ease;
            min-height: 100vh;
        }

        body.dark {
            background: linear-gradient(135deg, #1f2937 0%, #111827 100%);
        }

        /* Main content alignment */
        .main-content {
            margin-left: 250px;
            padding: 2rem;
            transition: margin-left 0.5s ease;
        }

        nav.close ~ .main-content {
            margin-left: 73px;
        }

        @media (max-width: 1000px) {
            .main-content {
                margin-left: 73px;
            }
            nav.close ~ .main-content {
                margin-left: 250px;
            }
        }

        @media (max-width: 400px) {
            .main-content {
                margin-left: 0;
            }
            nav.close ~ .main-content {
                margin-left: 73px;
            }
        }

        /* Popup styles */
        .popup {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.6);
            z-index: 1000;
        }

        .popup-content {
            background: var(--card-bg);
            margin: 5% auto;
            padding: 24px;
            width: 90%;
            max-width: 960px;
            border-radius: 12px;
            position: relative;
            max-height: 85vh;
            overflow-y: auto;
            box-shadow: 0 10px 30px var(--shadow-color);
        }

        .popup-content::-webkit-scrollbar,
        .table-container::-webkit-scrollbar {
            display: none;
        }

        .popup-content,
        .table-container {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        .close-btn {
            position: absolute;
            top: 12px;
            right: 12px;
            background: #dc2626;
            color: white;
            border: none;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: transform 0.2s, background 0.2s;
        }

        .close-btn:hover {
            transform: scale(1.1);
            background: #b91c1c;
        }

        /* Table styles */
        .table-container {
            max-height: 60vh;
            overflow-y: auto;
            border-radius: 8px;
        }

        .contact-table th,
        .contact-table td {
            padding: 16px;
            text-align: left;
            word-wrap: break-word;
            max-width: 220px;
        }

        .contact-table th {
            background: var(--table-header-bg);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
        }

        .contact-table tr {
            transition: background 0.2s;
            background: var(--card-bg);
        }

        .contact-table tr:hover {
            background: var(--table-hover-bg);
        }

        .contact-table tr:nth-child(even) {
            background: var(--table-bg);
        }

        .message-cell {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Button styles */
        .btn {
            transition: transform 0.2s, background 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
            background: #1e40af;
        }

        .action-btn {
            padding: 6px 12px;
            font-size: 0.875rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px var(--shadow-color);
            display: inline-flex;
            align-items: center;
            transition: transform 0.2s, background 0.2s, box-shadow 0.2s;
        }

        .action-btn i {
            margin-right: 6px;
            font-size: 0.9rem;
        }

        .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px var(--shadow-color);
        }

        .action-btn.edit {
            background: #2563eb;
            color: white;
        }

        .action-btn.delete {
            background: #dc2626;
            color: white;
        }

        .action-btn.edit:hover {
            background: #1e40af;
        }

        .action-btn.delete:hover {
            background: #b91c1c;
        }

        /* Input and textarea styles */
        .input-field,
        .textarea-field {
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 10px;
            width: 100%;
            background: var(--panel-color);
            color: var(--text-color);
            transition: border-color 0.2s;
        }

        .input-field:focus,
        .textarea-field:focus {
            border-color: #3b82f6;
            outline: none;
        }

        /* Card styles */
        .card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 4px 20px var(--shadow-color);
            padding: 24px;
        }

        /* Heading styles */
        h1, h2 {
            font-weight: 700;
            color: var(--table-header-bg);
        }

        body.dark h1,
        body.dark h2 {
            color: #3b82f6;
        }

        label {
            color: var(--black-light-color);
            font-weight: 500;
        }

        /* Alert styles */
        .alert {
            background: var(--table-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 24px;
            box-shadow: 0 2px 4px var(--shadow-color);
        }

        .alert-success {
            background: #ecfdf5;
            color: #047857;
            border-color: #6ee7b7;
        }

        body.dark .alert-success {
            background: #064e3b;
            color: #6ee7b7;
            border-color: #047857;
        }
    </style>
</head>
<body class="bg-gray-50">
    <%@ include file="adminheader.jsp" %>
    
    <div class="main-content">
        <div class="card">
            <h1 class="text-4xl font-bold mb-8 text-center"><i class="fas fa-envelope mr-3"></i>Admin Contact Management</h1>

            <!-- Search Bar -->
            <div class="mb-6 flex justify-between items-center">
                <div></div> <!-- Empty div for spacing -->
                <form action="admin-contact" method="post" class="flex items-center">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="keyword" class="input-field w-72 mr-2" 
                           placeholder="Search contacts..." value="${searchKeyword}">
                    <button type="submit" class="bg-gray-600 text-white px-5 py-2.5 rounded-lg btn">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
            </div>
            
            <!-- Success Alert -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success">
                    <c:choose>
                        <c:when test="${param.success == 'updated'}">
                            <i class="fas fa-check-circle mr-2"></i> Reply updated successfully!
                        </c:when>
                        <c:when test="${param.success == 'deleted'}">
                            <i class="fas fa-trash-alt mr-2"></i> Contact deleted successfully!
                        </c:when>
                    </c:choose>
                </div>
            </c:if>
            
            <!-- Contacts Table -->
            <div class="table-container">
                <table class="min-w-full rounded-lg contact-table">
                    <thead>
                        <tr>
                            <th class="py-3 px-6">ID</th>
                            <th class="py-3 px-6">Name</th>
                            <th class="py-3 px-6">Phone</th>
                            <th class="py-3 px-6">Subject</th>
                            <th class="py-3 px-6">Message</th>
                            <th class="py-3 px-6">Status</th>
                            <th class="py-3 px-6">Date</th>
                            <th class="py-3 px-6">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${contacts}" var="contact">
                            <tr class="border-b border-gray-200">
                                <td class="py-3 px-6">${contact.contactID}</td>
                                <td class="py-3 px-6">${contact.name}</td>
                                <td class="py-3 px-6">${contact.phone}</td>
                                <td class="py-3 px-6">${contact.subject}</td>
                                <td class="py-3 px-6 message-cell" title="${contact.message}">
                                    ${contact.message}
                                </td>
                                <td class="py-3 px-6">
                                    <span class="inline-block px-3 py-1 rounded-full text-sm font-medium ${empty contact.reply ? 'bg-yellow-500 text-black' : 'bg-green-600 text-white'}">
                                        ${empty contact.reply ? 'Pending' : 'Replied'}
                                    </span>
                                </td>
                                <td class="py-3 px-6">
                                    <small class="text-muted">${contact.createdAt}</small>
                                </td>
                                <td class="py-3 px-6">
                                    <button onclick="openEditPopup(${contact.contactID})" 
                                            class="action-btn edit mr-2">
                                        <i class="fas fa-edit"></i>Edit
                                    </button>
                                    <form action="admin-contact" method="get" style="display:inline;">
								    <input type="hidden" name="action" value="delete">
								    <input type="hidden" name="id" value="${contact.contactID}">
								    <button type="submit" 
								            onclick="return confirm('Are you sure you want to delete this contact?')"
								            class="action-btn delete">
								        <i class="fas fa-trash"></i>Delete
								    </button>
								</form>
								                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty contacts}">
                            <tr>
                                <td colspan="8" class="py-10 text-center">
                                    <i class="fas fa-inbox fa-3x text-gray-400 mb-3"></i>
                                    <h5 class="text-gray-500">No contact messages found</h5>
                                    <c:if test="${not empty searchKeyword}">
                                        <a href="admin-contact" class="bg-blue-600 text-white px-5 py-2.5 rounded-lg btn mt-3 inline-block">
                                            <i class="fas fa-arrow-left mr-2"></i>Back to all contacts
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Edit Popup for each contact -->
        <c:forEach items="${contacts}" var="contact">
            <div id="editPopup${contact.contactID}" class="popup">
                <div class="popup-content">
                    <button class="close-btn" onclick="closeEditPopup(${contact.contactID})">
                        <i class="fas fa-times"></i>
                    </button>
                    <h2 class="text-2xl font-bold mb-6">
                        <i class="fas fa-reply mr-2"></i>Reply to ${contact.name}
                    </h2>
                    <form action="admin-contact" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="contactId" value="${contact.contactID}">
                        <div class="mb-5">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label class="block mb-2">Name</label>
                                    <input type="text" class="input-field" value="${contact.name}" readonly>
                                </div>
                                <div>
                                    <label class="block mb-2">Phone</label>
                                    <input type="text" class="input-field" value="${contact.phone}" readonly>
                                </div>
                            </div>
                        </div>
                        <div class="mb-5">
                            <label class="block mb-2">Subject</label>
                            <input type="text" class="input-field" value="${contact.subject}" readonly>
                        </div>
                        <div class="mb-5">
                            <label class="block mb-2">Original Message</label>
                            <textarea class="textarea-field" rows="4" readonly>${contact.message}</textarea>
                        </div>
                        <div class="mb-5">
                            <label class="block mb-2">Your Reply</label>
                            <textarea name="reply" class="textarea-field" rows="4" required>${contact.reply}</textarea>
                        </div>
                        <div class="flex justify-end">
                            <button type="submit" class="bg-green-600 text-white px-5 py-2.5 rounded-lg btn">
                                <i class="fas fa-paper-plane mr-2"></i>Send Reply
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>
    
    <script>
        function openEditPopup(contactId) {
            document.getElementById('editPopup' + contactId).style.display = 'block';
            setTimeout(() => {
                const textarea = document.querySelector('#editPopup' + contactId + ' .textarea-field:not([readonly])');
                if (textarea) textarea.focus();
            }, 100);
        }

        function closeEditPopup(contactId) {
            document.getElementById('editPopup' + contactId).style.display = 'none';
        }

        // Initialize tooltips
        document.querySelectorAll('[title]').forEach(el => {
            el.addEventListener('mouseover', () => {
                // Tailwind doesn't have built-in tooltips, so we rely on browser-native title attribute
            });
        });
    </script>
</body>
</html>