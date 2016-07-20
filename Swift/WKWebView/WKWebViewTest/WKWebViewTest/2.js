/**
 * @author Administrator
 */
function sayHello(t1,t2) {
    if (document.getElementById('foo').innerHTML == '这是什么鬼'){
        document.getElementById('foo').innerHTML = 'Click me!';
        document.getElementById('foo').style.fontSize = '30px';
    }else{
        document.getElementById('foo').innerHTML = '这是什么鬼';
    }
    alert("I Love You! "+t1+t2);
}
