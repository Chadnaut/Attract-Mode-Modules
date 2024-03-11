::ease.none <-           function(t, b, c, d) { return b+(t==d?c:0); }
::ease.linear <-         function(t, b, c, d) { return c*t/d + b; }

::ease.inQuad <-         function(t, b, c, d) { return c*(t/=d)*t + b; }
::ease.inCubic <-        function(t, b, c, d) { return c*(t/=d)*t*t + b; }
::ease.inQuart <-        function(t, b, c, d) { return c*(t/=d)*t*t*t + b; }
::ease.inQuint <-        function(t, b, c, d) { return c*(t/=d)*t*t*t*t + b; }
::ease.inSine <-         function(t, b, c, d) { return -c*cos(t/d*(PI/2)) + c + b; }
::ease.inExpo <-         function(t, b, c, d) { return (t==0) ? b : c*pow(2, 10*(t/d - 1)) + b; }
::ease.inCirc <-         function(t, b, c, d) { return -c*(sqrt(1 - (t/=d)*t) - 1) + b; }
::ease.inElastic <-      function(t, b, c, d, a = null, p = null) { local s; if (t==0) return b; if ((t/=d)==1) return b+c; if (p == null) p=d*0.3; if ((a == null) || (a < fabs(c))) { a=c; s=p/4; } else s = p/(2*PI)*asin(c/a); return -(a*pow(2,10*(t-=1))*sin( (t*d-s)*(2*PI)/p )) + b; }
::ease.inBack <-         function(t, b, c, d, s = null) { if (s == null) s = 1.70158; return c*(t/=d)*t*((s+1)*t - s) + b; }
::ease.inBounce <-       function(t, b, c, d) { return c - ::ease.outBounce(d-t, 0, c, d) + b; }

::ease.outQuad <-        function(t, b, c, d) { return -c*(t/=d)*(t-2) + b; }
::ease.outCubic <-       function(t, b, c, d) { return c*((t=t/d-1)*t*t + 1) + b; }
::ease.outQuart <-       function(t, b, c, d) { return -c*((t=t/d-1)*t*t*t - 1) + b; }
::ease.outQuint <-       function(t, b, c, d) { return c*((t=t/d-1)*t*t*t*t + 1) + b; }
::ease.outSine <-        function(t, b, c, d) { return c*sin(t/d*(PI/2)) + b; }
::ease.outExpo <-        function(t, b, c, d) { return (t==d) ? b+c : c*(-pow(2, -10*t/d) + 1) + b; }
::ease.outCirc <-        function(t, b, c, d) { return c*sqrt(1 - (t=t/d-1)*t) + b; }
::ease.outElastic <-     function(t, b, c, d, a = null, p = null) { local s; if (t==0) return b; if ((t/=d)==1) return b+c; if (p == null) p=d*0.3; if ((a == null) || (a < fabs(c))) { a=c; s=p/4; } else s = p/(2*PI)*asin(c/a); return a*pow(2,-10*t)*sin( (t*d-s)*(2*PI)/p ) + c + b; }
::ease.outBack <-        function(t, b, c, d, s = null) { if (s == null) s = 1.70158; return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b; }
::ease.outBounce <-      function(t, b, c, d) { if ((t/=d) < (1/2.75)) { return c*(7.5625*t*t) + b; } else if (t < (2/2.75)) { return c*(7.5625*(t-=(1.5/2.75))*t + 0.75) + b; } else if (t < (2.5/2.75)) { return c*(7.5625*(t-=(2.25/2.75))*t + 0.9375) + b; } else { return c*(7.5625*(t-=(2.625/2.75))*t + 0.984375) + b; } }

