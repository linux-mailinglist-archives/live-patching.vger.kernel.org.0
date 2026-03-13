Return-Path: <live-patching+bounces-2197-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6MHICqp6tGmOogAAu9opvQ
	(envelope-from <live-patching+bounces-2197-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 21:59:22 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 88390289F3F
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 21:59:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8A6B630AAE53
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 20:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636523822A9;
	Fri, 13 Mar 2026 20:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bKqKFNxn"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749613806CF
	for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 20:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773435524; cv=none; b=Tyn5sjovqOruZfid55ah8kMWJyIVbmTyrECg1GZ9sMYlMGwXtNt8eFiaCllGW7lr4zqWTXciXcj3C6VNdwzuwiAj9Kmp7vY/hYxFd80IpljwmOQtZdsuHEo8BdKKJP39yDl4rw5hag/2wagehY6c/nX/mrwrg75Dqgw0TJWgFh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773435524; c=relaxed/simple;
	bh=FY95oARvzfyJxaRn4kOC4ioFDdSacj4Az4fgX5W7CXc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=XXsgrJFpRddjOOBZpEbd1wOgnyJU5Eh5XHZ6xm6ux8mm71GoPxmmrnJmoogiKub61xbYwKsUkQ8rrkVey/BZ1dQGDPg8vocrw8rtOE/gNE6GzcX5BLbz8U7nAHQNzkY3NVijnM52RIyFy18+GV/1lF51YPgyPmJExyz56lcZ0V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bKqKFNxn; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so29420535e9.3
        for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 13:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773435520; x=1774040320; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j20/i3IEudm38MpoK3zSbvN6PwVMHMxginn+SRTHYFc=;
        b=bKqKFNxn3dgprB8JIuW2avLy1NAtJ5KWo/96ofviSIFenjUQQqYHQYHDjJWi2isSbm
         vh9HrbWf4q0+11NUS4pSS+XCsaUmIfLP0HfQ2lG6emgJs8nchNOXncG0WEoubGlnXeRy
         ByD//1iPNCPhee5D40+aNkr6w4mPeUs0PiJRywJ8ljAFQcqS/DEeOltAH30jC8onS+sw
         XCm3y5zMBZ5X/YFaez85idSc08O4vE/FZI0RDr8vwBFci1fpypp5dFz4Qna7dFM4pN23
         UAUkRlIeshScXnjy/LYk+0NwKauRde/bkblsPDyURWaoF4vXzVKLwE8JH78AC8y18qXG
         b9jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773435520; x=1774040320;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j20/i3IEudm38MpoK3zSbvN6PwVMHMxginn+SRTHYFc=;
        b=NDRj+ubSr+ZV50YR7WgJhIPicUTKomnYHk5tM4jllX6G+u8ZIxbRlXbmPpd640qC+h
         SEH8KDcwbxkpiR6drs3cDokRJ7aAbq7TYd0PsxyCEGEvVx28fjwx8uO4TN3p5wnsiGsR
         Zl4Hr1P0LQe5WXJYXLp7Ww0ENYT/1WugRXVLP659mv/br2XXwd0xK5WkaqjpX9g0Sjcc
         ZUD7NbJx5WVt4yJj161vm8uJkpiM/F5AueFGrrjafjK1phvm/Ov6M4bAqwOaQ5r2XlXQ
         A+prMi3AcYXlXxuDKeNXaoExYNtFNinBOL0APTzeDW6E5bb1EiSlPakNgHTWCUu6rqI/
         WgiA==
X-Gm-Message-State: AOJu0YxRSXVrlqzvQUVNb3pmlZwib8gBPR8QUwf2UuAPh55ZNt+LSamX
	WwAMKprcsvzkoHYzkAsCPesBvYGVXZtVCxMacWdkdpRfrr+WOHAXCoYfAT4vhkFchj8=
X-Gm-Gg: ATEYQzzCFOv7EP1V6nc4UAh7kE3oeeaqMlhpcoED8cmfwBk3S5oRugnJMqjzgCzIUG5
	Vdyj9ImLW4OaPbiGoZTetILRNNVezMSI2tMZpXGodewrZhWNpaW8K6WeIpjtxcY0o+BLzEDZv6j
	9DW/sehaaBetQVKz17LtB2c/UvEOYvtdstcDWtTrehIhKuTPIYdxGzKCMsdazc2WZ2RNffCktW5
	dI0JR82bzU5Eh+tGYpCuoVzxB0KgXUGdSK13TxqskmBMSBOv4Nx/cpUx11t6QoymbEb2C1X5eQM
	f+ZQrwVXybW6ZLS9LDwVlGxZ0LqtY+IR/DF/DGFZtapQX24C+ikRw5RYFILZ8rNc4jpkebdm+Ea
	tHW8SDyvNm84nH3PY4GIUbEU5Xntvx3/rgtRf9qudROmZ1zJFZnBouGmvilAt69oBCJu3PYpqIK
	C3j0HXYQWOF2vVwE2xZn2h
X-Received: by 2002:a05:600c:a09:b0:485:3f72:324d with SMTP id 5b1f17b1804b1-485566ddac0mr84382565e9.14.1773435519622;
        Fri, 13 Mar 2026 13:58:39 -0700 (PDT)
Received: from [127.0.0.1] ([2804:5078:834:1300:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab526d3csm4042611eec.18.2026.03.13.13.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:58:38 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH 0/8] kselftests: livepatch: Adapt tests to be executed on
 4.12 kernels
Date: Fri, 13 Mar 2026 17:58:31 -0300
Message-Id: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHd6tGkC/yXMUQqDMBCE4avIPrsQI7bVq4gPGsd2RVSyUQTx7
 k3t48fwz0kKL1CqkpM8dlFZ5ogsTch92vkNlj6arLEPk5uSp5UDNCgvU8+DHFAeyqJoO/eCs0+
 K4epxD7Grm79160a48Hui6/oCapfNLHYAAAA=
X-Change-ID: 20260309-lp-tests-old-fixes-f955abc8ec27
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773435515; l=1911;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=FY95oARvzfyJxaRn4kOC4ioFDdSacj4Az4fgX5W7CXc=;
 b=7JNUC+UvPAPTZWkz1aYQjRun4meZ6eGgR6ZZ2b/ha/drVnC1Rpa6USkYCYDEHOe7dYMOnpc6K
 qy3l3kt0+P4AUAdgdm2XsRbOBclBkoQPPwsy1EQ2oQfO1IQoBthwj2z
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2197-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: 88390289F3F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

These patches don't really change how the patches are run, just skip
some tests on kernels that don't support a feature (like kprobe and
livepatched living together) or when a livepatch sysfs attribute is
missing.

The last patch slightly adjusts check_result function to skip dmesg
messages on SLE kernels when a livepatch is removed.

These patches are based on printk/for-next branch.

Please review! Thanks!

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
Marcos Paulo de Souza (8):
      selftests: livepatch: test-syscall: Check for ARCH_HAS_SYSCALL_WRAPPER
      selftests: livepatch: test-kprobe: Replace true/false mod param by 1/0
      selftests: livepatch: test-kprobe: Check if kprobes can work with livepatches
      selftests: livepatch: functions: Introduce check_sysfs_exists
      selftests: livepatch: sysfs: Split tests of replace attribute
      selftests: livepatch: sysfs: Split tests of stack_order attribute
      selftests: livepatch: sysfs: Split tests of patched attribute
      selftests: livepatch: functions.sh: Extend check for taint flag kernel message

 tools/testing/selftests/livepatch/Makefile         |   3 +
 tools/testing/selftests/livepatch/functions.sh     |  16 +-
 tools/testing/selftests/livepatch/test-kprobe.sh   |  54 ++++---
 .../selftests/livepatch/test-sysfs-patched-attr.sh |  95 ++++++++++++
 .../selftests/livepatch/test-sysfs-replace-attr.sh |  75 ++++++++++
 .../selftests/livepatch/test-sysfs-stack-attr.sh   | 121 +++++++++++++++
 tools/testing/selftests/livepatch/test-sysfs.sh    | 164 ---------------------
 .../livepatch/test_modules/test_klp_syscall.c      |   7 +-
 8 files changed, 344 insertions(+), 191 deletions(-)
---
base-commit: 920e5001f4beb38685d5b8cac061cb1d2760eeab
change-id: 20260309-lp-tests-old-fixes-f955abc8ec27

Best regards,
--  
Marcos Paulo de Souza <mpdesouza@suse.com>


