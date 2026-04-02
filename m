Return-Path: <live-patching+bounces-2275-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EEDCGmQ5zmmAmAYAu9opvQ
	(envelope-from <live-patching+bounces-2275-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 11:39:48 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64A6E38712B
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 11:39:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 184763070AEC
	for <lists+live-patching@lfdr.de>; Thu,  2 Apr 2026 09:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447AF3921E0;
	Thu,  2 Apr 2026 09:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F03xzT2Z"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A12B386C1C
	for <live-patching@vger.kernel.org>; Thu,  2 Apr 2026 09:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775122000; cv=none; b=I6XNl8CnyLUMjRN7bcrO6kifxpLrPUCWq6YrBjWQedapEU8tYhtLaj+cQ1gW6q7+GzYEPfBqQUbefCA8M/RL54hgpk+68GkVSP4WXNwaqNPp05Cgff0OJTCrApQx7TBY4PGWODQd4Awfa5LaNS20M6l+SWwNiw8bS7INYpUmoWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775122000; c=relaxed/simple;
	bh=ej1QnT2eQaleNxlMgrs1gAsCPfQsz0m2v5hxcKmj2rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMkj9QPIWCvMF5Evd/lEADkAc5S9X9DrMuZY3ujFPTvCmvo4TBlMKXHwvE0EKKGcytHanvCJhpq7MqimiqXnTLJNUQDJh3BdazAckzpBVD5KeznUD12BVwXjv2kE0RHuYAdDcoVRMvHhmlXIjBnmu2c+VrhUmtK6Uy8BPR9wFNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F03xzT2Z; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35c238f1063so393813a91.1
        for <live-patching@vger.kernel.org>; Thu, 02 Apr 2026 02:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775121989; x=1775726789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SG/JGJww/E4NFDS2ytnaNRFZJ2JnJt66danprE2gSxY=;
        b=F03xzT2ZtDi9zfHTPvbpiGmxCiZqaXs2IInz/hYR6jKRDhxsREf3+kiceC4XG3YfPI
         wALlAiGtb8sC4pEAEGeOVl9Zpz71P07gmCrD0e5khcTptydUKVcTxGDw2SuXnmhBTUyA
         a9B+g14Ggcn3bLyk/SrUZSlGyf7AJnqAYCMPIKvQHMzYFpNnLv9oL8lVaoIw6hzZvqDV
         acV2y1bGXFO991EZbfJj78HwgTzg2ZFsBc6Ia8Xx59HSBWJPrMk6kS+loq9i1cWhOQR7
         0yPnWXnbHTt8m8j1P9qA85GCM4cETPCXFd7Am48Sl4XU7TNictnA/RmJSi3jnC0T+jQ1
         AhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775121989; x=1775726789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SG/JGJww/E4NFDS2ytnaNRFZJ2JnJt66danprE2gSxY=;
        b=ivn9OiL7k/Hd/KqiXZjN0RIangjmoyDA46s1X1sA1ZQO0B47wASY6HIbrJMGly08Oe
         X/vO0jDjizmkL4f21xOhWuheQraUcXO29u9CrHVXRJ/FGFs0rhdYC084avlYNk3c4DKR
         LzAV+Wgp7zzC9dUjJBiKojiiTO6Db0CxS7BQ+Jky+PjWPKV921pplN1uzUAIoJzzDybN
         asbVQKsSYX11Z/s+E8qBDM8s4u/nYTNUcdfW0ZY22YvtiPo2S7/WOoc8Z6fJYx4Uf6CI
         68HUo5n8TRdEYIipLq03mOCe5RyJDUXVteJiuLua+34vMwq+oW3XtCqXkESUqibDE+vh
         gTIg==
X-Gm-Message-State: AOJu0YzJUkhib9MPFu0xC648OI7k7u0Lqxgkp7aQQqSN8jr0+14YvXfD
	j5Dxm/IeZ13nLdI+pCngnGGdTyEbjsrosgvfVDcDwFXQlg+UuP4j1aqj
X-Gm-Gg: AeBDiet87JNLkpVVwyf9N1iKha01YoyBNrnrr8AFmevbzaZRD0qn+KLQ4yKCProCzIX
	i0sYbA710n9umd8Zup3pMlP2+xk927MokHelJFIAT+fqfxByJYnoCl3cPswFJazvXFi6Yksow6u
	ugtbAVdZB5AQCgAuoFvaxNbhN8wG3yVEKy7o+lAFwApF1KsQxIQfJyVUbADrLeJWdRujI2TlKTd
	32LsVPArYjNtDBJq+88sDEvdyAbexEF28V0E2k43UnBlmY14/9A9dSaLZDIuoCFvb37yja6M9RL
	d5mNBlSp0y7bzInnCnulSOAk3nZKPGdRXwYCYkwhKYRAWg3Wv6CgrgIm2zX2fxGgW10yRsTvv1w
	p7vqHYlOHJ2UPOEvBbyufO48BSp9PIQD+REFoeADDPPgJc3EFFYSgmbIwHCHQsLc+sMWDNynF3f
	PvMeiodPW3cFhae1tAnmYiiKcm4dI5s6j4dgl7MljqXT/Q
X-Received: by 2002:a17:90b:3a8b:b0:35d:93ff:2859 with SMTP id 98e67ed59e1d1-35dc6f92e1amr6324093a91.22.1775121989484;
        Thu, 02 Apr 2026 02:26:29 -0700 (PDT)
Received: from yafangs-Air ([2409:891f:1aa0:8613:19f3:7bee:2e41:149e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dd35f50e9sm2227645a91.6.2026.04.02.02.26.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Apr 2026 02:26:29 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	kpsingh@kernel.org,
	mattbobrowski@google.com,
	song@kernel.org,
	jolsa@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	memxor@gmail.com,
	yonghong.song@linux.dev
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH 1/4] trace: Simplify kprobe overridable function check
Date: Thu,  2 Apr 2026 17:26:04 +0800
Message-ID: <20260402092607.96430-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260402092607.96430-1-laoar.shao@gmail.com>
References: <20260402092607.96430-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2275-lists,live-patching=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 64A6E38712B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Simplify the logic for checking overridable kprobe functions by removing
redundant code.

No functional change.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/trace/bpf_trace.c    | 13 ++++++---
 kernel/trace/trace_kprobe.c | 40 +++++----------------------
 kernel/trace/trace_probe.h  | 54 ++++++++++++++++++++++++++-----------
 3 files changed, 54 insertions(+), 53 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 0b040a417442..c901ace836cb 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1929,10 +1929,15 @@ int perf_event_attach_bpf_prog(struct perf_event *event,
 	 * Kprobe override only works if they are on the function entry,
 	 * and only if they are on the opt-in list.
 	 */
-	if (prog->kprobe_override &&
-	    (!trace_kprobe_on_func_entry(event->tp_event) ||
-	     !trace_kprobe_error_injectable(event->tp_event)))
-		return -EINVAL;
+	if (prog->kprobe_override) {
+		struct trace_kprobe *tp = trace_kprobe_primary_from_call(event->tp_event);
+
+		if (!tp)
+			return -EINVAL;
+		if (!trace_kprobe_on_func_entry(tp) ||
+		    !trace_kprobe_error_injectable(tp))
+			return -EINVAL;
+	}
 
 	mutex_lock(&bpf_event_mutex);
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index a5dbb72528e0..768702674a5c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -53,17 +53,6 @@ static struct dyn_event_operations trace_kprobe_ops = {
 	.match = trace_kprobe_match,
 };
 
-/*
- * Kprobe event core functions
- */
-struct trace_kprobe {
-	struct dyn_event	devent;
-	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
-	unsigned long __percpu *nhit;
-	const char		*symbol;	/* symbol name */
-	struct trace_probe	tp;
-};
-
 static bool is_trace_kprobe(struct dyn_event *ev)
 {
 	return ev->ops == &trace_kprobe_ops;
@@ -212,33 +201,16 @@ unsigned long trace_kprobe_address(struct trace_kprobe *tk)
 	return addr;
 }
 
-static nokprobe_inline struct trace_kprobe *
-trace_kprobe_primary_from_call(struct trace_event_call *call)
-{
-	struct trace_probe *tp;
-
-	tp = trace_probe_primary_from_call(call);
-	if (WARN_ON_ONCE(!tp))
-		return NULL;
-
-	return container_of(tp, struct trace_kprobe, tp);
-}
-
-bool trace_kprobe_on_func_entry(struct trace_event_call *call)
+bool trace_kprobe_on_func_entry(struct trace_kprobe *tp)
 {
-	struct trace_kprobe *tk = trace_kprobe_primary_from_call(call);
-
-	return tk ? (kprobe_on_func_entry(tk->rp.kp.addr,
-			tk->rp.kp.addr ? NULL : tk->rp.kp.symbol_name,
-			tk->rp.kp.addr ? 0 : tk->rp.kp.offset) == 0) : false;
+	return !kprobe_on_func_entry(tp->rp.kp.addr,
+			tp->rp.kp.addr ? NULL : tp->rp.kp.symbol_name,
+			tp->rp.kp.addr ? 0 : tp->rp.kp.offset);
 }
 
-bool trace_kprobe_error_injectable(struct trace_event_call *call)
+bool trace_kprobe_error_injectable(struct trace_kprobe *tp)
 {
-	struct trace_kprobe *tk = trace_kprobe_primary_from_call(call);
-
-	return tk ? within_error_injection_list(trace_kprobe_address(tk)) :
-	       false;
+	return within_error_injection_list(trace_kprobe_address(tp));
 }
 
 static int register_kprobe_event(struct trace_kprobe *tk);
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 9fc56c937130..958eb78a9068 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -30,6 +30,7 @@
 
 #include "trace.h"
 #include "trace_output.h"
+#include "trace_dynevent.h"
 
 #define MAX_TRACE_ARGS		128
 #define MAX_ARGSTR_LEN		63
@@ -210,21 +211,6 @@ DECLARE_BASIC_PRINT_TYPE_FUNC(symbol);
 #define ASSIGN_FETCH_TYPE_END {}
 #define MAX_ARRAY_LEN	64
 
-#ifdef CONFIG_KPROBE_EVENTS
-bool trace_kprobe_on_func_entry(struct trace_event_call *call);
-bool trace_kprobe_error_injectable(struct trace_event_call *call);
-#else
-static inline bool trace_kprobe_on_func_entry(struct trace_event_call *call)
-{
-	return false;
-}
-
-static inline bool trace_kprobe_error_injectable(struct trace_event_call *call)
-{
-	return false;
-}
-#endif /* CONFIG_KPROBE_EVENTS */
-
 struct probe_arg {
 	struct fetch_insn	*code;
 	bool			dynamic;/* Dynamic array (string) is used */
@@ -271,6 +257,32 @@ struct event_file_link {
 	struct list_head		list;
 };
 
+/*
+ * Kprobe event core functions
+ */
+struct trace_kprobe {
+	struct dyn_event	devent;
+	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
+	unsigned long __percpu	*nhit;
+	const char		*symbol;	/* symbol name */
+	struct trace_probe	tp;
+};
+
+#ifdef CONFIG_KPROBE_EVENTS
+bool trace_kprobe_on_func_entry(struct trace_kprobe *tp);
+bool trace_kprobe_error_injectable(struct trace_kprobe *tp);
+#else
+static inline bool trace_kprobe_on_func_entry(struct trace_kprobe *tp)
+{
+	return false;
+}
+
+static inline bool trace_kprobe_error_injectable(struct trace_kprobe *tp)
+{
+	return false;
+}
+#endif /* CONFIG_KPROBE_EVENTS */
+
 static inline unsigned int trace_probe_load_flag(struct trace_probe *tp)
 {
 	return smp_load_acquire(&tp->event->flags);
@@ -329,6 +341,18 @@ trace_probe_primary_from_call(struct trace_event_call *call)
 	return list_first_entry_or_null(&tpe->probes, struct trace_probe, list);
 }
 
+static nokprobe_inline struct trace_kprobe *
+trace_kprobe_primary_from_call(struct trace_event_call *call)
+{
+	struct trace_probe *tp;
+
+	tp = trace_probe_primary_from_call(call);
+	if (WARN_ON_ONCE(!tp))
+		return NULL;
+
+	return container_of(tp, struct trace_kprobe, tp);
+}
+
 static inline struct list_head *trace_probe_probe_list(struct trace_probe *tp)
 {
 	return &tp->event->probes;
-- 
2.47.3


