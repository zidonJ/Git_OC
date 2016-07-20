/**
 * @author Administrator
 */
function sayHello(t1,t2) {
    if (document.getElementById('foo').innerHTML == 'Hi there'){
        document.getElementById('foo').innerHTML = 'Click me!';
        document.getElementById('foo').style.fontSize = '200px';
    }else{
        document.getElementById('foo').innerHTML = 'Hi there';
    }
    alert("I Love You! "+t1+t2);
}
	
//不能再js文件中写：<script>标记，这个标记是html标记!	