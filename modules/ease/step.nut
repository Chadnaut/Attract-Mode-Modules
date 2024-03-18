::ease.step_jump_start <-     function(t, b, c, d, n = 1) { local x = 1.0;   local y = ceil(t/d*n);             return c*(x>y?x:y)/n + b; }
::ease.step_jump_end <-       function(t, b, c, d, n = 1) { local x = n-1.0; local y = floor(t/d*n);            return c*(x<y?x:y)/n + b; }
::ease.step_jump_none <-      function(t, b, c, d, n = 1) { local x = n-1.0; local y = floor(t/d*n);            return c*(x<y?x:y)/(n-1.0) + b; }
::ease.step_jump_both <-      function(t, b, c, d, n = 1) { local x = n;     local y = floor((t/d+(1.0/n))*n);  return c*(x<y?x:y)/(n+1.0) + b; }

::ease.get_step_jump_start <- @(steps) @(t, b, c, d) ::ease.step_jump_start(t, b, c, d, steps);
::ease.get_step_jump_end <-   @(steps) @(t, b, c, d) ::ease.step_jump_end(t, b, c, d, steps);
::ease.get_step_jump_none <-  @(steps) @(t, b, c, d) ::ease.step_jump_none(t, b, c, d, steps);
::ease.get_step_jump_both <-  @(steps) @(t, b, c, d) ::ease.step_jump_both(t, b, c, d, steps);
