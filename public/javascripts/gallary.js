/**
 * Script used by gallary view
 */
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
  
  showpic: function(subject) {
    var arrayPageSize = getPageSize();
    Element.setHeight('overlay', arrayPageSize[1]);
    Effect.Appear('overlay', { duration: overlayDuration, from: 0.0, to: overlayOpacity });

    var arrayPageScroll = getPageScroll();
    var passformTop = arrayPageScroll[1] + (arrayPageSize[3] / 10);
    Element.setTop('gallary_password', passformTop);
    Element.show('gallary_password');
  }

  hide_passbox: function() {
    $('gallary_password').style.display = 'none';
    $('overlay').style.display = 'none';
  }

  /*
  function getPageScroll(){

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
  }
  */
  /*
  function getPageSize(){
    
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
};

function initGallaryPassbox() { gpBox = new GallaryPassbox(); }
Event.observe(window, 'load', initGallaryPassbox, false);
