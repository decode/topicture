/**
 * Script used by gallary view
 */


var overlayOpacity = 0.8;	// controls transparency of shadow overlay
var overlayDuration = 0;

Object.extend(Element, {
	getWidth: function(element) {
	   	element = $(element);
	   	return element.offsetWidth; 
	},
	setWidth: function(element,w) {
	   	element = $(element);
    	element.style.width = w +"px";
	},
	setHeight: function(element,h) {
   		element = $(element);
    	element.style.height = h +"px";
	},
	setTop: function(element,t) {
	   	element = $(element);
    	element.style.top = t +"px";
	},
	setSrc: function(element,src) {
    	element = $(element);
    	element.src = src; 
	},
	setHref: function(element,href) {
    	element = $(element);
    	element.href = href; 
	},
	setInnerHTML: function(element,content) {
		element = $(element);
		element.innerHTML = content;
	}
});


var GallaryPassbox = Class.create();

GallaryPassbox.prototype = {

  initialize: function() {
		var objBody = document.getElementsByTagName("body").item(0);
		
		var objOverlay = document.createElement("div");
		objOverlay.setAttribute('id','passbox_overlay');
		objOverlay.style.display = 'none';
    //objOverlay.onclick = function() { myLightbox.end(); }
		objBody.appendChild(objOverlay);

    var objInfo = document.createElement("span");
    objInfo.setAttribute('id', 'message');
    objInfo.style.display = 'none';
    objBody.appendChild(objInfo);


		if (!document.getElementsByTagName){ return; }
		var anchors = document.getElementsByTagName('a');
		var areas = document.getElementsByTagName('area');

		// loop through all anchor tags
		for (var i=0; i<anchors.length; i++){
			var anchor = anchors[i];
			
			var relAttribute = String(anchor.getAttribute('rel'));
			
			// use the string.match() method to catch 'lightbox' references in the rel attribute
			if (anchor.getAttribute('href') && (relAttribute.toLowerCase().match('pass_box'))){
				anchor.onclick = function () {passBox.show_box(this); return false;}
			}
		}

		for (var i=0; i< areas.length; i++){
			var area = areas[i];
			
			var relAttribute = String(area.getAttribute('rel'));
			
			// use the string.match() method to catch 'lightbox' references in the rel attribute
			if (area.getAttribute('href') && (relAttribute.toLowerCase().match('pass_box'))){
				area.onclick = function () {passBox.show_box(this); return false;}
			}
		}

  },
  
  show_box: function(subject) {
    var arrayPageSize = getPageSize();
    Element.setHeight('passbox_overlay', arrayPageSize[1]);
    Effect.Appear('passbox_overlay', { duration: overlayDuration, from: 0.0, to: overlayOpacity });

    var arrayPageScroll = getPageScroll();
    var passformTop = arrayPageScroll[1] + (arrayPageSize[3] / 10);
    Element.setTop('gallary_password', passformTop);
    Element.show('gallary_password');
  },

  hide_box: function() {
    $('gallary_password').hide();
		new Effect.Fade('passbox_overlay', { duration: overlayDuration});
  }

  /* 
  getPageScroll: function(){

    var yScroll;

    if (self.pageYOffset) {
      yScroll = self.pageYOffset;
    } else if (document.documentElement && document.documentElement.scrollTop){	 // Explorer 6 Strict
      yScroll = document.documentElement.scrollTop;
    } else if (document.body) {// all other Explorers
      yScroll = document.body.scrollTop;
    }

    arrayPageScroll = new Array('',yScroll) 
    return arrayPageScroll;
  },
  
  getPageSize: function(){
    
    var xScroll, yScroll;
    
    if (window.innerHeight && window.scrollMaxY) {	
      xScroll = document.body.scrollWidth;
      yScroll = window.innerHeight + window.scrollMaxY;
    } else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
      xScroll = document.body.scrollWidth;
      yScroll = document.body.scrollHeight;
    } else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
      xScroll = document.body.offsetWidth;
      yScroll = document.body.offsetHeight;
    }
    
    var windowWidth, windowHeight;
    if (self.innerHeight) {	// all except Explorer
      windowWidth = self.innerWidth;
      windowHeight = self.innerHeight;
    } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
      windowWidth = document.documentElement.clientWidth;
      windowHeight = document.documentElement.clientHeight;
    } else if (document.body) { // other Explorers
      windowWidth = document.body.clientWidth;
      windowHeight = document.body.clientHeight;
    }	
  }
  */
}

function initGallaryPassbox() { passBox = new GallaryPassbox(); }
Event.observe(window, 'load', initGallaryPassbox, false);
