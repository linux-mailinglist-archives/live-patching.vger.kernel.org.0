Return-Path: <live-patching+bounces-993-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 249B0A11BF6
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:29:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD8091885659
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310403DABF0;
	Wed, 15 Jan 2025 08:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="o/q0YUj/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="o/q0YUj/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623AB28EC9E;
	Wed, 15 Jan 2025 08:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929675; cv=none; b=b2hvZq4ai7QcIc6wuWLkhFnmknlEPkrKjjxqlIng+bb7MDJP7iErjS+VdA/gJkRn71P3aTgcMuZ7S0811Nzfmx3c2bBcLI7d2l7GtLkr0ge24y0nx3iN/gsGwo/ixBpkLml4anfQpFetyeVmbqnflqaa1oVHqCejGzK7Aso8NMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929675; c=relaxed/simple;
	bh=PpDKmn0hdf6mBfTap3LxX4bJm+kS1vWMRUWJugkssxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oI67YO+aKtMOOrhsTo7fne80g+AsvaoKUI+7euInmg7wZBoibGUNMWHkoExi4QC7DVYRNive+VJkzyH1nEQDaKt1BorGR+a55ME5lT125LvfuOu1SKlvc2gPTWiQXJb6tGusZG9Ba/gpORmUD+PQyo+7wfaF17V90L4Xjds+6B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=o/q0YUj/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=o/q0YUj/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id AE2F81F37C;
	Wed, 15 Jan 2025 08:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8aX20gM5aqWvgQjDs7ShfHHgki1yOgBmRAA7bLQJt8w=;
	b=o/q0YUj/MdMF00+8Zw7ydxqxCMLKAgGRUmPgdhJuGg+PMNffHn55qy0sf6IuJYNPwkY844
	GJM+Xf7k692wZwLZXM7A8KLSCIQ2KkVWAkFn1kLl3WOMjJqLZYGhqp8zK6fKRnbRC0AX1h
	3IjGhdZ9UIcY9c5Cdj0be+1iZESHMxE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8aX20gM5aqWvgQjDs7ShfHHgki1yOgBmRAA7bLQJt8w=;
	b=o/q0YUj/MdMF00+8Zw7ydxqxCMLKAgGRUmPgdhJuGg+PMNffHn55qy0sf6IuJYNPwkY844
	GJM+Xf7k692wZwLZXM7A8KLSCIQ2KkVWAkFn1kLl3WOMjJqLZYGhqp8zK6fKRnbRC0AX1h
	3IjGhdZ9UIcY9c5Cdj0be+1iZESHMxE=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 18/19] Documentation/livepatch: Update documentation for state, callbacks, and shadow variables
Date: Wed, 15 Jan 2025 09:24:30 +0100
Message-ID: <20250115082431.5550-19-pmladek@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115082431.5550-1-pmladek@suse.com>
References: <20250115082431.5550-1-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLj3e56pwiuh8u4wxetmhsq5s5)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pathway.suse.cz:helo,suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

This commit updates the livepatch documentation to reflect recent changes
in the behavior of states, callbacks, and shadow variables.

Key changes include:

- Per-state callbacks replace per-object callbacks, invoked only when a
  livepatch introduces or removes a state.
- Shadow variable lifetime is now tied to the corresponding livepatch
  state lifetime.
- The "version" field in `struct klp_state` has been replaced with the
  "block_disable" flag for improved compatibility handling.
- The "data" field has been removed from `struct klp_state`; shadow
  variables are now the recommended way to store state-related data.

This update ensures the documentation accurately describes the current
livepatch functionality.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 Documentation/livepatch/api.rst          |   2 +-
 Documentation/livepatch/callbacks.rst    | 166 ++++++++++--------
 Documentation/livepatch/index.rst        |   4 +-
 Documentation/livepatch/shadow-vars.rst  |  47 ++++-
 Documentation/livepatch/system-state.rst | 208 ++++++++---------------
 5 files changed, 218 insertions(+), 209 deletions(-)

diff --git a/Documentation/livepatch/api.rst b/Documentation/livepatch/api.rst
index 78944b63d74b..9535138bd52d 100644
--- a/Documentation/livepatch/api.rst
+++ b/Documentation/livepatch/api.rst
@@ -27,4 +27,4 @@ Object Types
 ============
 
 .. kernel-doc:: include/linux/livepatch.h
