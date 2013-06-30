var randomString = function(length, chars) {
    var result = '';
    for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
    return result;
}

var createCookie = function(name, value, days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        var expires = "; expires=" + date.toGMTString();
    }
    else var expires = "";
    document.cookie = name + "=" + value + expires + "; path=/";
}

var getCookie = function(c_name) {
    if (document.cookie.length > 0) {
        c_start = document.cookie.indexOf(c_name + "=");
        if (c_start != -1) {
            c_start = c_start + c_name.length + 1;
            c_end = document.cookie.indexOf(";", c_start);
            if (c_end == -1) {
                c_end = document.cookie.length;
            }
            return unescape(document.cookie.substring(c_start, c_end));
        }
    }
    return null;
}

var uniqueString = function() {
    var rString = "";
    var cData = getCookie("_lmwa"); 
    if(cData != null) {
	rString = cData;
    } else {
	rString = randomString(16, '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
	createCookie("_lmwa", rString, 0);
    }
    return rString;
}

var trackPage = function() {    
    // console.log("tracking page info");
    // alert("inside track page");
    xmlhttp=new XMLHttpRequest();
    xmlhttp.open("POST", "http://192.168.1.125:3001/experience/track_session_visits", true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");    
    xmlhttp.send("theme_id=" + genThemeId + "&" + "canvas_id=" + genCanvasId + "&" + "tracking_id=" + genTrackingId);
    // xmlhttp.send(JSON.stringify(myVisit));
};

var initTrackStorage = function(eleId) {
    if(genTrackingEvent[eleId] == undefined) {
	genTrackingEvent[eleId] = {"hover": 0, "click": 0};
    } 
};

var trackHover = function(eleId) {
    initTrackStorage(eleId);
    genTrackingEvent[eleId]["hover"] += 1;
};

var trackClick = function(eleId) {
    initTrackStorage(eleId);
    console.log("trackClick");
    console.log(genTrackingEvent[eleId]["click"]);
    genTrackingEvent[eleId]["click"] += 1;
};


var trackEvents = function() {    
    // alert("inside track events from confirm exit");
    console.log("tracking user interactions");
    xmlhttp=new XMLHttpRequest();
    // alert('start');
    xmlhttp.open("POST","http://192.168.1.125:3001/experience/track_events",true);
    // alert('finish');
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    // console.log(genTrackingEvent);
    // console.log("ddddddd");
    xmlhttp.send("theme_id=" + genThemeId + "&" + "canvas_id=" + genCanvasId + "&" + "tracking_id=" + genTrackingId +"&" + "data="+ JSON.stringify(genTrackingEvent));
};

function confirmExit() {
    // alert(1);
    trackEvents();
}