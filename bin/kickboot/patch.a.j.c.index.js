--- app/javascript/controllers/index.js	2024-05-06 03:50:18.698462269 +0000
+++ app/javascript/controllers/index.js.new	2024-05-06 03:54:51.578985777 +0000
@@ -1,10 +1,10 @@
 // Import and register all your controllers from the importmap under controllers/*
 
-import { application } from "controllers/application"
+import { application } from "./application"
 
 // Eager load all controllers defined in the import map under controllers/**/*_controller
-import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
-eagerLoadControllersFrom("controllers", application)
+// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
+// eagerLoadControllersFrom("controllers", application)
 
 // Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
 // import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