::ease.inOutQuad <-      function(t, b, c, d) { if ((t/=d/2) < 1) return c/2*t*t + b; return -c/2*((--t)*(t-2) - 1) + b; }
::ease.inOutCubic <-     function(t, b, c, d) { if ((t/=d/2) < 1) return c/2*t*t*t + b; return c/2*((t-=2)*t*t + 2) + b; }
::ease.inOutQuart <-     function(t, b, c, d) { if ((t/=d/2) < 1) return c/2*t*t*t*t + b; return -c/2*((t-=2)*t*t*t - 2) + b; }
::ease.inOutQuint <-     function(t, b, c, d) { if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b; return c/2*((t-=2)*t*t*t*t + 2) + b; }
::ease.inOutSine <-      function(t, b, c, d) { return -c/2*(cos(PI*t/d) - 1) + b; }
::ease.inOutExpo <-      function(t, b, c, d) { if (t==0) return b; if (t==d) return b+c; if ((t/=d/2) < 1) return c/2*pow(2, 10*(t - 1)) + b; return c/2*(-pow(2, -10*--t) + 2) + b; }
::ease.inOutCirc <-      function(t, b, c, d) { if ((t/=d/2) < 1) return -c/2*(sqrt(1 - t*t) - 1) + b; return c/2*(sqrt(1 - (t-=2)*t) + 1) + b; }
::ease.inOutElastic <-   function(t, b, c, d, a = null, p = null) { local s; if (t==0) return b; if ((t/=d/2)==2) return b+c; if (p == null) p=d*(0.3*1.5); if ((a == null) || (a < fabs(c))) { a=c; s=p/4; } else s = p/(2*PI)*asin(c/a); if (t < 1) return -0.5*(a*pow(2,10*(t-=1))*sin( (t*d-s)*(2*PI)/p )) + b; return a*pow(2,-10*(t-=1))*sin( (t*d-s)*(2*PI)/p )*0.5 + c + b; }
::ease.inOutBack <-      function(t, b, c, d, s = null) { if (s == null) s = 1.70158; if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b; return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b; }
::ease.inOutBounce <-    function(t, b, c, d) { if (t < d/2) return ::ease.inBounce(t*2, 0, c, d)*0.5 + b; return ::ease.outBounce(t*2-d, 0, c, d)*0.5 + c*0.5 + b; }

::ease.outInQuad <-      function(t, b, c, d) { if (t < d/2) return ::ease.outQuad(t*2, 0, c, d)*0.5 + b;    return ::ease.inQuad(t*2-d, 0, c, d)*0.5 + c*0.5 + b; }
::ease.outInCubic <-     function(t, b, c, d) { if (t < d/2) return ::ease.outCubic(t*2, 0, c, d)*0.5 + b;   return ::ease.inCubic(t*2-d, 0, c, d)*0.5 + c*0.5 + b; }
::ease.outInQuart <-     function(t, b, c, d) { if (t < d/2) return ::ease.outQuart(t*2, 0, c, d)*0.5 + b;   return ::ease.inQuart(t*2-d, 0, c, d)*0.5 + c*0.5 + b; }
::ease.outInQuint <-     function(t, b, c, d) { if (t < d/2) return ::ease.outQuint(t*2, 0, c, d)*0.5 + b;   return ::ease.inQuint(t*2-d, 0, c, d)*0.5 + c*0.5 + b; }
::ease.outInSine <-      function(t, b, c, d) { if (t < d/2) return ::ease.outSine(t*2, 0, c, d)*0.5 + b;    return ::ease.inSine(t*2-d, 0, c, d)*0.5 + c*0.5 + b; }
::ease.outInExpo <-      function(t, b, c, d) { if (t < d/2) return ::ease.outExpo(t*2, 0, c, d)*0.5 + b;    return ::ease.inExpo(t*2-d, 0, c, d)*0.5 + c*0.5 + b; }
::ease.outInCirc <-      function(t, b, c, d) { if (t < d/2) return ::ease.outCirc(t*2, 0, c, d)*0.5 + b;    return ::ease.inCirc(t*2-d, 0, c, d)*0.5 + c*0.5 + b; }
::ease.outInElastic <-   function(t, b, c, d) { if (t < d/2) return ::ease.outElastic(t*2, 0, c, d)*0.5 + b; return ::ease.inElastic(t*2-d, 0, c, d)*0.5 + c*0.5 + b; }
::ease.outInBack <-      function(t, b, c, d) { if (t < d/2) return ::ease.outBack(t*2, 0, c, d)*0.5 + b;    return ::ease.inBack(t*2-d, 0, c, d)*0.5 + c*0.5 + b; }
::ease.outInBounce <-    function(t, b, c, d) { if (t < d/2) return ::ease.outBounce(t*2, 0, c, d)*0.5 + b;  return ::ease.inBounce(t*2-d, 0, c, d)*0.5 + c*0.5 + b; }
