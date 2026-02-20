Return-Path: <live-patching+bounces-2063-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YPfhKvxrmGn4IAMAu9opvQ
	(envelope-from <live-patching+bounces-2063-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 20 Feb 2026 15:13:16 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D102168378
	for <lists+live-patching@lfdr.de>; Fri, 20 Feb 2026 15:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2A7A130783B7
	for <lists+live-patching@lfdr.de>; Fri, 20 Feb 2026 14:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062EB34BA56;
	Fri, 20 Feb 2026 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="feuqaKhG"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB1C34C98C
	for <live-patching@vger.kernel.org>; Fri, 20 Feb 2026 14:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771596767; cv=none; b=gEdxnemclfZlABamdePsmMqaql18rKj9Ik2TND/TKxiB9OxZZ6fo22Sa+vzlFb2gP5Gj42cuAg0R56GvkNbf3kTi00UeuRJ2HASpiVpPWP1Gjn3OD5ulw0qXC4rt1ZiLskgon/4ZVdwXUCJ6bFxKR0gcGUGZZaoLHU2tOoDvJqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771596767; c=relaxed/simple;
	bh=lfkcP3ZdIIOq+1bZXx5CwRguKuxe5MWg0qFqkWJX6To=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XjS858MNIdvLg2gcAVRDtWqZ+nmkurba4PH8nR+rwCgtfO6f3KizH0JFJjkEybVG25UNAJIQdvjhqzA8TUaX3BwxtczvcGETPL72iokdrCDF0FOjjZpS1UuWvaO6gY09233ciwDITO6srAjNWWMM03rG2pr2DUIFSNUZMTD2Ang=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=feuqaKhG; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48069a48629so21083975e9.0
        for <live-patching@vger.kernel.org>; Fri, 20 Feb 2026 06:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771596765; x=1772201565; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y+uzYBps92pCmeU+FcOVPa+5H48G5IG9O6HJXUTvz+Y=;
        b=feuqaKhGCEdPX7QTBhQ8wYwGXoNVQeyUjPkCJ3C+wlAlmLGnsPw3Fy97kSUT22dokA
         gY9OSPMK8QNhRTenVdIYtV51J0Czg3QgLJBKGUpFBd9veWy1epALyWFWwAnePw2d8ia2
         +pLSi+vvZrGhJqvMIGtP2mJfgPvvYc0azMqwvBoUHm6GG6D+I4LYvsV9BJ6jtHZ83NnL
         Qxy8vo6tMhAG4W4yuzqdHb6q/igtI5+KLRvt5FQxLOzdmu6qDVVunNra7IO3eIvrajIQ
         E5cJQE1rzus1b+oGdwUnEg2sPmtT05iLxMPeNxkpqu0uUvoW7kGoZODqFBrQpcwOyJql
         ZvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771596765; x=1772201565;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y+uzYBps92pCmeU+FcOVPa+5H48G5IG9O6HJXUTvz+Y=;
        b=jXwhQtDgRO/TcYta3EgYnataNKuBmUkVNE4h4n+gFSNHMj+W1icHHX37FGluaapOK+
         aCattxIPV8ImnZngWkhRox1fvRwkKkRcShLaAABf1Bo7gSPIRn42Psx1GV0tX1qrha29
         eIRU7kTH5CBeJ61FOhDmL7Ng5kFJ9J/BCpgaPbj3Lkn6D+GskAUayrqLVS4SwFSRezYp
         hLHiPLB5fiL/d9eX7tfdBlomLQIRUTNtccHKdb63USp8O4v00ZD2xE4cC08i4/O9yR7b
         BKKaGCDP3H3Ue+iBwtmjQM1QotFrYGMudvAlaLvIePFDEgJg4Ef19o2P6LxOg3MViVc1
         m0hw==
X-Gm-Message-State: AOJu0YyKeEUGmW2pwm8+aEyRkHu3JDVenRGqWtURzXxFdPLM60c2yYCw
	U5ilZ2lYzHp8JyMhrq7UtgcQ+asGWmO9oTPf73GjJNXJaZR/tjUaK+KeCyHoLCyoKFk=
X-Gm-Gg: AZuq6aIbSMZ7hnHPyVyz32KB0d1wWE4UtEU74kg4cBrDhg1foXtAX67bdsJslrnXt+v
	qVE310IKXjChBbOZJrG4DkCM1IldtQYScO87jCTCy4t4KIxP/VjgoLIM/lG613eo5+MUzkqw9tZ
	vBPYtJ2guIvgHM8Tev/J/bk0hNTaXcGmlZEvU3hRJGkt+xWf5H84wgrZkraT0kofs8ZYSuaB3eR
	ghYi3WPbw1x8tZplAkwwOUSwk7mKjYQQ0Q5cyKGvbmNkyK4gLU0ujt4+ymYR2KgnETW/DmJGLVc
	jC7WItkw3dI+z+uZZLtbJVDwdKXiaFwSWnntBruEVpeHXcpOTCW3WWgN6wUL13Tv5QKF8GQa3pI
	7JgZpwhBYBXuu40tJriiD316yiQNwPWdjVlne0zBMifJddGIn9eT8OqvKR8PXrQWWt/W5Oak0v7
	wTXcekcX/wIQ54EiIe+Jqu
X-Received: by 2002:a05:600c:8287:b0:483:7eea:b185 with SMTP id 5b1f17b1804b1-483a541a866mr36611035e9.16.1771596764582;
        Fri, 20 Feb 2026 06:12:44 -0800 (PST)
Received: from [127.0.0.1] ([2804:5078:822:3100:58f2:fc97:371f:2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5b2d1sm60119173f8f.4.2026.02.20.06.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 06:12:44 -0800 (PST)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Fri, 20 Feb 2026 11:12:33 -0300
Subject: [PATCH 1/2] selftests: livepatch: test-ftrace: livepatch a traced
 function
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-lp-test-trace-v1-1-4b6703cd01a6@suse.com>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
In-Reply-To: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771596757; l=2107;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=lfkcP3ZdIIOq+1bZXx5CwRguKuxe5MWg0qFqkWJX6To=;
 b=j0Hy38QFPzn4yRGnk1pGC8agT7SWqZWsfvcqLHUjNE38K6fhxH9e2jAeIpsiR17McRfZSkL8I
 UAuk8Hzj9wJDaMKCHcPbKQWymB9g+38qIJH2vWs64xRU7cjDGNbk7q5
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2063-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0D102168378
X-Rspamd-Action: no action

This is basically the inverse case of commit 474eecc882ae
("selftests: livepatch: test if ftrace can trace a livepatched function")
but ensuring that livepatch would work on a traced function.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-ftrace.sh | 36 ++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/livepatch/test-ftrace.sh b/tools/testing/selftests/livepatch/test-ftrace.sh
index 094176f1a46a..c6222cc037c5 100755
--- a/tools/testing/selftests/livepatch/test-ftrace.sh
+++ b/tools/testing/selftests/livepatch/test-ftrace.sh
@@ -95,4 +95,40 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
+
+# - trace a function
+# - verify livepatch can load targgeting no the same traced function
+# - check if the livepatch is in effect
+# - reset trace and unload livepatch
+
+start_test "livepatch a traced function and check that the live patch remains in effect"
+
+FUNCTION_NAME="cmdline_proc_show"
+
+trace_function "$FUNCTION_NAME"
+load_lp $MOD_LIVEPATCH
+
+if [[ "$(cat /proc/cmdline)" == "$MOD_LIVEPATCH: this has been live patched" ]] ; then
+	log "livepatch: ok"
+fi
+
+check_traced_functions "$FUNCTION_NAME"
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+livepatch: ok
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
 exit 0

-- 
2.52.0


