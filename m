Return-Path: <live-patching+bounces-2276-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CG6/EBs3zmm1mAYAu9opvQ
	(envelope-from <live-patching+bounces-2276-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 11:30:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D65D386F24
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 11:30:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3F4C6305ACB4
	for <lists+live-patching@lfdr.de>; Thu,  2 Apr 2026 09:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A97A3932CC;
	Thu,  2 Apr 2026 09:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZG7MGOBv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C80D390210
	for <live-patching@vger.kernel.org>; Thu,  2 Apr 2026 09:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775122005; cv=none; b=UUG0Ty935cDH/axQmycIx5e8Xp+qjT9rWtB8gz5t+vU3IZtK4IqeB8DAQa6pWX6Hk74JbscZqF7ZGryZzet7a5dVGfTLwkaPV+l7bbb7BGvEDKnEcgOVRQtE2EnQsOi4dy6X0MjbPwNg90BRRvpmAaYpSmxN/jKEV3i2ys3+6i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775122005; c=relaxed/simple;
	bh=5nMc9qAcFEsGx3C7PmryTlLfGSZTMZVInAVBgvQtejY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=al8N65pBh8Y15drhlYeiOLGBzTnLEWgxU2k1UlmCJOYocqzNXphZp6jEOREY6q2Y7XZuCyaZGmfEgCi2XPj9FYwD/yR48GHiJlacvNjcamY0ZI5e0RX3GQ+4//Wt5xiABqaxwyCWoZKgOcNFBqXhmjcShgjyO8GR+ztrmJoIQXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZG7MGOBv; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35c1d101355so248322a91.1
        for <live-patching@vger.kernel.org>; Thu, 02 Apr 2026 02:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775121997; x=1775726797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81j40jm7xzkIDR0AUEs06y3jjZUfu/jUEFBO6OwZcOw=;
        b=ZG7MGOBvrOPdrSlJltkWWUZi7E2sgqmqfiuTaPjkWBNPF5s7PnyiRm36zvCIDtr6uX
         +c5B60RkEJue0Rewey+xsrKzgSWEJ3RGtrBQSHwstOEDhxuaxQbAklu3VtBcvAY/QGit
         MQKvw1sQbldvJBtUXOyLOcODIUqy+W5uIiM/TcJtYVKAbG97W9VcasXGLAXlbpv5HZay
         kq+BMPmCzbj4Vtes57fdyohUNWJbkjQW7gH737dCD/A7vXXgzFUMRFjTipV5Th0MRj3G
         e849m1pvOVsB132tO5tWgEHQa0DMaoiVDR2OLgv4xW+TLnnWTqXxY1bRkVL5sXDVOjhZ
         Fcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775121997; x=1775726797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=81j40jm7xzkIDR0AUEs06y3jjZUfu/jUEFBO6OwZcOw=;
        b=rYblD0CHN/ND8GgkiQAgpn02S/QLEsFv+M8exAptEa7Sf9hwNRzSk1S9qNY9lCHfql
         QzmEDNLJI/Sf52H/UTH4FCYeYek8RLxANGmXV8HtBTka9/laZW5ONYDwBXyaUmuo8lP4
         MjvOGhBOZrx/mjvmZBl5z7+woiNZNJf60Nz3QpTjfoC8y0HGgGbF28m6ZHiHLUt8kfKO
         y+PZsa8q/BukGy6sHATRORP/d9NJzDvu2N7zIn352UdvWStkHgC1fbsm6JCt9wpIa68o
         4qH215iYDMZcXaS5GhBlf1szbRQ7jMiHf6BEbIZMt+cox++Jxx9wrFXhjdkrCNxicBuo
         I2xg==
X-Gm-Message-State: AOJu0YzoXwnwpenufwbMK6cgFfF9k43xORla8MMg54oBkchVcpqxJyUb
	5URTq7hXIfsHabMZBq3HR0kathaYiquV+VgWlFGRnwnFQjcM0X/Zd2NP
X-Gm-Gg: AeBDieu7d/v/tpKTDUaWvxO/40OgFryJZC58phstJCGto9GjdhjREnOLr84a8a2i5FC
	QB/LqIvkHtmrKkJoBAbG7T6XsKmhH8HgiflsJJvvspFq8fBKW3lqnvxs62D5usHA9Q0/tBG4PWR
	4nEV42LmHCr1BAoZx8aknINhZEy2Hlrvv7U0DBt3u6PGlogHFTQnzjg0JlqcA57YPV5E3eGVNwX
	vtN4PqgNutGixUL9MhKS11kpd9MOZo1xH9KHzigPevj6uR3XRg+UBKdyk6kjlOA0vYuR+Tz2guQ
	QWAStytQrEunLgdEiT4kL8r01bO8GK5nn3JJEuzOXGOOWpUgS04hgLiLqoa+oLqdx8Y1uVkba3U
	j+qidOACgaxv9O/Cjg7F7374TNfD+7FF7XwuxFa59Q/z8LKMYfVlq84DEg18m/8p57QlrLGaZiY
	senShTtUDkvnK6DulafeNtB0Z9B5cbRvcBcICOgkCBzXXn
X-Received: by 2002:a17:90b:5350:b0:359:8dfd:64c8 with SMTP id 98e67ed59e1d1-35dc6f3b854mr6703431a91.24.1775121996713;
        Thu, 02 Apr 2026 02:26:36 -0700 (PDT)
Received: from yafangs-Air ([2409:891f:1aa0:8613:19f3:7bee:2e41:149e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dd35f50e9sm2227645a91.6.2026.04.02.02.26.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Apr 2026 02:26:36 -0700 (PDT)
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
Subject: [RFC PATCH 2/4] trace: Allow kprobes to override livepatched functions
Date: Thu,  2 Apr 2026 17:26:05 +0800
Message-ID: <20260402092607.96430-3-laoar.shao@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2276-lists,live-patching=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 9D65D386F24
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Introduce the ability for kprobes to override the return values of
functions that have been livepatched. This functionality is guarded by the
CONFIG_KPROBE_OVERRIDE_KLP_FUNC configuration option.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/trace/Kconfig        | 14 ++++++++++++++
 kernel/trace/bpf_trace.c    |  3 ++-
 kernel/trace/trace_kprobe.c | 17 +++++++++++++++++
 kernel/trace/trace_probe.h  |  5 +++++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 49de13cae428..db712c8cb745 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -1279,6 +1279,20 @@ config HIST_TRIGGERS_DEBUG
 
           If unsure, say N.
 
+config KPROBE_OVERRIDE_KLP_FUNC
+	bool "Allow kprobes to override livepatched functions"
+	depends on KPROBES && LIVEPATCH
+	help
+	  This option allows BPF programs to use kprobes to override functions
+	  that have already been patched by Livepatch (KLP).
+
+	  Enabling this provides a mechanism to dynamically control execution
+	  flow without requiring a reboot or a new livepatch module. It
+	  effectively combines the persistence of livepatching with the
+	  programmability of BPF.
+
+	  If unsure, say N.
+
 source "kernel/trace/rv/Kconfig"
 
 endif # FTRACE
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c901ace836cb..08ae2b1a912c 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1935,7 +1935,8 @@ int perf_event_attach_bpf_prog(struct perf_event *event,
 		if (!tp)
 			return -EINVAL;
 		if (!trace_kprobe_on_func_entry(tp) ||
-		    !trace_kprobe_error_injectable(tp))
+		    (!trace_kprobe_error_injectable(tp) &&
+		     !trace_kprobe_klp_func_overridable(tp)))
 			return -EINVAL;
 	}
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 768702674a5c..6f05451fbc76 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -213,6 +213,23 @@ bool trace_kprobe_error_injectable(struct trace_kprobe *tp)
 	return within_error_injection_list(trace_kprobe_address(tp));
 }
 
+bool trace_kprobe_klp_func_overridable(struct trace_kprobe *tp)
+{
+	bool overridable = false;
+#ifdef CONFIG_KPROBE_OVERRIDE_KLP_FUNC
+	struct module *mod;
+	unsigned long addr;
+
+	addr = trace_kprobe_address(tp);
+	rcu_read_lock();
+	mod = __module_address(addr);
+	if (mod && mod->klp)
+		overridable = true;
+	rcu_read_unlock();
+#endif
+	return overridable;
+}
+
 static int register_kprobe_event(struct trace_kprobe *tk);
 static int unregister_kprobe_event(struct trace_kprobe *tk);
 
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 958eb78a9068..84bd2617db7c 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -271,6 +271,7 @@ struct trace_kprobe {
 #ifdef CONFIG_KPROBE_EVENTS
 bool trace_kprobe_on_func_entry(struct trace_kprobe *tp);
 bool trace_kprobe_error_injectable(struct trace_kprobe *tp);
+bool trace_kprobe_klp_func_overridable(struct trace_kprobe *tp);
 #else
 static inline bool trace_kprobe_on_func_entry(struct trace_kprobe *tp)
 {
@@ -281,6 +282,10 @@ static inline bool trace_kprobe_error_injectable(struct trace_kprobe *tp)
 {
 	return false;
 }
+static inline bool trace_kprobe_klp_func_overridable(struct trace_kprobe *tp)
+{
+	return false;
+}
 #endif /* CONFIG_KPROBE_EVENTS */
 
 static inline unsigned int trace_probe_load_flag(struct trace_probe *tp)
-- 
2.47.3


