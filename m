Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2493C22851C
	for <lists+live-patching@lfdr.de>; Tue, 21 Jul 2020 18:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgGUQOZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jul 2020 12:14:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29453 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730251AbgGUQOZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jul 2020 12:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595348062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/oSIHpGUhlY8K1S7k5DvGEYfINRIBQrfv/EOVzygOQY=;
        b=aZmKmWpMPCXdcdqKdING89O+/IWfcq+oKjYtxkl0p+47YLgrxgyZ4iCj9wIqz8Z178SOp8
        Vm+jyGROSipwip5mcxFzCnGZaVWFsQ3keZSE0eGucb4GNe+8N2dxZF1C6lkGFYPiri8Dl+
        hZtU610T5iuXAlopoXSAhUnjr23cNJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-aSIsS4ueMAmPPu2gLQo19A-1; Tue, 21 Jul 2020 12:14:17 -0400
X-MC-Unique: aSIsS4ueMAmPPu2gLQo19A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B835C1DEB;
        Tue, 21 Jul 2020 16:14:16 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-114-255.rdu2.redhat.com [10.10.114.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 534C08731E;
        Tue, 21 Jul 2020 16:14:16 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] docs/livepatch: Add new compiler considerations doc
Date:   Tue, 21 Jul 2020 12:14:06 -0400
Message-Id: <20200721161407.26806-2-joe.lawrence@redhat.com>
In-Reply-To: <20200721161407.26806-1-joe.lawrence@redhat.com>
References: <20200721161407.26806-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Compiler optimizations can have serious implications on livepatching.
Create a document that outlines common optimization patterns and safe
ways to livepatch them.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 .../livepatch/compiler-considerations.rst     | 220 ++++++++++++++++++
 Documentation/livepatch/index.rst             |   1 +
 Documentation/livepatch/livepatch.rst         |   7 +
 3 files changed, 228 insertions(+)
 create mode 100644 Documentation/livepatch/compiler-considerations.rst

