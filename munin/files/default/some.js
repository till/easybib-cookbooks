var clientPC = navigator.userAgent.toLowerCase(); // Get client info
var is_gecko = ((clientPC.indexOf('gecko')!=-1) && (clientPC.indexOf('spoofer')==-1)
                && (clientPC.indexOf('khtml') == -1) && (clientPC.indexOf('netscape/7.0')==-1));
var is_safari = ((clientPC.indexOf('AppleWebKit')!=-1) && (clientPC.indexOf('spoofer')==-1));
var is_khtml = (navigator.vendor == 'KDE' || ( document.childNodes && !document.all && !navigator.taintEnabled ));
if (clientPC.indexOf('opera') != -1) {
	var is_opera = true;
	var is_opera_preseven = (window.opera && !document.childNodes);
	var is_opera_seven = (window.opera && document.childNodes);
}


function tabbedcategories() {
	var catform = document.getElementById('categories');
	var sec_0='';
	if (!catform || !document.createElement)
		return;
	if (catform.nodeName.toLowerCase() == 'a')
		return; // Occasional IE problem
	catform.className = catform.className + 'jscats';
	var sections = new Array();
	children = catform.childNodes;
	var secin = 0;
var curhash='' + document.location.hash + '';
curhash=curhash.replace(/\#catsection\-/,'');
	if (curhash == '' ) curhash=0;
	for (i = 0; i < children.length; i++) {
		if (children[i].nodeName.toLowerCase() == 'fieldset') {
			function g_seci() {for (ii=0;ii<children[i].childNodes.length;ii++){
			    if (children[i].childNodes[ii].className=="graphbox") return children[i].childNodes[ii].id;
			    }			
			}	
			seci=g_seci();
			if (sec_0=='') {sec_0=seci;}
			children[i].id = seci;
			children[i].className = 'catsection';
			if (is_opera || is_khtml)
				children[i].className = 'catsection operacatsection';
			legends = children[i].getElementsByTagName('legend');
			sections[secin] = new Object();
			legends[0].className = 'mainLegend';
			if (legends[0] && legends[0].firstChild.nodeValue)
				sections[secin].text = legends[0].firstChild.nodeValue;
			else
				sections[secin].text = '# ' + seci;
			sections[secin].secid = '' + children[i].seci;
			secin++;
			if (sections.length != 1) {
    				children[i].style.display = 'none';
				    }
		}
	}
	curhash='' + document.location.hash.replace(/^#/,'');
	if (curhash == '' ) curhash=sec_0;
	var toc = document.createElement('ul');
	toc.id = 'cattoc';
	toc.selectedid = curhash;
	for (i = 0; i < sections.length; i++) {
		var li = document.createElement('li');
		var a = document.createElement('a');
		a.href = '#' + sections[i].text;
		a.onmousedown = a.onclick = uncoversection;
		a.appendChild(document.createTextNode(sections[i].text));
		a.secid = '' + sections[i].text;
		li.appendChild(a);
		toc.appendChild(li);
		if (sections[i].text == curhash){
			li.className = 'selected';
			}
	}
	catform.parentNode.insertBefore(toc, catform.parentNode.childNodes[0]);
	var oldsec = document.getElementById(sec_0);
	oldsec.style.display = 'none';
	var newsec = document.getElementById(curhash);
	newsec.style.display = 'block';
	onimage(document.getElementById(curhash));
	selectedid=curhash;
}

function uncoversection() {
	oldsecid = this.parentNode.parentNode.selectedid;
	newsec = document.getElementById(this.secid);
	if (oldsecid != this.secid) {
		document.location.hash=this.secid;
		ul = document.getElementById('cattoc');
		document.getElementById(oldsecid).style.display = 'none';
		newsec.style.display = 'block';
		ul.selectedid = this.secid;
		lis = ul.getElementsByTagName('li');
		for (i = 0; i< lis.length; i++) {
			lis[i].className = '';
		}
		this.parentNode.className = 'selected';
	}
	onimage(document.getElementById(this.secid));
	return false;
}
function onimage(child){
    var tags = child.getElementsByTagName("img");
//    var replaceoff =/\.off$/g;
	for (var i=0; i < tags.length; i++) {
	    if (!tags[i].src && tags[i].longDesc){
	    tags[i].src=tags[i].longDesc;
	    tags[i].longDesc='';
	    }
//	    tags[i].src=tags[i].src.replace(replaceoff,"");

	}
var attrs="";
	for (a in tags[0]) {
	attrs=attrs+"\n"+a;
	}
//	alert(child.parentNode.parentNode.toString());
//alert (attrs);
}
