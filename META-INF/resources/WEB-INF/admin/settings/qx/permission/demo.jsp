<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />


    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <!--  PAGINATION plugin jquery/bs_pagination-master/css/-->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <style>
        .dragbox {
            display: inline-flex;
            width: 100px;
            height: 100px;
            background: slateblue;
            position: relative;
            margin: 10px;
            flex: 1;
            color: #fff;
            justify-content: center;
            align-items: center;
            vertical-align: top;
            /* transition: .15s; */
        }

        .dragbox:empty::after {
            content: 'drag me';
        }

        .flex-box {
            display: flex;
        }

        [draggable=true][dragging] {
            box-shadow: 5px 5px 15px rgba(0, 0, 0, .2);
        }

        .dropbox{
            position: relative;
            height: 500px;
            border: 10px solid #f1f1f1;
        }

        [allowdrop][over]{
            border-color: wheat;
        }

        .dropbox .dragbox{
            position: absolute;
            margin: 0;
            left: 0;
            top: 0;
        }
        .droplist{
            width: 500px;
            border: 10px solid #f1f1f1;
            padding: 10px;
        }
        .dragitem{
            display: flex;
            align-items: center;
            list-style: none;
            padding: 10px;
            height: 40px;
            color: #fff;
            background: slateblue;
        }
        .dragitem:not(:first-child){
            margin-top: 10px;
        }
        .fab{
            position: fixed;
            right: 30px;
            top: 30px;
            font-size: 30px;
            background: royalblue;
            border: 0;
            padding: 10px 20px;
            color: #fff;
            cursor: pointer;
            outline: 0;
            box-shadow: 0 0 15px rgba(0, 0, 0, .2);
            transition: .2s;
        }
        .fab:hover{
            background: rgb(51, 95, 228);
        }
        .fab:hover:active{
            transform: translateY(3px);
        }
        .fab:disabled{
            background: mediumseagreen;
        }
        .fab:disabled::before{
            content:'√ '
        }
    </style>
</head>

<body>
<h2>draggable polyfill</h2>
<h4>Draggable Div</h4>
<div class="dragbox" draggable="true"></div>
<h4>Img</h4>
<img class="dragbox" src="avator.png" alt="xboxyan">
<h4>Response</h4>
<div class="flex-box">
    <div class="dragbox" draggable="true"></div>
    <div class="dragbox" draggable="true"></div>
    <div class="dragbox" draggable="true" style="flex: 2;"></div>
</div>
<h4>Dynamic add</h4>
<button id="button01">add one</button>
<button id="button02">add img</button>
<button id="button03">add more</button>
<div id="contents"></div>
<h4>Drag and save position</h4>
<div class="dropbox" allowdrop id="dropbox">
    <div class="dragbox" axis="X" draggable="true" id="dragbox01">axis="X"</div>
    <div class="dragbox" axis="Y" draggable="true" id="dragbox02" style="transform: translate3d(200px,150px,0);">axis="Y"</div>
    <div class="dragbox" draggable="true" id="dragbox03" style="width:200px;transform: translate3d(300px,350px,0);"></div>
</div>
<h4>Drag and sort</h4>
<ul class="droplist" allowdrop id="droplist">
    <c:forEach items="${requestScope.menus}" var="menu" >
        <li class="dragitem" draggable="true" value="${menu.id}">${menu.name}</li>
    </c:forEach>
</ul>
<button class="fab" id="importBtn">import draggable-polyfill</button>
<!-- <script src="../lib/draggable-polyfill.js"></script> -->
<script>
    button01.onclick = function () {
        var dragbox = document.createElement('div');
        dragbox.className = 'dragbox';
        dragbox.draggable = true;
        contents.append(dragbox);
    }
    button02.onclick = function () {
        var img = new Image();
        img.src = './avator.png';
        img.className = 'dragbox';
        contents.append(img);
    }
    button03.onclick = function () {
        var dragcontent = document.createElement('div');
        dragcontent.className = 'flex-box';
        dragcontent.innerHTML = '<div class="dragbox" draggable="true"></div><div class="dragbox" draggable="true"></div><div class="dragbox" draggable="true" style="flex: 2;"></div>'
        contents.append(dragcontent);
    }

    //drag
    document.querySelectorAll('#dropbox>.dragbox').forEach(function(el){
        el.addEventListener('dragstart',function(ev){
            //ev.dataTransfer.effectAllowed = 'move';
            ev.dataTransfer.setData('dragData', JSON.stringify({
                id:this.id,
                offsetX:ev.offsetX,
                offsetY:ev.offsetY,
            }));
        },true)
    })
    dropbox.ondragover = function (ev) {
        ev.preventDefault();
    }
    dropbox.ondrop = function (ev) {
        var dragData = JSON.parse(ev.dataTransfer.getData('dragData'));
        if(dragData.id){
            var dragbox = document.getElementById(dragData.id);
            var rect = this.getBoundingClientRect();
            if(dragbox.dragData){
                dragbox.style.transform = 'translate3d('+~~(dragbox.dragData.left-rect.left-10)+'px,'+~~(dragbox.dragData.top-rect.top-10)+'px,0)'
            }else{
                dragbox.style.transform = 'translate3d('+~~(ev.clientX-rect.left-dragData.offsetX-10)+'px,'+~~(ev.clientY-rect.top-dragData.offsetY-10)+'px,0)'
            }
        }
    }

    //sort
    var currentDragItem = null;
    var offsetY = 0;
    document.querySelectorAll('#droplist>.dragitem').forEach(function(el){
        el.addEventListener('dragstart',function(ev){
            ev.dataTransfer.setData('text', '');
            offsetY = ev.offsetY;
            currentDragItem = this;
        },true)
        el.addEventListener('dragend',function(ev){
            currentDragItem = null;
        })
    })
    droplist.ondragover = function (ev) {
        ev.preventDefault();
        if(!currentDragItem){ return }
        var dragitem = ev.target.closest('.dragitem');
        if(dragitem){
            if(ev.offsetY>offsetY){
                dragitem.after(currentDragItem);
            }else{
                dragitem.before(currentDragItem);
            }
        }
    }
    //import
    importBtn.onclick = function(){
        var script = document.createElement('SCRIPT');
        script.src="jquery/draggable-polyfill.js";
        document.body.appendChild(script);
        this.disabled = true;
    }

</script>
</body>

</html>