-   :identifiers: klp_patch klp_object klp_func klp_callbacks klp_state
+   :identifiers: klp_patch klp_object klp_func klp_state_callbacks klp_state
diff --git a/Documentation/livepatch/callbacks.rst b/Documentation/livepatch/callbacks.rst
index 914445784ce4..c619e024d92d 100644
--- a/Documentation/livepatch/callbacks.rst
+++ b/Documentation/livepatch/callbacks.rst
@@ -3,9 +3,9 @@
 ======================
 
 Livepatch (un)patch-callbacks provide a mechanism for livepatch modules
-to execute callback functions when a kernel object is (un)patched.  They
-can be considered a **power feature** that **extends livepatching abilities**
-to include:
+to execute callback functions before and after transitioning the system.
+They can be considered a **power feature** that **extends livepatching
+abilities** to include:
 
   - Safe updates to global data
 
@@ -17,105 +17,137 @@ In most cases, (un)patch callbacks will need to be used in conjunction
 with memory barriers and kernel synchronization primitives, like
 mutexes/spinlocks, or even stop_machine(), to avoid concurrency issues.
 
-1. Motivation
-=============
 
-Callbacks differ from existing kernel facilities:
-
-  - Module init/exit code doesn't run when disabling and re-enabling a
-    patch.
-
-  - A module notifier can't stop a to-be-patched module from loading.
-
-Callbacks are part of the klp_object structure and their implementation
-is specific to that klp_object.  Other livepatch objects may or may not
-be patched, irrespective of the target klp_object's current state.
-
-2. Callback types
+1. Callback types
 =================
 
-Callbacks can be registered for the following livepatch actions:
+The pointers to the callbacks are stored in `struct klp_state_callbacks`.
+This structure is bundled into `struct klp_state`. The connection with
+the state helps to maintain the lifetime of the changes made by the callbacks,
+see also Documentation/livepatch/system-state.rst
 
-  * Pre-patch
-                 - before a klp_object is patched
+The `struct klp_state_callbacks` allows to define the following
+callbacks. All of them are optional:
 
-  * Post-patch
-                 - after a klp_object has been patched and is active
-                   across all tasks
+*pre_patch()*
 
-  * Pre-unpatch
-                 - before a klp_object is unpatched (ie, patched code is
-                   active), used to clean up post-patch callback
-                   resources
+  - Called only when the related state is being enabled at the beginning
+    of the transition. This is the only callback with a return value.
+    The livepatch module won't be loaded when it returns an error code.
+
+*post_patch()*
+
+  - Called only when the related state is being enabled at the end
+    of the transition.
+
+*pre_unpatch()*
+
+  - Called only when the related state is being disabled at the beginning
+    of the transition.
+
+*post_patch()*
+
+  - Called only when the related state is being disabled at the end
+    of the transition.
+
+*shadow_dtor()*
+
+  - Destruct callback which is used for releasing obsolete shadow variables
+    using the same *@id*. They are freed right after calling *post_unpatch()*
+    callback.
 
-  * Post-unpatch
-                 - after a klp_object has been patched, all code has
-                   been restored and no tasks are running patched code,
-                   used to cleanup pre-patch callback resources
 
 3. How it works
 ===============
 
 Each callback is optional, omitting one does not preclude specifying any
 other.  However, the livepatching core executes the handlers in
-symmetry: pre-patch callbacks have a post-unpatch counterpart and
-post-patch callbacks have a pre-unpatch counterpart.  An unpatch
+symmetry: *pre_patch()* callbacks have a *post_unpatch()* counterpart and
+*post_patch()* callbacks have a *pre_unpatch()* counterpart.  An unpatch
 callback will only be executed if its corresponding patch callback was
-executed.  Typical use cases pair a patch handler that acquires and
+executed. Typical use cases pair a patch handler that acquires and
 configures resources with an unpatch handler tears down and releases
 those same resources.
 
