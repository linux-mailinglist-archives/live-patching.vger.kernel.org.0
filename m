Return-Path: <live-patching+bounces-2908-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIbpNs/UF2qOSAgAu9opvQ
	(envelope-from <live-patching+bounces-2908-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 07:38:23 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 802315ECE9E
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 07:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 48306300D1DB
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 05:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C5514ABE;
	Thu, 28 May 2026 05:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EaSUVzRC"
X-Original-To: live-patching@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374A31A680F;
	Thu, 28 May 2026 05:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779946698; cv=none; b=SJgVFGRKhTC8mUyPOq1Dsor/FQbTfWZ1vR1qghBngYFz6r36xWwR9lGm6SXKRpNrN74CBbjgTN8a1tkSNSmlYYHYvtNEX999HgOvj+3bpkigwYAxF4EbWFXA5rxOURmW9u5WziFJ6yYFSIx+wTl0KybRbuEXu/JPHnHS/+5lNqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779946698; c=relaxed/simple;
	bh=KzgnllfJFQ+v4lXzMi8bI9BcYh/VEPg5mHFqINwn6ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ie0AwwDjSQkwDRVQwnuWydRUExkeifhA4NgkCfl4SQSL1yLfUPaHIAG4EP/z1uofJQDXwN8CBH2kgfNUW8aNAVK28Umci+RrHokvygdXhaAG0tg2WfyPkb4KISPZln9+qfTF/ulHhzH1+q55TkqLNtiFuwzBULiAggq6v8+zcBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EaSUVzRC; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779946693; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=g9xXdOEeD6a9QCmlif50MRE5E3DhBPqmO64p4ySl0/c=;
	b=EaSUVzRCf2pR9AZoP0ovS2qOpYU3tTTIDnnn80Xv4o0v9zgeZElevPZpqIlaWvmf4W1aMe2/pzx1qShphfRsMYF5H1u357heUzbkVTvQCPuVJOY5VSUNZ39M3JdX1pLXfCHJU/srK3Kb+4ir5/8aazFRdLaQgSvto7qT+JgDHUY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=wanghan@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0X3lY9RP_1779946689;
Received: from wanghan-Workstation..(mailfrom:wanghan@linux.alibaba.com fp:SMTPD_---0X3lY9RP_1779946689 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 May 2026 13:38:11 +0800
From: Wang Han <wanghan@linux.alibaba.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
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
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 1/8] scripts/sorttable: Handle RISC-V patchable ftrace entries
Date: Thu, 28 May 2026 13:38:06 +0800
Message-ID: <20260528053807.1511742-1-wanghan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260527113028.4b21a5de@fedora>
References: <20260527123530.2593918-1-wanghan@linux.alibaba.com> <20260527123530.2593918-2-wanghan@linux.alibaba.com> <20260527113028.4b21a5de@fedora>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-8.16 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2908-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[30];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,arm.com,linux.alibaba.com,gmail.com,rivosinc.com,microchip.com,suse.cz,suse.com,redhat.com,infradead.org,lists.infradead.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wanghan@linux.alibaba.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,goodmis.org:email]
X-Rspamd-Queue-Id: 802315ECE9E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

[Resend: my first reply went out as a private message to Steve only,
due to a local git send-email config quirk that dropped the Cc list.
Re-sending now with the original cc list so the discussion is
on-record. Sorry for the duplicate, Steve.]

On Wed, 27 May 2026 11:30:28 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> So basically RISCV has the same problem as ARM64 with patchable
> entries. As this may happen for other archs in the future, I would like
> to group them together like this:
[...]
> does the above work for you? (Although I didn't even compile test it).

Yes, this is clearly better - a single grouped block makes future
patchable-entry architectures trivial to add. I will fold it into v2
with two small adjustments to keep it compiling cleanly:

  - s/case RISCV/case EM_RISCV/ (two places).
  - Put the shared "before_func = 8" on its own line under
    case EM_RISCV: with a standard /* fallthrough */ comment,
    otherwise GCC -Wimplicit-fallthrough warns between EM_AARCH64
    and EM_RISCV.

Resulting switch:

	switch (elf_map_machine(ehdr)) {
	#ifdef MCOUNT_SORT_ENABLED
	case EM_AARCH64:
		sort_reloc = true;
		rela_type = 0x403;
		/* fallthrough */
	case EM_RISCV:
		/* arm64 and RISC-V place patchable entries before the function */
		before_func = 8;
	#else
	case EM_AARCH64:
	case EM_RISCV:
	#endif
		/* fallthrough */
	case EM_386:
	case EM_LOONGARCH:
	case EM_S390:
	case EM_X86_64:
		custom_sort = sort_relative_table_with_data;
		break;

Built scripts/sorttable with the kernel host build (both with and
without MCOUNT_SORT_ENABLED), no warnings. I'll add your Suggested-by
and send v2 shortly.

Thanks!
Wang Han

