function sayHello(t1,t2) {
    if (document.getElementById('foo').innerHTML == 'Hi there'){
        document.getElementById('foo').innerHTML = 'Click me!';
        
    }else{
        document.getElementById('foo').innerHTML = 'Hi there';
    }
    alert("I Love You"+t1+t2);
}
