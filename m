Return-Path: <live-patching+bounces-2200-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oI0mC7F6tGmOogAAu9opvQ
	(envelope-from <live-patching+bounces-2200-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 21:59:29 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D692B289F4F
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 21:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B9F5A3029A71
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 20:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C573C457E;
	Fri, 13 Mar 2026 20:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Tgj2ykcK"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E79382291
	for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 20:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773435539; cv=none; b=raauyYp89qrRu5cEzo3xhxtEjHA2tamGhgmUq8HRkRsjI03S2BQ5qI8i5ZobP33Pe7IqJYTF+VVFN7Z1fSPYlfS2Sc2/4hPIWP4gBYeg8SZKbSp8VbzId7rMENWFTMGZ/8LtY8jgyQzq66+YvZuobneC/7w1hisxQ99mmIfrh2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773435539; c=relaxed/simple;
	bh=EjlOG59djdew0+CoAm6FPU4BQF51f7/++vwrXk3pauQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BJtNdVIh2bNd/rdFSKJQRLnNi61SspRuh5+ixVljiD3ujkyBtg/GIzSbu7JMaQMCu9dJVk6F4sz+xt+ph6AS0mkMjf8V/Qsk0P5QInD1FEmVUlVWgiVs+HgtoVLuVrV7mTj89hmO02zpavUefZf61lsLo9z0jW47XDoZry5Xtc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Tgj2ykcK; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48374014a77so25193875e9.3
        for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 13:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773435533; x=1774040333; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IyL9HjXlVtkM7LllEkbV4aKNC8jKN7b938wPwskLBwc=;
        b=Tgj2ykcKd1OSqQFNk4hDh7KMoxqVRSAWfBcZVvhLM8l9BIqsYpsU1g/F9Pm8I7eQa6
         SSf9XOHc6a7ggClEKdwYe8AyJHw3eYp6y7wcyU3rs9LsEELyi3T7/zWPx4D8tdycRHyB
         nmm54VymCoSEVyFehwk+VyNN0lMezpdlbUryNzAUr2G7G9beCKimcftcgUxvCqJjsIFW
         ATwz7PGZyvsgbrJjW0uz7E3m/sWf2cy+oin1eQ4jtQbrWPRSeyAZjYhJsGGH7TUlxJI2
         YUsVGWn6fBjJkfxPhZ6o8mIs4T88YL8V4Q8MQsYTfKjp+xKcKeM5OxS4pEEgZDy+6pGj
         ZHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773435533; x=1774040333;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IyL9HjXlVtkM7LllEkbV4aKNC8jKN7b938wPwskLBwc=;
        b=Zjpd3kZs/UPtrmqj44GVGvuMGLjRoS3DG7Mktqw92OFu/5XnvTRuS996hCLFUZAcWu
         8YTUvkszR2NdSMpeePspkC/w+oNliugptZf/eH+LXrg6xRLEDOZyLePxajFkW+aY/qa6
         svcgovk8Agjw6cTZ9KEdVIRDAnfJfa0qZKEDYDhyTdeV8l+MAPv5LuLeiLyRSDRNeAUQ
         Pf49obtzjZA5NylBf9zwHn08wAnsIpchjUxz+d2pEbYEF6s+ehAnS22T802jp/NOClOK
         WzIVcxB0bQKbKsu5UD0Gd2/xMhlpXTa5YKv0sRnIQSMmhgWbUSlLvDXxq48eus9epVrz
         b0mA==
X-Gm-Message-State: AOJu0Yxo5UveZabP/yRvVfylFT8lBmUNlFRZu94xyl3StfENtZBiFsPh
	HdFS9CETBBdL31Am1lBBpdh+QZFJyTD51qBTpW8WicDZX24GGGXkFiVv1uPDUXAvu8Q=
X-Gm-Gg: ATEYQzyAfKV34q51wvOFHz6E3d7GrvEHzDIoJ9DaMmx45BoZizny+rZXo+B4FXIqSL/
	ETZXlw6Yx0G2wU0/NoL7cMiN5Ku5TfdUUXYPara5+s9PED/ulAZ7/dHJGnhc2pjFHyX9Utgm37L
	C8R2PT2Rw4kXc6x5neEVZ9xVC2uDt+eeGQYpSY5rdcbp6i3sVpXoxTjZC+mmpdrVWd6WOVjYo11
	4QAqZZJnnq34lcrBnhwzTHutc+PBcVOMxiAPVHY/en2RHyGGZnosvgy/yiVQ4tODGu3DgOx0qvI
	By1/ETub8/8JKZuBBnm+0HxvIPvacdNEemqk3YUyAwGxY8ZgmJ6rpbYDsXeoD00PW5Zmhcowk0r
	v3Mj0aE8yCk0tZCXa4A+f9Z+cYU9cxUNivZPt1m8GRTU3EEJcd04uBm++oaAMlw1BfXtvrvRbvL
	Heu+BVaQyUYEltY8zRWqhb
X-Received: by 2002:a05:600c:3106:b0:485:3ae3:b394 with SMTP id 5b1f17b1804b1-48556711ec9mr93938275e9.31.1773435533423;
        Fri, 13 Mar 2026 13:58:53 -0700 (PDT)
Received: from [127.0.0.1] ([2804:5078:834:1300:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab526d3csm4042611eec.18.2026.03.13.13.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:58:52 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Fri, 13 Mar 2026 17:58:34 -0300
Subject: [PATCH 3/8] selftests: livepatch: test-kprobe: Check if kprobes
 can work with livepatches
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260313-lp-tests-old-fixes-v1-3-71ac6dfb3253@suse.com>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
In-Reply-To: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773435515; l=4054;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=EjlOG59djdew0+CoAm6FPU4BQF51f7/++vwrXk3pauQ=;
 b=xZN725oHRhRMUg03sM0SZCOuYCUu9nt2V0hUx489e2bRu67lftT7q8cyHkbL3lWbpZa14HSz7
 hFuv+iFkRw+Ayny0g91NJzaN2GfJQ55AD558wEgqL6bGe6yz0o0MgOi
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2200-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: D692B289F4F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Running the upstream selftests on older kernels can presente some issues
regarding features being not present. One of such issues if the missing
capability of having both kprobes and livepatches on the same function.

The support was introduced in commit 0bc11ed5ab60c
("kprobes: Allow kprobes coexist with livepatch"), which means that older
kernels may lack this change.

The lack of this feature can be checked when a kprobe without a
post_handler is loaded and checking that the enabled_function's file
shows the flag "I". A kernel with the proper support for kprobes and
livepatches would presente the flag only when a post_handler is
registered.

No functional changes.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-kprobe.sh | 52 ++++++++++++++----------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
index cdf31d0e51955..44cd16156dbd4 100755
--- a/tools/testing/selftests/livepatch/test-kprobe.sh
+++ b/tools/testing/selftests/livepatch/test-kprobe.sh
@@ -16,30 +16,19 @@ setup_config
 # when it uses a post_handler since only one IPMODIFY maybe be registered
 # to any given function at a time.
 
-start_test "livepatch interaction with kprobed function with post_handler"
-
-echo 1 > "$SYSFS_KPROBES_DIR/enabled"
-
-load_mod $MOD_KPROBE has_post_handler=1
-load_failing_mod $MOD_LIVEPATCH
-unload_mod $MOD_KPROBE
-
-check_result "% insmod test_modules/test_klp_kprobe.ko has_post_handler=1
-% insmod test_modules/$MOD_LIVEPATCH.ko
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-livepatch: failed to register ftrace handler for function 'cmdline_proc_show' (-16)
-livepatch: failed to patch object 'vmlinux'
-livepatch: failed to enable patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': canceling patching transition, going to unpatch
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-insmod: ERROR: could not insert module test_modules/$MOD_LIVEPATCH.ko: Device or resource busy
-% rmmod test_klp_kprobe"
-
 start_test "livepatch interaction with kprobed function without post_handler"
 
 load_mod $MOD_KPROBE has_post_handler=0
+
+# Check if commit 0bc11ed5ab60c ("kprobes: Allow kprobes coexist with livepatch")
+# is missing, meaning that livepatches and kprobes can't be used together.
+# When the commit is missing, kprobes always set IPMODIFY (the I flag), even
+# when the post handler is missing.
+if grep --quiet ") R I" "$SYSFS_DEBUG_DIR/tracing/enabled_functions"; then
+	unload_mod $MOD_KPROBE
+	skip "Running kernel doesn't support kprobes along livepatches"
+fi
+
 load_lp $MOD_LIVEPATCH
 
 unload_mod $MOD_KPROBE
@@ -61,4 +50,25 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
+start_test "livepatch interaction with kprobed function with post_handler"
+
+echo 1 > "$SYSFS_KPROBES_DIR/enabled"
+
+load_mod $MOD_KPROBE has_post_handler=1
+load_failing_mod $MOD_LIVEPATCH
+unload_mod $MOD_KPROBE
+
+check_result "% insmod test_modules/test_klp_kprobe.ko has_post_handler=1
+% insmod test_modules/$MOD_LIVEPATCH.ko
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: failed to register ftrace handler for function 'cmdline_proc_show' (-16)
+livepatch: failed to patch object 'vmlinux'
+livepatch: failed to enable patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': canceling patching transition, going to unpatch
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+insmod: ERROR: could not insert module test_modules/$MOD_LIVEPATCH.ko: Device or resource busy
+% rmmod test_klp_kprobe"
+
 exit 0

-- 
2.52.0


