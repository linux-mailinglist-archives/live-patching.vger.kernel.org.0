Return-Path: <live-patching+bounces-2878-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UB2jIe+OE2rdDQcAu9opvQ
	(envelope-from <live-patching+bounces-2878-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 01:51:11 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 05CA65C4CED
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 01:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5196A3009027
	for <lists+live-patching@lfdr.de>; Sun, 24 May 2026 23:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAA603B83E3;
	Sun, 24 May 2026 23:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SJfE+m26"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E303B8405
	for <live-patching@vger.kernel.org>; Sun, 24 May 2026 23:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779666652; cv=none; b=levt52R2Vj9a9slpveSW557mj4ZaWf/bj1umDxk9WuczY97DJybBRiZu5RdVYZDq639QXeaXvTBgJhUScfsCT9OMnBbQiM0VMOwHXBYUL20YxkhJvGmk0P/k7J/DQ04A7K2sMVq1kqumbi5c4QuRHdkepSQ4wHfmPQEcqcdQW2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779666652; c=relaxed/simple;
	bh=8ylJrm4gNzXVcl53g914hH7zMuE5tvlB0gFHZn4rj4M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d96uAI/VcupuquoT8npXqvDnLfJ7jXf5l2cGanw82vZZL1IeBXmvfwOXBReyzPOHKFWGAY8YgLSQE236qR45a4adXeC4tjG6yCV2f6yLqZc9xND+GumRTdkShsNPmfrEM1NwaRNVUmW2RBiA+BB4GOnB/AQNGK8orKrLHob9i3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SJfE+m26; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490426d72f7so23114025e9.3
        for <live-patching@vger.kernel.org>; Sun, 24 May 2026 16:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779666649; x=1780271449; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f6YNn0fcdFecPZmRv6CDovwT/SpsvUpXOiglKkzdZnk=;
        b=SJfE+m26pAmZNXQt7rl9M+Fo1dHOc1GplEotfj6CG90PK/wrtiCgyUZLNC09WHXmAM
         9/wJ7dtOB2xJkK0W5jyjDnnkWg3MbgkSVedJ9ILh/F8DF8wxP1P5JH5ojnzOVzoyMeVl
         tRy2Oy2U616AGWM7n6w4kYLkhBPq8pE37X/MsDQOduXuhGwRZRhfYEnnAGEhsyF+QgCw
         tDfYgGhjd89uyauACMgZMuUe52aTxZk8FjeCzRTLxe276Q4HKWEFfxko0soUzOdtZjPY
         oKLI57xZU+4gaxtt5wv1IwVAA7+iAZvFp5m7Mna19RG4NzdYc6i07y4w52SYgsOTbSHa
         6sXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779666649; x=1780271449;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f6YNn0fcdFecPZmRv6CDovwT/SpsvUpXOiglKkzdZnk=;
        b=dvZF29VVdif1IrH4VwXyu7WAG5lQO9jj1LHODUkpwqSFxcnxiA/DaM3wxe02kJCEqy
         Vmx1CM77xSY6jlmKBinTgGFZMRope5VKBKFv1LllPv2j2fgphf1jYU2ZXwCWezhDdi78
         qDSA3JS1gpHGffe2t9rBb9XUF8/yFOyG2tNI3VibyOX82s3hrBcXLO1qJmdRMBLf/Eau
         64SFyF/U5ZJ26sebPwZH0c2tCnh85HFutJ1pF9B470IWUnnqTVdUczh2KQoY8Xdb7R/S
         24fZqEXSeqYVoWkTNqalXf1A5hhcG91WAIfNQ00CyFFz7q/q2QawmPIv/B8/PmRuDwzG
         3gbg==
X-Gm-Message-State: AOJu0Yw5XYKFU4Ndp4Gc3sWyG9qUjd7Nfgy5trx7RHWwVo336xrlfdro
	XIvg//p2QgZuICXMpp6g2MhbQqHo8Vzx7yzcmkh1HB2J6zx/4nwsSFToxFuh71SnbA4=
X-Gm-Gg: Acq92OGJ4Tpytrfj5Mj+1PgmWior4U6ptuNBhNfsdMU7wwL+ftoDeDqLoaWAKisflYN
	GmemLPSwW32VXLc1RzXY8P7VE79pa99n8f0NJkcJlr/7p5PuCDijK8WDk44+8/Tdev03P06aJ3H
	wOWmuECLI3VojyMNML/BD0lOe4xa8l7CbV3HNmaGEOApvbblcdEW1L8jISh5bQ7OcksyPsEIWXW
	FZUlGkzfIXiwMH8Sr8pH+yp59N39cebXGO0uuFKDxg+BtlVFNKor03lSR/G2jWXGj2x6m2Zqg/j
	61dFCuMNAmWBMewgeVPh56OaGhha5D3uGzT1YcZ+tDXJmuVxZLJ1J81npVHqavubqFb5dPU5O54
	VH/e089tlhXQQGQAjr6kh2lW1jQdncHcGtybk6Uz4Qra99v0h6GP/Uh/KhRp5uejPHSRuu6UXM/
	FjGc9NccsAGDTGfMORGJ6Wt0Y=
X-Received: by 2002:a7b:cde1:0:b0:489:1f04:96c3 with SMTP id 5b1f17b1804b1-4904248b137mr123733665e9.2.1779666649419;
        Sun, 24 May 2026 16:50:49 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9de2dsm21698074f8f.4.2026.05.24.16.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 16:50:49 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Sun, 24 May 2026 20:50:31 -0300
Subject: [PATCH 2/4] selftests: livepatch: Remove leftover modules when a
 testcase fails
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260524-livepatch-unload-on-fail-v1-2-7465de7f741d@suse.com>
References: <20260524-livepatch-unload-on-fail-v1-0-7465de7f741d@suse.com>
In-Reply-To: <20260524-livepatch-unload-on-fail-v1-0-7465de7f741d@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>, 
 marcos@mpdesouza.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779666636; l=2469;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=8ylJrm4gNzXVcl53g914hH7zMuE5tvlB0gFHZn4rj4M=;
 b=TWGoyFXs5NKuk8AGPH545Wuz7+klYGHy3CcSOG+Fnnm5SxVeZI3XIYgtSHk9VGybJCOd2Wnt6
 90asTv0ug6yBKrHd/IuGuzUXT2eS87+RMTRXaS2GKneHXKSrcpxk2eu
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2878-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 05CA65C4CED
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The current livepatch selftest scripts load modules, run tests and
unloads them. If the test fails, it can leave loaded modules behind, and
in some cases making it impossible to run the next tests.

This approach tracks down the loaded modules, and in case of a test
failure, or premature exit of the script, the cleanup function will
be called by the trap installed on setup_config function.

The cleanup function iterates over the list of leftover loaded modules,
unloading them. The function also checks if the given module is a
livepatch, properly disabling it before unloading.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/functions.sh | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 3ec0b7962fc5..25f137003865 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -15,6 +15,8 @@ if [[ -e /sys/kernel/tracing/trace ]]; then
 else
 	SYSFS_TRACING_DIR="$SYSFS_DEBUG_DIR/tracing"
 fi
+# List of loaded modules used in tests
+TEST_MODS=()
 
 # Kselftest framework requirement - SKIP code is 4
 ksft_skip=4
@@ -125,6 +127,14 @@ function set_ftrace_enabled() {
 }
 
 function cleanup() {
+	# Remove leftover modules in reverse order to handle dependencies
+	for mod_item in "${TEST_MODS[@]}"; do
+		if is_livepatch_mod "$mod_item"; then
+			disable_lp "$mod_item"
+		fi
+		_remove_mod "$mod_item"
+	done
+
 	pop_config
 }
 
@@ -181,6 +191,9 @@ function __load_mod() {
 	# Wait for module in sysfs ...
 	loop_until '[[ -e "/sys/module/$mod" ]]' ||
 		die "failed to load module $mod"
+
+	# Store the module in the modules list
+	TEST_MODS+=("$mod")
 }
 
 
@@ -262,12 +275,20 @@ function _remove_mod() {
 		die "failed to unload module $mod (/sys/module)"
 }
 
-# unload_mod(modname) - unload a kernel module
+# unload_mod(modname) - unload a kernel module and remove it from TEST_MODS
 #	modname - module name to unload
 function unload_mod() {
 	local mod="$1"
 
 	_remove_mod "$mod"
+
+	# Remove from TEST_MODS array
+	for i in "${!TEST_MODS[@]}"; do
+		if [[ "${TEST_MODS[$i]}" == "$mod" ]]; then
+			unset 'TEST_MODS[$i]'
+			break
+		fi
+	done
 }
 
 # unload_lp(modname) - unload a kernel module with a livepatch

-- 
2.54.0


