Return-Path: <live-patching+bounces-2198-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SGPqCr16tGmOogAAu9opvQ
	(envelope-from <live-patching+bounces-2198-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 21:59:41 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 701BA289F57
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 21:59:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6508F30EAB4E
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 20:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56557382373;
	Fri, 13 Mar 2026 20:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gBLGV6Ln"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282583815D7
	for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 20:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773435529; cv=none; b=ihrGteXeiewLZiWFgGDo0mQLUO25ZqUTpFyI3rkd3ua2buW1XzSF9bRL2obY870N90DgiL15GjZzHCJ7J/ACPLkHGdgtzhUnBxCDT+F+kiB3e107psM4tpcv8SJQqmh9aD5umK9/yg+8kKazKKFO/uexhFu40Xbxip+i2JXVGOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773435529; c=relaxed/simple;
	bh=8jRkvxxvT99z3b+LG2vpiz3TQlNMu0g+HY9wzZ0lZRw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Yr0tR2oL3XH1SkRdBD1yydutdKmrFHty8xIqRhZ8lRH6/CNT0XX7iARhbzIdTkhxPlusbyw7ORl/iYX34Kq80igaw9iNrpZVglAl8KkL+pXNUFgOvsczuUeul2IEviOgZ4W/dPfHVUzZ+q/n895qx4dFrmTkKYa8TbVYl2Y8roo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gBLGV6Ln; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48557c8ad47so11839975e9.0
        for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 13:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773435524; x=1774040324; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HVWkiiv18U1tuwb2itRTyF8mnxLw6x7wlBUEkvfx9EI=;
        b=gBLGV6LnOSbQNUAc75Ri1RNAglMHT/blh9GU3ixQNicJLCHqbBQvUbcdjCk+vFfYPu
         cZxajpQ2C9urTfN/IKeWHZZmAPfb1z0lRgWuar3ILPnJO97AiA7PsjLE6g/uKJAwjZk2
         M5DFf/Vinvnl6vXtS2qvtuiPPpxYQPCpca5u6Udbqp3m5uvk16WbKEqmWRKRz7gSAJyO
         jSTIZaT2+UFBzKPD7uf9e+y6vglxcUAU55xiXnxTwF7FTses4MybSD6ZOkRnTyGwcGK6
         T5eepNnTgHaaaGMP7efROOF2/5j7YiNZXa5Lo94rsLdJb7bhU+MxGU/8GP7eIDcJFLZy
         71Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773435524; x=1774040324;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HVWkiiv18U1tuwb2itRTyF8mnxLw6x7wlBUEkvfx9EI=;
        b=g+itsPc3ZXTBt10+5buRynpEbZ1MqPj6dLeLLb8WqldyHm8A/k1ehrBEEsioSH/1WA
         /Hd+GyvnmVneFAyw+aH9O/fgSHtHLbvju4EUSKl+Mzak412wXhx8KL4V49AVRPaibDR/
         BsT2VefvovDMwWuni6kKT3yuxGehh5s1wq1Vjxo7OshoGmKB6yO9589RFfLn3bmID1PB
         pe/0KiNuGoQLBGNCNbbBtJ6ZZvPuTuvyDOyWnip/GuNmSFsh93/hu48ZquexHIqx4JNh
         /NUSvu6EIdloxv79TSnuoGBrCJHydOUHI11Dbt8Ioj0HOjMflndVQ8VW+c1IQLcqBzFO
         V19w==
X-Gm-Message-State: AOJu0YxRqT/qI0OonXcjH9CTulotEalUUWzZVLZqCWexOkzqweg4iQzN
	LZrdtgD4/BKLK5iWffgcxUt9pSU3VULmtVwdFZhnWyGTNwl5KT69xkii9e/xYso5eaE=
X-Gm-Gg: ATEYQzx9o+VNKwy3YlowJs3cXQknwykFXglm7owBtxtkc9bswgdM0P0hhk9/+OPMhG7
	6yWptmeEMB2BVXxOZA957oYCWOf9nJBWPIUtWil2M48YM1wwfANuFZYQqRkOVNv5MkXt8B0Wtv7
	NGiMXiIT+QqK0eVV6hNrFG8j5KDLQYnu0qg3FLAWC3yw62t+4WURlUERzTWzIc27i2R/zOn27Ak
	KjCq8ashWoMfasxxCfsr0HWAGgIzfxMO30fuBi1+DxYf5MMuza9T9OycVg4dHdJ1pmgH71Tbc8M
	favCqOtxRx42eISwp9AFecYS9TJ+CyhVoljX4/6qo+SucNwIQ8SggAWjYDMJJT00rKdekJTG68v
	YfUf6GvudYepUdItvpcNHhbw/5rTDyPIpg4wBSgmV17K2hIoxQ9PIZctafPNWtJV5wWPRPCErug
	e+1UzNezlXlUC+e8D3KVaZ
X-Received: by 2002:a05:600d:8489:20b0:485:3812:36dc with SMTP id 5b1f17b1804b1-485566d9068mr59603325e9.9.1773435524238;
        Fri, 13 Mar 2026 13:58:44 -0700 (PDT)
Received: from [127.0.0.1] ([2804:5078:834:1300:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab526d3csm4042611eec.18.2026.03.13.13.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:58:43 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Fri, 13 Mar 2026 17:58:32 -0300
Subject: [PATCH 1/8] selftests: livepatch: test-syscall: Check for
 ARCH_HAS_SYSCALL_WRAPPER
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260313-lp-tests-old-fixes-v1-1-71ac6dfb3253@suse.com>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
In-Reply-To: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773435515; l=1173;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=8jRkvxxvT99z3b+LG2vpiz3TQlNMu0g+HY9wzZ0lZRw=;
 b=kOkiJw1y1W4Nogu0138hwjYMxSp1GgsM6j987tFoG/Ck+s5vwr5Phe55spvzVJy88qTDJIB+p
 CLzBjIkGSlnCRP4IRl2JxRUjeZDSJTZS+UXo8Bhs57aT5qGKgPcgLxs
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2198-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: 701BA289F57
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Instead of checking if the architecture running the test was powerpc,
check if CONF_ARCH_HAS_SYSCALL_WRAPPER is defined or not.

No functional changes.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
index dd802783ea849..c01a586866304 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
@@ -12,15 +12,14 @@
 #include <linux/slab.h>
 #include <linux/livepatch.h>
 
-#if defined(__x86_64__)
+#if !defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER)
+#define FN_PREFIX
+#elif defined(__x86_64__)
 #define FN_PREFIX __x64_
 #elif defined(__s390x__)
 #define FN_PREFIX __s390x_
 #elif defined(__aarch64__)
 #define FN_PREFIX __arm64_
-#else
-/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER */
-#define FN_PREFIX
 #endif
 
 /* Protects klp_pids */

-- 
2.52.0