diff --git a/Documentation/livepatch/compiler-considerations.rst b/Documentation/livepatch/compiler-considerations.rst
new file mode 100644
index 000000000000..23b9cc01bb9c
--- /dev/null
+++ b/Documentation/livepatch/compiler-considerations.rst
@@ -0,0 +1,220 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+=======================
+Compiler considerations
+=======================
+
+Creating livepatch modules may seem as straightforward as updating a
+few functions in source code and registering them with the livepatch API.
+This idealized method may produce functional livepatch modules in some
+cases.
+
+.. warning::
+
+   A safe and accurate livepatch **must** take into account compiler
+   optimizations and their effect on the binary code that is executed and
+   ultimately livepatched.
+
+Examples
+========
+
+Interprocedural optimization (IPA)
+----------------------------------
+
+Function inlining is probably the most common compiler optimization that
+affects livepatching.  In a simple example, inlining transforms the original
+code::
+
+	foo() { ... [ foo implementation ] ... }
+
+	bar() { ...  foo() ...  }
+
+to::
+
+	bar() { ...  [ foo implementation ] ...  }
+
+Inlining is comparable to macro expansion, however the compiler may inline
+cases which it determines worthwhile (while preserving original call/return
+semantics in others) or even partially inline pieces of functions (see cold
+functions in GCC function suffixes section below).
+
+To safely livepatch ``foo()`` from the previous example, all of its callers
+need to be taken into consideration.  For those callers that the compiler had
+inlined ``foo()``, a livepatch should include a new version of the calling
+function such that it:
+
+  1. Calls a new, patched version of the inlined function, or
+  2. Provides an updated version of the caller that contains its own inlined
+     and updated version of the inlined function
+
+Other interesting IPA examples include:
+
+- *IPA-SRA*: removal of unused parameters, replace parameters passed by
+  referenced by parameters passed by value.  This optimization basically
+  violates ABI.
+
+  .. note::
+     GCC changes the name of function.  See GCC function suffixes
+     section below.
+
+- *IPA-CP*: find values passed to functions are constants and then optimizes
+  accordingly Several clones of a function are possible if a set is limited.
+
+  .. note::
+     GCC changes the name of function.  See GCC function suffixes
+     section below.
+
+- *IPA-PURE-CONST*: discover which functions are pure or constant.  GCC can
+  eliminate calls to such functions, memory accesses can be removed etc.
+
+- *IPA-ICF*: perform identical code folding for functions and read-only
+  variables.  Replaces a function with an equivalent one.
+
+- *IPA-RA*: optimize saving and restoring registers if the compiler considers
+  it safe.
+
+- *Dead code elimination*: omit unused code paths from the resulting binary.
+
+GCC function suffixes
+---------------------
+
+GCC may rename original, copied, and cloned functions depending upon the
+optimizations applied.  Here is a partial list of name suffixes that the
+compiler may apply to kernel functions:
+
+- *Cold subfunctions* : ``.code`` or ``.cold.<N>`` : parts of functions
+  (subfunctions) determined by attribute or optimization to be unlikely
+  executed.
+
+  For example, the unlikely bits of ``irq_do_set_affinity()`` may be moved
+  out to subfunction ``irq_do_set_affinity.cold.49()``.  Starting with GCC 9,
+  the numbered suffix has been removed.  So in the previous example, the cold
+  subfunction is simply ``irq_do_set_affinity.cold()``.
+
+- *Partial inlining* : ``.part.<N>`` : parts of functions when split from
+  their original function body, improves overall inlining decisions.
+
+  The ``cdev_put()`` function provides an interesting example of a partial
+  clone.  GCC builds the source function::
+
+  	void cdev_put(struct cdev *p)
+  	{
+  		if (p) {
+  			struct module *owner = p->owner;
+  			kobject_put(&p->kobj);
+  			module_put(owner);
+  		}
+  	}
+
+  into two functions, the conditional test in ``cdev_put()`` and the
+  ``kobject_put()`` and ``module_put()`` calls in ``cdev_put.part.0()``::
+
+    <cdev_put>:
+           e8 bb 60 73 00          callq  ffffffff81a01a10 <__fentry__>
+           48 85 ff                test   %rdi,%rdi
+           74 05                   je     ffffffff812cb95f <cdev_put+0xf>
+           e9 a1 fc ff ff          jmpq   ffffffff812cb600 <cdev_put.part.0>
+           c3                      retq
+
+    <cdev_put.part.0>:
+           e8 0b 64 73 00          callq  ffffffff81a01a10 <__fentry__>
+           53                      push   %rbx
+           48 8b 5f 60             mov    0x60(%rdi),%rbx
+           e8 a1 54 5a 00          callq  ffffffff81870ab0 <kobject_put>
+           48 89 df                mov    %rbx,%rdi
+           5b                      pop    %rbx
+           e9 b8 5c e8 ff          jmpq   ffffffff811512d0 <module_put>
+           0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
+           00
+
+  Some ``cdev_put()`` callers may take advantage of this function splitting
+  to inline one part or another.  Others may also directly call the partial
+  clone.
+
+- *Constant propagation* : ``.constprop.<N>`` : function copies to enable
+  constant propagation when conflicting arguments exist.
+
+  For example, consider ``cpumask_weight()`` and its copies for
+  ``cpumask_weight(cpu_possible_mask)`` and
+  ``cpumask_weight(__cpu_online_mask)``.  Note how the ``.constprop`` copies
+  implicitly assign the function parameter::
+
+    <cpumask_weight>:
+           8b 35 1e 7d 3e 01       mov    0x13e7d1e(%rip),%esi
+           e9 55 6e 3f 00          jmpq   ffffffff8141d2b0 <__bitmap_weight>
+
+    <cpumask_weight.constprop.28>:
+           8b 35 79 cf 1c 01       mov    0x11ccf79(%rip),%esi
+           48 c7 c7 80 db 40 82    mov    $0xffffffff8240db80,%rdi
+                             R_X86_64_32S  __cpu_possible_mask
+           e9 a9 c0 1d 00          jmpq   ffffffff8141d2b0 <__bitmap_weight>
+
+    <cpumask_weight.constprop.108>:
+           8b 35 de 69 32 01       mov    0x13269de(%rip),%esi
+           48 c7 c7 80 d7 40 82    mov    $0xffffffff8240d780,%rdi
+                             R_X86_64_32S  __cpu_online_mask
+           e9 0e 5b 33 00          jmpq   ffffffff8141d2b0 <__bitmap_weight>
+
+- *IPA-SRA* : ``.isra.0`` : TODO
+
+
+Coping with optimizations
+=========================
+
+A livepatch author must take care to consider the consequences of
+interprocedural optimizations that create function clones, ABI changes,
+splitting, etc. A small change to one function may cascade through the
+function call-chain, updating dozens more. A safe livepatch needs to be
+fully compatible with all callers.
+
+kpatch-build
+------------
+
+Given an input .patch file, kpatch-build performs a binary comparison of
+unpatched and patched kernel trees.  This automates the detection of changes
+in compiler-generated code, optimizations included.  It is still important,
+however, for a kpatch developer to learn about compiler transformations in
+order to understand and control the set of modified functions.
+
+kgraft-analysis-tool
+--------------------
+
+With the -fdump-ipa-clones flag, GCC will dump IPA clones that were created
+by all inter-procedural optimizations in ``<source>.000i.ipa-clones`` files.
+
+kgraft-analysis-tool pretty-prints those IPA cloning decisions.  The full
+list of affected functions provides additional updates that the source-based
+livepatch author may need to consider.  For example, for the function
+``scatterwalk_unmap()``:
+
+::
+
+  $ ./kgraft-ipa-analysis.py --symbol=scatterwalk_unmap aesni-intel_glue.i.000i.ipa-clones
+  Function: scatterwalk_unmap/2930 (include/crypto/scatterwalk.h:81:60)
+    isra: scatterwalk_unmap.isra.2/3142 (include/crypto/scatterwalk.h:81:60)
+      inlining to: helper_rfc4106_decrypt/3007 (arch/x86/crypto/aesni-intel_glue.c:1016:12)
+      inlining to: helper_rfc4106_decrypt/3007 (arch/x86/crypto/aesni-intel_glue.c:1016:12)
+      inlining to: helper_rfc4106_encrypt/3006 (arch/x86/crypto/aesni-intel_glue.c:939:12)
+
+    Affected functions: 3
+      scatterwalk_unmap.isra.2/3142 (include/crypto/scatterwalk.h:81:60)
+      helper_rfc4106_decrypt/3007 (arch/x86/crypto/aesni-intel_glue.c:1016:12)
+      helper_rfc4106_encrypt/3006 (arch/x86/crypto/aesni-intel_glue.c:939:12)
+
+kgraft-ipa-analysis notes that it was inlined into function
+``helper_rfc4106_decrypt()`` and was renamed with a ``.isra.<N>`` IPA
+optimization suffix.  A safe livepatch that updates ``scatterwalk_unmap()``
+will of course need to consider updating these functions as well.
+
+References
+==========
+
+[1] GCC optimizations and their impact on livepatch
+    Miroslav Benes, 2016 Linux Plumbers Conferences
+    http://www.linuxplumbersconf.net/2016/ocw//system/presentations/3573/original/pres_gcc.pdf
+
+[2] kpatch-build
+    https://github.com/dynup/kpatch
+
+[3] kgraft-analysis-tool
+    https://github.com/marxin/kgraft-analysis-tool
diff --git a/Documentation/livepatch/index.rst b/Documentation/livepatch/index.rst
index 525944063be7..7fd8a94498a0 100644
--- a/Documentation/livepatch/index.rst
+++ b/Documentation/livepatch/index.rst
@@ -8,6 +8,7 @@ Kernel Livepatching
     :maxdepth: 1
 
     livepatch
+    compiler-considerations
     callbacks
     cumulative-patches
     module-elf-format
diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
index c2c598c4ead8..b6d5beb16a00 100644
--- a/Documentation/livepatch/livepatch.rst
+++ b/Documentation/livepatch/livepatch.rst
@@ -432,6 +432,13 @@ The current Livepatch implementation has several limitations:
     by "notrace".
 
 
+  - Compiler optimizations can complicate livepatching.
+
+    Optimizations may inline, clone and even change a function's calling
+    convention interface. Please consult the
+    Documentation/livepatching/compiler-considerations.rst file before
+    creating any livepatch modules.
+
 
   - Livepatch works reliably only when the dynamic ftrace is located at
     the very beginning of the function.
-- 
2.21.3

