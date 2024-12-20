Return-Path: <live-patching+bounces-936-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 84EAD9F98E6
	for <lists+live-patching@lfdr.de>; Fri, 20 Dec 2024 19:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54F157A121B
	for <lists+live-patching@lfdr.de>; Fri, 20 Dec 2024 17:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA4C224AF0;
	Fri, 20 Dec 2024 17:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="JmPnU7Sr";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="w9swUvbu"
X-Original-To: live-patching@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AEB223E85;
	Fri, 20 Dec 2024 17:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734716863; cv=none; b=MpdVYH1K3vCjVi3mEiV6wJpofY3JA6vHydUNv7QtEi3FQ1KFyFCCGdYho6Ilo8lczXPX2PV0oR3k37FWlS5WHqXO336RhoJmtzp7tn3f9IMiRFlPD+6zvFwTqBYX9J3Q9nXKwhnvvdtbW4qoO+2Hc62XygrAglsExPra2QxcwkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734716863; c=relaxed/simple;
	bh=J9y/1aSSXq1tZhT6PnlsnHYagJsUv+gTorVH8FTXEts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWy3nsVW6Hp9xjNe0Zio37s8037udxUmStLvWttxdSnCggHPE7RBxJY8EyIzRbQet1L9OCprbhdY5P90lWjvdz+45nzcWdroErixKAKKgUpflxOg6bvQT7O79GPJjFWT6L/NSG/3O7S+LeU89ipFs5oA7hJFWJbWbsZy2u20EKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=JmPnU7Sr; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=w9swUvbu; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1734716859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9g6lXeoRfGQe6QicLk0OYONPG5zsQWqzIwVn4RNwwbs=;
	b=JmPnU7SrCtKZo77aBtLgCa1NQyUmL2SR080UfpWQosR6W6mnbJ1Kgf9ZH2dGQm5/Sbp4U8
	lMl7V4vGVA+koLi4+5/L8rqNkltgt7WzXljT3OFDVGM11yRsKd0UusOY1/FZabpESRwEz3
	n8/Hxt2Ey9eaiUAlDCDf8aGrunCqo/UMPxlbRTDWgTa9y6mbsxuGrIzNQVJv5K+iCt/Yb9
	4ig06to82lx9z5I713odCAT/JhKIJ9UofSZuUNn4mxc9NzI57ETFBtxi6BL+VRNQR1AuaN
	WCwU30x2k0zPFTx1BAYQjCSrg+dG5VE3k/eTa+VmP7UNDVlLt9ZimkdIQPL3kQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1734716859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9g6lXeoRfGQe6QicLk0OYONPG5zsQWqzIwVn4RNwwbs=;
	b=w9swUvbuaxMF6akzq9NHRE0kOx5Z/RjiMuatUG+i1zNe0ZUOgdS6jY1IgigUtxXDpmOey6
	V94k4flLzbVHsxAQ==
To: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Daniel Gomez <da.gomez@samsung.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jiri Kosina <jikos@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org
Subject: [PATCH v2 06/28] module: Use RCU in find_module_all().
Date: Fri, 20 Dec 2024 18:41:20 +0100
Message-ID: <20241220174731.514432-7-bigeasy@linutronix.de>
In-Reply-To: <20241220174731.514432-1-bigeasy@linutronix.de>
References: <20241220174731.514432-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The modules list and module::kallsyms can be accessed under RCU
assumption.

Remove module_assert_mutex_or_preempt() from find_module_all() so it can
be used under RCU protection without warnings. Update its callers to use
RCU protection instead of preempt_disable().

Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-kernel@vger.kernel.org
Cc: live-patching@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/module.h      | 2 +-
 kernel/livepatch/core.c     | 4 +---
 kernel/module/kallsyms.c    | 1 +
 kernel/module/main.c        | 6 ++----
 kernel/trace/trace_kprobe.c | 9 +++------
 5 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 94acbacdcdf18..5c1f7ea76c8cb 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -663,7 +663,7 @@ static inline bool within_module(unsigned long addr, co=
nst struct module *mod)
 	return within_module_init(addr, mod) || within_module_core(addr, mod);
 }
=20
-/* Search for module by name: must be in a RCU-sched critical section. */
+/* Search for module by name: must be in a RCU critical section. */
 struct module *find_module(const char *name);
=20
 extern void __noreturn __module_put_and_kthread_exit(struct module *mod,
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 3c21c31796db0..f8932c63b08e3 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -59,7 +59,7 @@ static void klp_find_object_module(struct klp_object *obj)
 	if (!klp_is_module(obj))
 		return;
=20
-	rcu_read_lock_sched();
+	guard(rcu)();
 	/*
 	 * We do not want to block removal of patched modules and therefore
 	 * we do not take a reference here. The patches are removed by
@@ -75,8 +75,6 @@ static void klp_find_object_module(struct klp_object *obj)
 	 */
 	if (mod && mod->klp_alive)
 		obj->mod =3D mod;
-
-	rcu_read_unlock_sched();
 }
=20
 static bool klp_initialized(void)
diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
index 4eef518204eb5..3cba9f933b24f 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -450,6 +450,7 @@ unsigned long module_kallsyms_lookup_name(const char *n=
ame)
 	unsigned long ret;
=20
 	/* Don't lock: we're in enough trouble already. */
+	guard(rcu)();
 	preempt_disable();
 	ret =3D __module_kallsyms_lookup_name(name);
 	preempt_enable();
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 5cce4a92d7ba3..5aa56ec8e203e 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -374,16 +374,14 @@ bool find_symbol(struct find_symbol_arg *fsa)
 }
=20
 /*
- * Search for module by name: must hold module_mutex (or preempt disabled
- * for read-only access).
+ * Search for module by name: must hold module_mutex (or RCU for read-only
+ * access).
  */
 struct module *find_module_all(const char *name, size_t len,
 			       bool even_unformed)
 {
 	struct module *mod;
=20
-	module_assert_mutex_or_preempt();
-
 	list_for_each_entry_rcu(mod, &modules, list,
 				lockdep_is_held(&module_mutex)) {
 		if (!even_unformed && mod->state =3D=3D MODULE_STATE_UNFORMED)
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 263fac44d3ca3..c7db326f4e88e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -123,9 +123,8 @@ static nokprobe_inline bool trace_kprobe_module_exist(s=
truct trace_kprobe *tk)
 	if (!p)
 		return true;
 	*p =3D '\0';
-	rcu_read_lock_sched();
-	ret =3D !!find_module(tk->symbol);
-	rcu_read_unlock_sched();
+	scoped_guard(rcu)
+		ret =3D !!find_module(tk->symbol);
 	*p =3D ':';
=20
 	return ret;
@@ -800,12 +799,10 @@ static struct module *try_module_get_by_name(const ch=
ar *name)
 {
 	struct module *mod;
=20
-	rcu_read_lock_sched();
+	guard(rcu)();
 	mod =3D find_module(name);
 	if (mod && !try_module_get(mod))
 		mod =3D NULL;
-	rcu_read_unlock_sched();
-
 	return mod;
 }
 #else
--=20
2.45.2


