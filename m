Return-Path: <live-patching+bounces-2915-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KLKuIQr9F2oTYQgAu9opvQ
	(envelope-from <live-patching+bounces-2915-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 10:30:02 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EF4945EE93E
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 10:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6EF56300EFA8
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 08:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84DB37BE70;
	Thu, 28 May 2026 08:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Ms4Xmale"
X-Original-To: live-patching@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFD7379C2E;
	Thu, 28 May 2026 08:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956618; cv=none; b=EMHULSlv1WySn5QNZiL3vK5jCTgiIgzB6oAsA7yMW/XsUIc2FBmeJkpptlRLqFH+rebUgC7+KD77+x4w5lgaFDN9A3OWqPzOLUCbiGz2a2nOd3Jm8jlzhOxkTA0TvJguQIH3xRU0gLllHGSqlPK3/Ad1J0+GuYK5SqwqO96vKls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956618; c=relaxed/simple;
	bh=+ecV+DRi5pcj6ULaSCDljcFW/MwhHlkG0Cg24xGoN9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9VhGBrixeweyXljNLOan3aq2ZAdDSdZY+YnYdm3oEibS5tNG1ymfIOi7UZYNQt/XG0Tf8ng3dNDhoqB7WPmA7ppO0iERBKjDXF55RKs8Qubuo+5whzY7zwPVtEFnEt20ioFUgbmDY2EXRrfpfgmEZ0mt3I4QbU/U/WkukZy1wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Ms4Xmale; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779956607; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=uOIFhnbfyUrG6uFjeBjHnCSmlcH4pBCMjyX4IXFTvXI=;
	b=Ms4XmalelNzyZu13TA7x+79JSF7PgjzGXMG+EMwL1K/C/oDjkIXObnYkAHY33mgFlTMQglkSb6nnmoepPYkaqELi4qVpGKonvdKaxyPEpeSyhSQfdkZ25q/9/ICW1v1fKMPwCr53SnpyoGwkNrLvebaTig4ifAwKOJOjboMK5nM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=wanghan@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0X3lxQQU_1779956603;
Received: from wanghan-Workstation..(mailfrom:wanghan@linux.alibaba.com fp:SMTPD_---0X3lxQQU_1779956603 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 May 2026 16:23:25 +0800
From: Wang Han <wanghan@linux.alibaba.com>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
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
	oliver.yang@linux.alibaba.com,
	xueshuai@linux.alibaba.com,
	zhuo.song@linux.alibaba.com,
	jkchen@linux.alibaba.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: [PATCH v2 7/8] riscv: Kconfig: enable HAVE_RELIABLE_STACKTRACE and HAVE_LIVEPATCH
Date: Thu, 28 May 2026 16:23:09 +0800
Message-ID: <20260528082310.1994388-8-wanghan@linux.alibaba.com>
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
	TAGGED_FROM(0.00)[bounces-2915-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[goodmis.org,ghiti.fr,kernel.org,arm.com,linux.alibaba.com,gmail.com,rivosinc.com,microchip.com,suse.cz,suse.com,redhat.com,infradead.org,lists.infradead.org,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.alibaba.com:mid,linux.alibaba.com:dkim,alibaba.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: EF4945EE93E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Now that the metadata frame records, the kunwind state machine and
arch_stack_walk_reliable() are all in place, advertise the capability
to the rest of the kernel:

  * select HAVE_RELIABLE_STACKTRACE under FRAME_POINTER && 64BIT, so
    only the configurations that actually have the metadata records
    and the FP-based reliable walker enable it.
  * select HAVE_LIVEPATCH under the same condition and source
    kernel/livepatch/Kconfig so the livepatch menu is reachable from
    the RISC-V configuration.

This is split out from the unwinder change so the policy decision and
the implementation can be reviewed and reverted independently.

Signed-off-by: Wang Han <wanghan@linux.alibaba.com>
---
 arch/riscv/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 674044754378..2921680d2132 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -185,6 +185,7 @@ config RISCV
 	select HAVE_KRETPROBES
 	# https://github.com/ClangBuiltLinux/linux/issues/1881
 	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if !LD_IS_LLD
+	select HAVE_LIVEPATCH if FRAME_POINTER && 64BIT
 	select HAVE_MOVE_PMD
 	select HAVE_MOVE_PUD
 	select HAVE_PAGE_SIZE_4KB
@@ -195,6 +196,7 @@ config RISCV
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
 	select HAVE_PREEMPT_DYNAMIC_KEY
 	select HAVE_REGS_AND_STACK_ACCESS_API
+	select HAVE_RELIABLE_STACKTRACE if FRAME_POINTER && 64BIT
 	select HAVE_RETHOOK
 	select HAVE_RSEQ
 	select HAVE_RUST if RUSTC_SUPPORTS_RISCV && CC_IS_CLANG
@@ -1394,3 +1396,5 @@ endmenu # "CPU Power Management"
 source "arch/riscv/kvm/Kconfig"
 
 source "drivers/acpi/Kconfig"
+
+source "kernel/livepatch/Kconfig"
-- 
2.43.0