-A callback is only executed if its host klp_object is loaded.  For
-in-kernel vmlinux targets, this means that callbacks will always execute
-when a livepatch is enabled/disabled.  For patch target kernel modules,
-callbacks will only execute if the target module is loaded.  When a
-module target is (un)loaded, its callbacks will execute only if the
-livepatch module is enabled.
+A callback is only executed when the related livepatch introduces or
+removes the state. Specifically, the *pre_patch()* and *post_patch()*
+callbacks are not called if any already enabled livepatch supports
+the given state, regardless of whether atomic replacement is used or
+livepatches are installed in parallel. Similarly, the *pre_unpatch()*
+and *post_unpatch()* callbacks are called during atomic replacement
+only for states from currently enabled livepatches that will no longer
+be supported by the new livepatch.
 
-The pre-patch callback, if specified, is expected to return a status
+The *pre_patch()* callback, if specified, is expected to return a status
 code (0 for success, -ERRNO on error).  An error status code indicates
-to the livepatching core that patching of the current klp_object is not
-safe and to stop the current patching request.  (When no pre-patch
+to the livepatching core that the requested state could not be enabled
+a safe way and to stop the current patching request. (When no *pre_patch()*
 callback is provided, the transition is assumed to be safe.)  If a
-pre-patch callback returns failure, the kernel's module loader will:
+*pre_patch()* callback returns failure, the kernel's module loader will
+refuse to load the livepatch.
 
-  - Refuse to load a livepatch, if the livepatch is loaded after
-    targeted code.
+If a patch transition is reversed, no *pre_unpatch()* handlers will be run.
+This follows the previously mentioned symmetry -- *pre_unpatch() callbacks
+will only occur if their corresponding *post_patch()* callback executed.
 
-    or:
 
-  - Refuse to load a module, if the livepatch was already successfully
-    loaded.
+4. Expected usage
+=================
 
-No post-patch, pre-unpatch, or post-unpatch callbacks will be executed
-for a given klp_object if the object failed to patch, due to a failed
-pre_patch callback or for any other reason.
+The expected role of each callback is as follows:
 
-If a patch transition is reversed, no pre-unpatch handlers will be run
-(this follows the previously mentioned symmetry -- pre-unpatch callbacks
-will only occur if their corresponding post-patch callback executed).
+*pre_patch()*
+
+  - Allocate memory, using a shadow variable, when necessary. The allocation
+    might fail and *pre_patch()* is the only callback that could stop loading
+    of the livepatch.
+
+  - Do any other preparatory action that is needed by the new code even
+    before the transition gets finished. For example, initialize
+    the allocated memory.
+
+    The system state itself is typically modified in *post_patch()*
+    when the entire system is able to handle it.
+
+  - Clean up its own mess in case of error. It might be done by a custom
+    code or by calling *post_unpatch()* explicitly.
+
+*post_patch()*
+
+  - Do the actual system state modification. Eventually allow
+    the new code to use it.
+
+*pre_unpatch()*
+
+  - Prevent the code, added by the livepatch, relying on the system
+    state change.
+
+  - Revert the system state modification..
+
+*post_unpatch()*
+
+  - Remove any not longer needed setting or data. Note that all shadow
+    variables using the same *@id* are freed automatically.
 
-If the object did successfully patch, but the patch transition never
-started for some reason (e.g., if another object failed to patch),
-only the post-unpatch callback will be called.
 
 4. Use cases
 ============
 
 Sample livepatch modules demonstrating the callback API can be found in
-samples/livepatch/ directory.  These samples were modified for use in
-kselftests and can be found in the lib/livepatch directory.
+samples/livepatch/ directory. These samples were modified for use in
+kselftests and can be found in the tools/testing/selftests/livepatch/
+directory.
 
 Global data update
 ------------------
 
-A pre-patch callback can be useful to update a global variable.  For
+A *pre_patch()* callback can be useful to update a global variable.  For
 example, commit 75ff39ccc1bd ("tcp: make challenge acks less predictable")
 changes a global sysctl, as well as patches the tcp_send_challenge_ack()
 function.
 
 In this case, if we're being super paranoid, it might make sense to
-patch the data *after* patching is complete with a post-patch callback,
+patch the data *after* patching is complete with a *post_patch()* callback,
 so that tcp_send_challenge_ack() could first be changed to read
 sysctl_tcp_challenge_ack_limit with READ_ONCE.
 
@@ -123,11 +155,11 @@ __init and probe function patches support
 -----------------------------------------
 
 Although __init and probe functions are not directly livepatch-able, it
-may be possible to implement similar updates via pre/post-patch
+may be possible to implement similar updates via *pre_patch()*/*post_patch()*
 callbacks.
 
-The commit 48900cb6af42 ("virtio-net: drop NETIF_F_FRAGLIST") change the way that
-virtnet_probe() initialized its driver's net_device features.  A
-pre/post-patch callback could iterate over all such devices, making a
-similar change to their hw_features value.  (Client functions of the
+The commit 48900cb6af42 ("virtio-net: drop NETIF_F_FRAGLIST") change the way
+that virtnet_probe() initialized its driver's net_device features.  A
+*pre_patch()*/*post_patch()* callback could iterate over all such devices,
+making a similar change to their hw_features value.  (Client functions of the
 value may need to be updated accordingly.)
diff --git a/Documentation/livepatch/index.rst b/Documentation/livepatch/index.rst
index cebf1c71d4a5..8f799c0b85f3 100644
--- a/Documentation/livepatch/index.rst
+++ b/Documentation/livepatch/index.rst
@@ -8,11 +8,11 @@ Kernel Livepatching
     :maxdepth: 1
 
     livepatch
-    callbacks
     cumulative-patches
     module-elf-format
-    shadow-vars
     system-state
+    callbacks
+    shadow-vars
     reliable-stacktrace
     api
 
diff --git a/Documentation/livepatch/shadow-vars.rst b/Documentation/livepatch/shadow-vars.rst
index 7a7098bfb5c8..702d38cd7571 100644
--- a/Documentation/livepatch/shadow-vars.rst
+++ b/Documentation/livepatch/shadow-vars.rst
@@ -42,7 +42,7 @@ They also allow to call a custom constructor function when a non-zero
 value is needed. Callers should provide whatever mutual exclusion
 is required.
 
-Note that the constructor is called under klp_shadow_lock spinlock. It allows
+Note that the constructor is called under *klp_shadow_lock* spinlock. It allows
 to do actions that can be done only once when a new variable is allocated.
 
 * klp_shadow_get() - retrieve a shadow variable data pointer
@@ -90,8 +90,49 @@ to do actions that can be done only once when a new variable is allocated.
       - call destructor function if defined
       - free shadow variable
 
+2. Lifetime
+===========
 
-2. Use cases
+Shadow variables are allocated only when there is code that can use them.
+This typically occurs when the entire system is livepatched and all
+processes are able to hanle them.
+
+To ensure proper management, shadow variables are associated with a specific
+system state using a unique identifier (*id*). This association governs
+their lifecycle:
+
+ - The *pre_patch()* callback can be used to allocate the shadow variable.
+
+ - The *post_patch()* callback can be used to enable the usage of the shadow
+   variable system wide.
+
+ - The *pre_unpatch()* callback can be used to disable the usage of the shadow
+   variable system wide.
+
+ - The *post_unpatch()* callback can be used for some clean up before
+   the obsolete shadow variables are freed.
+
+ - All instances of the shadow variable are automatically freed when their
+   associated state is removed. This occurs when:
+
+   - The livepatch is disabled.
+
+   - A new cumulative livepatch is applied that no longer supports
+     the associated state.
+
+**Important Notes:**
+
+  - **Persistence across Cumulative Livepatches:** Shadow variables are
+	preserved when a livepatch is replaced by another cumulative
+	livepatch that still supports the associated state. This ensures
+	continuity across updates.
+
+  - **Automatic Freeing:** There is no need to explicitly free shadow
+	variables. The livepatching mechanism handles their freeing
+	automatically after the associated state has been removed.
+
+
+3. Use cases
 ============
 
 (See the example shadow variable livepatch modules in samples/livepatch/
@@ -211,7 +252,7 @@ doesn't matter what data value the shadow variable holds, its existence
 suggests how to handle the parent object.
 
 
-3. References
+4. References
 =============
 
 * https://github.com/dynup/kpatch
diff --git a/Documentation/livepatch/system-state.rst b/Documentation/livepatch/system-state.rst
index 7a3935fd812b..ced7267d42ca 100644
--- a/Documentation/livepatch/system-state.rst
+++ b/Documentation/livepatch/system-state.rst
@@ -2,166 +2,102 @@
 System State Changes
 ====================
 
-Some users are really reluctant to reboot a system. This brings the need
-to provide more livepatches and maintain some compatibility between them.
+Livepatches provide a way to update running systems without requiring a reboot.
+However, managing compatibility between multiple livepatches can be challenging,
+especially when they introduce changes that affect system behavior or memory
+management.
 
-Maintaining more livepatches is much easier with cumulative livepatches.
-Each new livepatch completely replaces any older one. It can keep,
-add, and even remove fixes. And it is typically safe to replace any version
-of the livepatch with any other one thanks to the atomic replace feature.
+Cumulative livepatches simplify this process by completely replacing older
+versions with each update. This allows for the addition, modification, and
+removal of fixes while maintaining compatibility through atomic replacement.
+However, challenges can arise with callbacks and shadow variables.
 
-The problems might come with shadow variables and callbacks. They might
-change the system behavior or state so that it is no longer safe to
-go back and use an older livepatch or the original kernel code. Also
-any new livepatch must be able to detect what changes have already been
-done by the already installed livepatches.
+Callbacks are functions that can alter system behavior when a livepatch is
+applied. Shadow variables associate additional memory with existing data
+structures. These modifications need to be reverted when a livepatch is
+disabled or replaced with a livepatch not supporting the same state to ensure
+system stability.
 
-This is where the livepatch system state tracking gets useful. It
-allows to:
+Unused shadow variables can lead to memory leaks and synchronization issues.
+If a livepatch is replaced with one that doesn't maintain these variables,
+their content may become outdated, potentially causing problems if a future
+livepatch attempts to use them again.
 
-  - store data needed to manipulate and restore the system state
+To address these challenges, the livepatch system employs state tracking.
+This mechanism offers several benefits:
 
-  - define compatibility between livepatches using a change id
-    and version
+  - Callbacks associated with a specific state are called only when that state
+    is introduced or removed.
+
+  - Shadow variables associated with a state are automatically freed when that
+    state is no longer supported.
+
+  - When a livepatch is atomically replaced with another supporting the same
+    state, associated callbacks are not called, and shadow variables are not
+    freed, ensuring continuity.
+
+  - State tracking can prevent disabling a livepatch or proceeding with
+    an atomic replacement if the current livepatch cannot revert the state.
+    This safeguard is crucial when reverting modifications would be too complex
+    or risky.
+
+This approach ensures that changes introduced by livepatches are managed
+effectively, minimizing the risk of conflicts and maintaining system stability.
 
 
 1. Livepatch system state API
 =============================
 
-The state of the system might get modified either by several livepatch callbacks
-or by the newly used code. Also it must be possible to find changes done by
-already installed livepatches.
+Any livepatch might support an arbitrary number of states. A particular state
+represents either a change made by the associated callbacks and/or shadow
+variables using the same *@id*.
 
-Each modified state is described by struct klp_state, see
-include/linux/livepatch.h.
+The states are described by an array of `struct klp_state`, which is usually
+statically defined. The `struct klp_state` is defined in
+`include/linux/livepatch.h` and provides the following fields:
 
-Each livepatch defines an array of struct klp_states. They mention
-all states that the livepatch modifies.
+*id*
 
-The livepatch author must define the following two fields for each
-struct klp_state:
+  - A unique, non-zero number that identifies the state.
 
-  - *id*
+*is_shadow*
 
-    - Non-zero number used to identify the affected system state.
+  - A boolean value indicating whether the state is associated with a shadow
+    variable using the same *@id*. These are automatically freed when
+    the state is no longer supported after the livepatch transition.
+    See also Documentation/livepatch/shadow-vars.rst.
 
-  - *version*
+*block_disable*
 
-    - Number describing the variant of the system state change that
-      is supported by the given livepatch.
+  - A boolean value that, when set, prevents transitions that would disable
+    the state. In other words, it indicates that reverting the state is
+    not supported.
 
-The state can be manipulated using two functions:
+*callbacks*
 
-  - klp_get_state()
+  - A `struct klp_state_callbacks` containing (optional) pointers to
+    callbacks. These are invoked when a livepatch transition introduces
+    or removes the state. See Documentation/livepatch/callbacks.rst
+    for more information.
 
-    - Get struct klp_state associated with the given livepatch
-      and state id.
-
-  - klp_get_prev_state()
-
-    - Get struct klp_state associated with the given feature id and
-      already installed livepatches.
 
 2. Livepatch compatibility
 ==========================
 
-The system state version is used to prevent loading incompatible livepatches.
-The check is done when the livepatch is enabled. The rules are:
+The *@block_disable* state flag is used when a livepatch modifies the system
+state in a way that cannot be easily or safely reverted. This might be due
+to the complexity of the changes or the risk of instability during
+the reversion process.
 
-  - Any completely new system state modification is allowed.
+Preventing the disable operation can also be a strategic decision to save
+development costs, as implementing and testing the *pre_unpatch()* and
+*post_unpatch()* callbacks can significantly increase resource requirements.
 
-  - System state modifications with the same or higher version are allowed
-    for already modified system states.
+This flag prevents the livepatch from being disabled and also prevents atomic
+replacement with a livepatch that does not support this state. These
+livepatches are considered incompatible.
 
-  - Cumulative livepatches must handle all system state modifications from
-    already installed livepatches.
-
-  - Non-cumulative livepatches are allowed to touch already modified
-    system states.
-
-3. Supported scenarios
-======================
-
-Livepatches have their life-cycle and the same is true for the system
-state changes. Every compatible livepatch has to support the following
-scenarios:
-
-  - Modify the system state when the livepatch gets enabled and the state
-    has not been already modified by a livepatches that are being
-    replaced.
-
-  - Take over or update the system state modification when is has already
-    been done by a livepatch that is being replaced.
-
-  - Restore the original state when the livepatch is disabled.
-
-  - Restore the previous state when the transition is reverted.
-    It might be the original system state or the state modification
-    done by livepatches that were being replaced.
-
-  - Remove any already made changes when error occurs and the livepatch
-    cannot get enabled.
-
-4. Expected usage
-=================
-
-System states are usually modified by livepatch callbacks. The expected
-role of each callback is as follows:
-
-*pre_patch()*
-
-  - Allocate *state->data* when necessary. The allocation might fail
-    and *pre_patch()* is the only callback that could stop loading
-    of the livepatch. The allocation is not needed when the data
-    are already provided by previously installed livepatches.
-
-  - Do any other preparatory action that is needed by
-    the new code even before the transition gets finished.
-    For example, initialize *state->data*.
-
-    The system state itself is typically modified in *post_patch()*
-    when the entire system is able to handle it.
-
-  - Clean up its own mess in case of error. It might be done by a custom
-    code or by calling *post_unpatch()* explicitly.
-
-*post_patch()*
-
-  - Copy *state->data* from the previous livepatch when they are
-    compatible.
-
-  - Do the actual system state modification. Eventually allow
-    the new code to use it.
-
-  - Make sure that *state->data* has all necessary information.
-
-  - Free *state->data* from replaces livepatches when they are
-    not longer needed.
-
-*pre_unpatch()*
-
-  - Prevent the code, added by the livepatch, relying on the system
-    state change.
-
-  - Revert the system state modification..
-
-*post_unpatch()*
-
-  - Distinguish transition reverse and livepatch disabling by
-    checking *klp_get_prev_state()*.
-
-  - In case of transition reverse, restore the previous system
-    state. It might mean doing nothing.
-
-  - Remove any not longer needed setting or data.
-
-.. note::
-
-   *pre_unpatch()* typically does symmetric operations to *post_patch()*.
-   Except that it is called only when the livepatch is being disabled.
-   Therefore it does not need to care about any previously installed
-   livepatch.
-
-   *post_unpatch()* typically does symmetric operations to *pre_patch()*.
-   It might be called also during the transition reverse. Therefore it
-   has to handle the state of the previously installed livepatches.
+The kernel provides no mechanism for detecting incompatibility when atomic
+replacement is not used. Livepatch authors must manage incompatibility in
+other ways, such as through dependencies between the packages that install
+the livepatch modules.
-- 
2.47.1


