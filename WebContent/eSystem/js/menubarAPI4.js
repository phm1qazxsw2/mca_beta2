/**
* menubarAPI4.js
* Copyright2001 Garrett S. Smith
* modified: Apr. 22, 2002
* This code may be used without permission, for free. This copyright
* Must remain in the code. See http://dhtmlkitchen.com for usage instructions and terms of use.*/
var menuOffsetTop=menuOffsetLeft=submenuOffsetTop=submenuOffsetLeft=submenuOffsetRight=0;
var Doc=this.document;var standards=Doc.createElement&&Doc.createTextNode?1:0;
function Browser(){var n=navigator.userAgent,d=Doc;this.ie6=(n.indexOf("MSIE 6")>0);this.ie=(n.indexOf("MSIE 5")>0||this.ie6);this.ie50=(n.indexOf("MSIE 5.0")>0);this.m=(n.indexOf("Mac")>0);this.mIE=(this.m&&this.ie);this.wIE=(this.ie&&!this.m);this.ns=(n.indexOf("Gecko")>0);this.css1=(!d.compatMode&&!this.mIE||d.doctype&&d.doctype.name.indexOf("/TR/")>-1||"CSS1Compat"==d.compatMode);if(this.wIE&&!this.ie6)this.css1=0;this.moz=this.ns&&!(n.indexOf("Netscape")>0);this.minNS61=(this.moz||this.ns&&n.indexOf("6.")!=-1&&parseInt(n.substr(n.indexOf("6.")+2,1))>1);}this.bw=new Browser();
glut={ml:[],ll:[],RMM:null,LMM:null,BMM:null,db:null,am:null,fb:0,mo:0,arrowFont:"Webdings",arrowText:"4",er:"<tr><td style='height: 0px;'></td></tr>"};window.onresize=function(){setTimeout("ump()",100);};Doc.onmouseup=rM;
function rM(e){e=e?e:window.event;var t=e.srcElement?e.srcElement:e.target;if(t.nodeName=="#text")t=t.parentNode;if(!t.className||glut.db&&t.className.indexOf("buttons")!=0||!ct(t.menubar,glut.db))if(glut.db)rs(glut.db,"buttons");else if(glut.am)rs(glut.am.ob);}this.menubar=null;
function Menubar(id){menubar=div();menubar.buttons=[];menubar.id=id?id:"menubar";menubar.className="menubar";menubar.add=add;menubar.addText=addText;menubar.addMenu=menubarAddMenu;menubar.add(fix());menubar.moveByY=moveByY;menubar.setWidth=menubarSetWidth;menubar.keepOnTop=keepOnTop;menubar.sb=0;menubar.fb=0;menubar.useMouseOver=function(on){glut.mo=(on==false)?0:1};fixHeight(menubar);
menubar.onmouseout=function(e){if(!glut.mo||!glut.db)return;e=e?e:window.event;if(e.nodeName=="#text")e=e.parentNode;var rt=e.relatedTarget?e.relatedTarget:e.toElement;var t=e.currentTarget?e.currentTarget:e.srcElement;if(ct(document.documentElement,rt)&&!ct(this,rt)&&!ct(glut.db.m,rt))rs(glut.db,"buttons");};eval(menubar.id+"=menubar");return menubar;}
function fix(){var f=div();with(f){className="buttons";with(style){width=0;margin=0;if(!bw.wIE)border=0;padding=0;fontSize=0;visibility="hidden";};};return f;}
function add(mbi){if(typeof mbi=="string")this.addText(mbi);else if(mbi.className=="menu")this.addMenu(mbi);else if(mbi.isSb){this.sb=1;if(bw.wIE){mbi=Doc.body.appendChild(mbi);mbi.style.height=(mbi.firstChild.offsetHeight)+'px';mbi.style.overflow="hidden";mbi=Doc.body.removeChild(mbi);}if(bw.ns)mbi.getElementsByTagName("input")[0].style.marginBottom="7px";var addH=(bw.wIE&&!bw.ie6)?2:1;if(this.style.height<mbi.offsetHeight)this.style.height=(mbi.offsetHeight+addH)+"px";this.appendChild(mbi);}else this.appendChild(mbi);if(bw.mIE){x=fix();x.style.width="1px";this.appendChild(x);}}
function Searchbox(value,action,formId,inputName){var d=div();var sm=(bw.mIE)?"":"font-size:smaller;";if(bw.mIE){d.style.width="10px";}if(bw.ns)d.style.cssFloat="left";else d.style.styleFloat="left";d.style.padding="0";var form="<form onmouseup='event.cancelBubble=true' style='display:inline;width:0;padding:0;margin:0;white-space:nowrap;' action='"+action+"' id='"+formId+"'><input type='txt' onfocus=\"status='"+value+"'\" onblur='status=defaultStatus' style='display:inline;cursor:text;"+sm+"' size='12' name='"+inputName+"' id='"+formId+"Field' /><button type='submit' style='"+sm+"' value='"+value+"'>"+value+"</button></form>";if(bw.ie)form+=fix().outerHTML;d.innerHTML=form;d.isSb=1;return d;}
function Button(txt,u,id){var b,link=0;if(arguments.length>=2){b=Doc.createElement("a");b.href=u;if(arguments[1].indexOf(".")==-1)alert("ERROR:\nInvalidconstructor:newButton("+arguments[0]+","+arguments[1]+")"+"\nThesecondargumentmustbeaURL"+"\nAurlmusthavea\".\"character");b.id=id;link=1;}if(!link){b=div();b.onmouseover=buttonOver;if(!glut.mo){b.onclick=buttonClick;b.onmouseout=buttonOut;}else b.onmousedown=buttonClick;}b.className="buttons";b.innerHTML=txt;b.menuOffsetTop=menuOffsetTop;b.mol=menuOffsetLeft;b.mor=0;return b;}
function Label(txt){var l=div();l.txt=txt;l.className="label";l.style.position="relative";l.style.whiteSpace="nowrap";if(!bw.ie)l.style.width="auto";if(bw.wIE&&!bw.ie6)l.style.width="100%";l.innerHTML=txt;l.m=null;l.onmouseover=labelOver;l.onmouseup=function(e){e=e?e:window.event;e.cancelBubble=true;};l.menuOffsetTop=submenuOffsetTop;l.mol=submenuOffsetRight;l.mor=submenuOffsetLeft;if(bw.mIE)l.innerHTML+="</td><td><span isArrow=1 style='position:absolute;top:0;right:0;margin:0;font-family:"+glut.arrowFont+";font-weight:900'>"+glut.arrowText+"</span></td>";glut.ll[glut.ll.length]=l;return l;}
function Menu(titl){M=div();M.lt=titl;M.id="Menu"+glut.ml.length;M.className="menu";M.appendChild(T());M.table=(bw.mIE)?M.firstChild:M.firstChild.firstChild;M.addItem=addItem;M.addSeparator=addSeparator;M.addMenu=addMenu;M.setWidth=
function(w){var px="";if(typeof w=="number")px="px";this.style.width=w+px;};M.add=
function(o){if(!o)return;if(o.addItem!=null)this.addMenu(o);else if(o.tagName!="TR"){if(o.isSb){if(bw.mIE)this.table.insertAdjacentHTML("BeforeEnd",glut.er);else if(bw.ns)o.firstChild.firstChild.style.marginBottom="6px";}if(bw.mIE&&bw.ie50&&o.isSb)this.table.insertAdjacentHTML("BeforeEnd","<tr><td>"+o.innerHTML+"</td></tr>");else this.table.appendChild(cwo(o));}else if(o.className!="buttons")this.addItem(o);};M.om=null;M.as=null;M.help="";M.isPos=0;M.stk=1000;glut.ml[glut.ml.length]=M;return Doc.body.appendChild(M);}
function addMenu(m){l=Label(m.lt);l.om=this;l.m=m;l.help=m.help;l.m.ol=l;l.m.om=this;addLabel(this,l);}
function addMenuOrItem(txt,u,id){if(arguments[0].className)this.addMenu(arguments[0]);else this.addItem(txt,u,id);}
function menubarAddMenu(m){var b=m.ob=this.buttons[this.buttons.length++]=Button(m.lt);b.m=m;b.id=this.id+"B"+this.buttons.length;b.menubar=b.m.menubar=this;if(!this.hasAMenu)m.style.marginLeft="-1px";b.msg=m.lt;this.appendChild(b);if(bw.mIE&&!this.sb&&this.hasAMenu)this.appendChild(fix());this.hasAMenu=1;}
function addText(txt){d=div();d.className="buttons";d.innerHTML=txt;this.appendChild(d);}
function addItem(o){o.firstChild.firstChild.om=this;if(bw.mIE)this.table.insertAdjacentHTML("BeforeEnd",glut.er);this.table.appendChild(o);}
function MenuItem(txt,u){var a=Doc.createElement("a");a.className="menuItem";a.onmouseover=itemOver;if(u)a.setAttribute("href",u);if(!bw.wIE)a.style.width="auto";a.innerHTML=txt;return cwo(a);}
function addLabel(m,l){c=cwo(l);if(bw.ie6){c.onmouseover=
function(){if(!this.wideEnoughForIE6){l.style.width=l.offsetWidth-parseInt(l.currentStyle.paddingLeft)-parseInt(l.currentStyle.paddingRight);this.wideEnoughForIE6=1;}}}else if(bw.wIE)l.style.width="100%";if(bw.mIE){m.table.insertAdjacentHTML("BeforeEnd",glut.er);l.style.width="auto";}negArrowHeight=(bw.wIE)?-2:0;m.table.appendChild(c);if(!bw.mIE)l.innerHTML+="<span style='position:absolute;top:0;margin:0;line-height:"+(l.parentNode.offsetHeight+negArrowHeight)+"px;right:0;font-family:"+glut.arrowFont+";font-weight:900' isArrow=1>"+glut.arrowText+"</span>";else l.getElementsByTagName("span")[0].style.lineHeight=18+"px";}
function addSeparator(c){var sep=div();sep.className="separator";with(sep.style){height=0;fontSize=0;lineHeight=0;if(!bw.ie)width="auto";if(!c){borderTop="1px solid ThreeDShadow";borderBottom="1px solid ThreeDHighlight";}else if(bw.ie)border="1px groove "+c;else borderBottom="2px groove "+c;}if(bw.mIE)this.table.insertAdjacentHTML("BeforeEnd",glut.er);this.table.appendChild(cwo(sep));if(bw.ie6)sep.style.marginBottom=(parseInt(sep.currentStyle.marginBottom)-2)+"px";if(bw.mIE)sep.style.marginTop=(parseInt(sep.currentStyle.marginTop)-2)+"px";}
function menubarSetWidth(w,i){this.style.width=w;if(typeof i!="number")i=2;i-=bw.css1?2:0;this.style.width=(this.offsetWidth+i)+"px";}
function setArrow(f,t){glut.arrowFont=f;glut.arrowText=t;for(var i=0;i<glut.ll.length;i++){var spans=glut.ll[i].getElementsByTagName("span");var arr=spans[0];if(arr&&Boolean(arr.isArrow||arr.getAttribute("isArrow"))){arr.innerHTML="<span style='margin:0;font-family:"+f+"'>"+t+"</span>";}}}
function T(){var t=Doc.createElement("table");t.cellPadding=0;t.cellSpacing=0;t.style.margin=0;if(!bw.mIE)t.appendChild(Doc.createElement("tbody"));return t;}
function cwo(o){r=Doc.createElement("tr");c=Doc.createElement("td");c.appendChild(o);r.appendChild(c);return r}
function div(){return Doc.createElement("div");}
function getObj(s){return typeof s=="string"?Doc.getElementById(s):s;}
function fixHeight(mb){var b=Doc.body.appendChild(Button());var h=b.offsetHeight;h+=bw.css1?2:4;mb.style.height=h+"px";if(bw.ns)mb.style.clip="auto";Doc.body.removeChild(b);}
function getTop(o){if(bw.ie)return o.style.posTop;else return parseInt(Doc.defaultView.getComputedStyle(o,'').getPropertyValue('top'));}
function ct(a,b){return b?(b==a)?1:ct(a,b.parentNode):0;}
function getOffset(el,offset){return el[offset]+(el.offsetParent?getOffset(el.offsetParent,offset):0);}
function gsl(){if(bw.ie)return(Doc.body.scrollLeft);if(bw.ie6)return(Doc.documentElement.scrollLeft);else return(window.pageXOffset);}
function gst(){if(bw.ns)return(window.pageYOffset);if(bw.ie6)return(Doc.documentElement.scrollTop);return(Doc.body.scrollTop);}
function gvw(){if(bw.ie6)return Doc.documentElement.clientWidth;return(window.innerWidth)?window.innerWidth-18:Doc.body.clientWidth-2;}
function getVH(){if(bw.ns)return window.innerHeight-18;if(bw.ie6)return Doc.documentElement.clientHeight;return Doc.body.clientHeight-2;}
function moveByY(deltaY){this.style.top=parseInt(this.style.top)+deltaY+"px";}
function buttonOver(e){if(glut.db==this)return;else if(glut.am&&!ct(this.menubar,glut.am.ob)){this.className="buttonsOver";return;}if(this.m&&!this.m.ob||this.m.ob!=this)this.m.ob=this;sp(this.m);if(glut.db||glut.mo){if(glut.db)rs(glut.db,"buttons");if(glut.am)rM();blmo(this,e);dp(this);glut.db=this;}else this.className="buttonsOver";window.status=this.m.help?this.msg+": "+this.m.help:this.msg;}
function buttonClick(e){if(glut.mo)return;if(glut.am&&glut.am!=this.m)rM();if(this==glut.db)rs(this,"buttonOver");else{blmo(this,e);this.m.ob=this;sp(this.m);dp(this);glut.db=this;}if(bw.mIE)this.style.cursor="default";}
function buttonOut(e){if(glut.db==this)return;this.className="buttons";window.status=window.defaultStatus;}
function dp(b){b.className="buttonsDown";b.m.style.visibility="visible";glut.am=b.m;glut.db=this;if(bw.ns)b.m.style.height="";}
function rs(b,cn){if(b){if(cn)b.className=cn;b.m.style.visibility="hidden";if(b.m.as)rsm(b.m.as);}glut.db=null;glut.am=null;}
function blmo(bl,e){if(glut.mo)bl.m.onmouseout=hm;else bl.m.onmouseout=no;}
function labelOver(e){sp(this.m);if(this.m.ob)this.m.ob=null;this.className="labelOver";if(this.om.as&&this.om.as!=this.m)rsm(this.om.as);this.m.om.as=this.m;blmo(this,e);window.status=this.txt;this.m.style.visibility="visible";if(bw.mIE)Doc.body.appendChild(div());else if(bw.ns)this.m.style.height="";}
function rsm(m){if(m.as)rsm(m.as);if(m.ol){m.ol.className="label";m.om.as=null;}m.style.visibility="hidden";window.status=window.defaultStatus;}
function itemOver(e){if(this.om.as){rsm(this.om.as);this.om.as=null;}}
function sp(m){var b=m.ob?1:0;var l=m.ol?1:0;var uf=glut.fb&&bw.minNS61||bw.moz;m.bl=b?m.ob:m.ol?m.ol:null;if(m.isPos&&(l||b)&&!(bw.ie&&glut.fb))return;var vw=gvw();if(!uf)vw+=gsl();var vh=getVH();if(!uf)vh+=gst();buttonHeight=m.bl.offsetHeight,buttonWidth=l?m.ol.offsetWidth:0,buttonLeft=getOffset(m.bl,"offsetLeft"),bot=m.bl?getOffset(m.bl,"offsetTop"):0;if(uf)m.style.position="fixed";bot+=m.bl.menuOffsetTop;ypos=bot;m.right=m.offsetLeft+m.offsetWidth;m.bottom=ypos+m.offsetHeight;var mp,rp,lp,rvo=0,lvo=0;rp=buttonLeft+buttonWidth;rp+=m.bl.mol;lp=buttonLeft-m.offsetWidth;lp-=m.bl.mor;if(bw.mIE&&l){rp-=parseInt(m.bl.currentStyle.paddingRight)||0;lp-=parseInt(m.bl.currentStyle.paddingLeft)||0;}if(!b)if(rp+m.offsetWidth>vw)rvo=(rp+m.offsetWidth)-vw;if(lp<0)lvo=-lp;if(rvo>=0&&rvo<=lvo){mp=rp;m.iar=1;glut.RMM=glut.RMM?(m.right>glut.RMM.right)?m:glut.RMM:m;}else{mp=lp;m.iar=0;glut.LMM=glut.LMM?(m.offsetLeft>glut.LMM.offsetLeft)?m:glut.LMM:m;}if(!isNaN(mp))m.style.left=mp+"px";if(!m.iar&&lvo>0)m.style.left="0px";if(m.iar&&rvo>0){m.overlap=rvo;urp(m);}m.stk=m.om?m.om.stk+100:10000;m.style.zIndex=m.stk;if(!isNaN(bot))m.style.top=bot+buttonHeight+"px";if(m.bottom>vh){m.vOverlap=m.bottom-vh;ubp(m);}if(m.top<0)m.style.top="0px";if(m.as)sp(m.as);glut.BMM=getBMM(getRM(m));if(b&&m.bl.className&&m.bl.className.indexOf("buttons")==0)m.isPos=1;}
function getRM(m){return m.om?getRM(m.om):m;}
function getBMM(m){if(!m.as)return m;else{glut.BMM=(m.bottom>=m.as.bottom)?m:m.as;getBMM(m.as);}return m;}
function urp(m){m.style.left=getOffset(m,"offsetLeft")-m.overlap+2+"px";}
function ubp(m){m.style.top=getOffset(m,"offsetTop")-m.vOverlap-((m.ol)?m.ol.offsetHeight:2)+"px";}
function ump(e){var m=glut.ml;for(var i=0;i<glut.ml.length;i++)m[i].isPos=0;if(glut.RMM)sp(glut.RMM);if(glut.BMM)sp(glut.BMM);if(glut.LMM)sp(glut.LMM);}
function showMenu(m,event){if(m.style.visibility=="visible")return false;if(glut.db)rs(glut.db,"buttons");if(glut.am){glut.am.style.visibility="hidden";glut.am=null;}m=getObj(m),scrollTop=gst(),scrollLeft=gsl(),menuWidth=m.offsetWidth;if(window.event){m.ob=event.srcElement;m.left=event.x+gsl();m.top=event.y+scrollTop;}else{event.preventDefault();m.ob=event.target;m.left=event.pageX;m.top=event.pageY;}m.ob.m=m;m.bottom=m.top+m.offsetHeight;if(m.bottom>scrollTop+getVH()){m.top-=((m.top+m.offsetHeight)-(scrollTop+getVH()));glut.BMM=m;}if(m.left+menuWidth>scrollLeft+gvw()){m.left-=((m.left+menuWidth)-(scrollLeft+gvw()));glut.RMM=m;}ump();m.style.left=m.left+"px";m.style.top=m.top+"px";if(bw.mIE)Doc.body.appendChild(Menu());m.style.visibility="visible";glut.am=m;return false;}
function hm(event){e=event?event:window.event;rt=e.toElement?e.toElement:e.relatedTarget;if(rt!=null){if(ct(this,rt)||this.menubar&&this.menubar==rt)return;if(rt&&this.ob&&this.ob==rt||!bw.moz&&this.ob==rt.parentNode)return;if(this.om&&ct(this.om,rt))return;if(this.as&&ct(this.as,rt)){return;}}
if(bw.moz){
if(this.as
&&glut.c.y>getTop(this.as)-3
&&glut.c.y<getTop(this.as)+this.as.offsetHeight+3){
if(this.as.iar){
if(glut.c.x+this.as.offsetWidth/2>this.as.offsetLeft)return;
}
else if(glut.c.x-this.as.offsetWidth/2<getOffset(this.as,"offsetLeft")
+this.as.offsetWidth)return;
}
else if(this.om&&glut.c.y<this.om.offsetTop+this.om.offsetHeight){
if(this.iar){
if(glut.c.x>this.om.offsetLeft&&glut.c.x<this.om.offsetLeft+this.om.offsetWidth+40)return;
}
else if(glut.c.x>this.om.offsetLeft)return;
}
}
if(glut.am==null||bw.moz&&glut.c.y<glut.am.offsetTop+2)return;rsm(glut.am);if(glut.db)rs(glut.db,"buttons");else glut.mo=0;glut.am=null;this.isPos=0;return false;}
if(bw.moz){glut.c={x:0,y:0};document.addEventListener("mousemove",function(e){glut.c.x=e.pageX;glut.c.y=e.pageY;},false);}
function no(){status=status;}
function menuHideOnMouseOut(m){m=getObj(m),m.onmouseout=hm;glut.mo=1;return false;}
function keepOnTop(){glut.fb=1;if(this.style.top=="")this.style.top=typeof getTop(this)=="number"?getTop(this):this.offsetTop-1;if(bw.minNS61)this.style.position="fixed";else{viewTop=gst();viewBottom=getVH();if(getTop(this)+this.offsetHeight<viewTop)this.style.top=(viewTop-this.offsetHeight)+"px";if(this.top>viewBottom)this.style.top=viewBottom+"px";dy=Math.round(Math.abs(viewTop-getTop(this))/2);if(glut.db&&dy>0)rs(glut.db,"buttons");if(viewTop<getTop(this))dy=-dy;this.moveByY(dy);var sp=(getTop(this)!=viewTop)?54:400;if(sp==54&&bw.mIE){no();}setTimeout(this.id+".keepOnTop()",sp);}}