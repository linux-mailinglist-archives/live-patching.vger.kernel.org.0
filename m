Return-Path: <live-patching+bounces-2898-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KFb+Mt3lFmpVvwcAu9opvQ
	(envelope-from <live-patching+bounces-2898-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 14:38:53 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4285E44AC
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 14:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 519B73059FD8
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 12:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A60DF4028E3;
	Wed, 27 May 2026 12:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="AXwwV4T6"
X-Original-To: live-patching@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A822EC0AE;
	Wed, 27 May 2026 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885341; cv=none; b=Azmic2qtzgGJWv5UdWswyCV71D+DCBr6BfU0fFXH5Yq0R0crL9QF/zbVtzijKvq/X4ztMsutoTnACchcxZjLxtYwGp1DVQ4+GrD6bz3TeuMVdXX8BgiJk9/kLxokRszuYpPmz/nRdMgxq/dOfZoPw/xiSfVI4aCXyC4UQEQFIBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885341; c=relaxed/simple;
	bh=fcjNG7HaUfz+LoWuYjJ1ldBXvy79ll4GvYlw8k5AYKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZRQs1tQGgNB7nPCg2nJBLxC9NkP2U1G47yxVVLCAEgvXDSh6l0bm16h2FTgsc6nIu874Yw8S9z8Ryln4Xp+aXzP8sPn8azv9/1MO60tlAA1d4BJDmWyv3SpWWFMY2qmKs3+xM58eSbeHekwvQ30Nr32I2EKegRppKNcjUUqgaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=AXwwV4T6; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779885336; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Zpi+hBQSRQyziQ4dlT38MsXVu/GjD/Q4OPV9k9v34nc=;
	b=AXwwV4T6ASFAWn5BK4AM9FMTKFVRJjsbx9hrOST9eoS07HqhUJtLXBDeyZfgFi74Aevqphz7W+hZSY3yLZDNgPr7rPalYamdRVsQVkPyd8oPAkVHok8Ebot0RHSCx0d1Ea8TRDNB7AHJx9fcqSUkQEKaxV8P42BruEPaVT/+zdc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=wanghan@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0X3jh1AO_1779885333;
Received: from wanghan-Workstation..(mailfrom:wanghan@linux.alibaba.com fp:SMTPD_---0X3jh1AO_1779885333 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 20:35:34 +0800
From: Wang Han <wanghan@linux.alibaba.com>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Pei <cp0613@linux.alibaba.com>,
	Andy Chiu <andybnac@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: [PATCH 1/8] scripts/sorttable: Handle RISC-V patchable ftrace entries
Date: Wed, 27 May 2026 20:35:23 +0800
Message-ID: <20260527123530.2593918-2-wanghan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260527123530.2593918-1-wanghan@linux.alibaba.com>
References: <20260527123530.2593918-1-wanghan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2898-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[ghiti.fr,goodmis.org,kernel.org,arm.com,linux.alibaba.com,gmail.com,rivosinc.com,microchip.com,suse.cz,suse.com,redhat.com,infradead.org,lists.infradead.org,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[30];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wanghan@linux.alibaba.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,alibaba.com:email,linux.alibaba.com:mid,linux.alibaba.com:dkim]
X-Rspamd-Queue-Id: 3E4285E44AC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

RISC-V uses -fpatchable-function-entry=8,4 when the compressed ISA is
enabled and -fpatchable-function-entry=4,2 otherwise. In both cases, the
patchable NOP area starts 8 bytes before the function symbol address.
The __mcount_loc entries therefore point at the patchable NOP area
associated with a function, while nm reports the function symbol at the
entry address used for the function range check.

After RISC-V selected HAVE_BUILDTIME_MCOUNT_SORT, sorttable started
applying that range check at build time. Without allowing entries just
before the reported function address, the mcount sorter treats valid
RISC-V ftrace callsites as invalid weak-function entries and writes
them back as zero. The resulting kernel boots with no ftrace entries,
breaking dynamic ftrace and users such as livepatch.

The failure is silent during the final link because zeroing weak-function
entries is an expected sorttable operation. At boot, those zero entries
are skipped by ftrace_process_locs(), so the only obvious symptom is that
the vmlinux ftrace table has lost valid callsites and ftrace users cannot
attach to them.

CONFIG_FTRACE_SORT_STARTUP_TEST also reports the table as sorted in this
state: it only checks that the __mcount_loc entries are in ascending
order, which a fully zeroed table trivially satisfies. The original
commit relied on this check and did not see the regression.

On an affected RISC-V QEMU boot with both CONFIG_FTRACE_SORT_STARTUP_TEST
and CONFIG_FTRACE_STARTUP_TEST enabled, the sort check still passes
while ftrace reports zero usable entries and the early selftests fail:

  [    0.000000] ftrace section at ffffffff8101da98 sorted properly
  [    0.000000] ftrace: allocating 0 entries in 128 pages
  [    0.054999] Testing tracer function: .. no entries found ..FAILED!
  [    0.172407] tracer: function failed selftest, disabling
  [    0.178186] Failed to init function_graph tracer, init returned -19

Handle RISC-V like arm64 for the function-range check and allow
patchable entries up to 8 bytes before the function address.

With this fix, a RISC-V QEMU smoke boot with ftrace startup tests shows
the vmlinux ftrace table is populated and dynamic ftrace still works:

  [    0.000000] ftrace: allocating 46749 entries in 184 pages
  [    0.051115] Testing tracer function: PASSED
  [    1.283782] Testing dynamic ftrace: PASSED
  [    6.275456] Testing tracer function_graph: PASSED

Fixes: 0ca1724b56af ("riscv: ftrace: select HAVE_BUILDTIME_MCOUNT_SORT")

Signed-off-by: Wang Han <wanghan@linux.alibaba.com>
---
 scripts/sorttable.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/scripts/sorttable.c b/scripts/sorttable.c
index e8ed11c680c6..b4061c2c03e1 100644
--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -901,11 +901,17 @@ static int do_file(char const *const fname, void *addr)
 		/* fallthrough */
 	case EM_386:
 	case EM_LOONGARCH:
-	case EM_RISCV:
 	case EM_S390:
 	case EM_X86_64:
 		custom_sort = sort_relative_table_with_data;
 		break;
+	case EM_RISCV:
+#ifdef MCOUNT_SORT_ENABLED
+		/* RISC-V uses patchable function entries before function entry. */
+		before_func = 8;
+#endif
+		custom_sort = sort_relative_table_with_data;
+		break;
 	case EM_PARISC:
 	case EM_PPC:
 	case EM_PPC64:
-- 
2.43.0


