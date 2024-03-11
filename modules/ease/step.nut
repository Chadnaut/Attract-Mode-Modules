::ease.stepJumpStart <-  function(t, b, c, d, n = 1) { local x = 1.0;   local y = ceil(t/d*n);             return c*(x>y?x:y)/n + b; }
::ease.stepJumpEnd <-    function(t, b, c, d, n = 1) { local x = n-1.0; local y = floor(t/d*n);            return c*(x<y?x:y)/n + b; }
::ease.stepJumpNone <-   function(t, b, c, d, n = 1) { local x = n-1.0; local y = floor(t/d*n);            return c*(x<y?x:y)/(n-1.0) + b; }
::ease.stepJumpBoth <-   function(t, b, c, d, n = 1) { local x = n;     local y = floor((t/d+(1.0/n))*n);  return c*(x<y?x:y)/(n+1.0) + b; }
