Return-Path: <live-patching+bounces-2920-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OEVdAtVCGGoEiAgAu9opvQ
	(envelope-from <live-patching+bounces-2920-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 15:27:49 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ADCA5F2B56
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 15:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6329303C616
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 13:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291343F1AC9;
	Thu, 28 May 2026 13:22:10 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1BC3ADB92;
	Thu, 28 May 2026 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779974530; cv=none; b=tOnVgoUUr6W1mOMVjFoNpAImolqmM6U0fYVgBnDyhPvgI+jRgVGC5M1e4ljwbG2UgL3MMXK1ZDF2JrLKkBk29f7+IvR+aN6H59oCoZVsGVbFjloQd98H3eM6rjYp+DQPKTbKuIQs9/B/dMPUln4u/PJv9qmfJE/RzrO+KkMAZwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779974530; c=relaxed/simple;
	bh=2ekTIatk62sZzZ8tZUZ0otPWrQdfbtlkaUx67BltbuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EoQXgUUSU6UZhOqeNgGWto8rldqbrMJ5kj2dXcuLwbP/bniVZZ/hEeUH7Whz2TYzG1Ba3lGt8YeaT9r6Jg0WfCig1NYKu5nc6pSCEYAg9IODFh7pxPlwO1gGQ5uGmVTjnu+k6WKfTbh8su0N9Jl3NkIaP3KjuB8d6OwEUZgtwNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6EB691291;
	Thu, 28 May 2026 13:22:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id 1DAA66000B;
	Thu, 28 May 2026 13:21:55 +0000 (UTC)
Date: Thu, 28 May 2026 09:21:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Wang Han <wanghan@linux.alibaba.com>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Chen Pei
 <cp0613@linux.alibaba.com>, Andy Chiu <andybnac@gmail.com>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>, Deepak Gupta
 <debug@rivosinc.com>, Puranjay Mohan <puranjay@kernel.org>, Conor Dooley
 <conor.dooley@microchip.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Jiri
 Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek
 <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan
 <shuah@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar
 <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung
 Kim <namhyung@kernel.org>, oliver.yang@linux.alibaba.com,
 xueshuai@linux.alibaba.com, zhuo.song@linux.alibaba.com,
 jkchen@linux.alibaba.com, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 1/8] scripts/sorttable: Handle RISC-V patchable
 ftrace entries
Message-ID: <20260528092153.3dde1f75@fedora>
In-Reply-To: <20260528082310.1994388-2-wanghan@linux.alibaba.com>
References: <20260527123530.2593918-1-wanghan@linux.alibaba.com>
	<20260528082310.1994388-2-wanghan@linux.alibaba.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y5camjc9dq17akqc8a4ytz8k7nu8tn9j
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19+XNKwFj7vcD6hXiG6uERbHZyLuR0djpo=
X-HE-Tag: 1779974515-628892
X-HE-Meta: U2FsdGVkX18VcIqhm50kLxPOB3gcckHG8D9zxu9RUuDTpvurJwnwC9DCuK0bHlovUrLkBgtChRPAeWd3bSgQnEtThR0D/Y+waAep/t8lPMRwyO+WXzPPq17Wh6YJaGjsLM6y0veINnetKl4fkjCkPAtIP5NAtjGDlno1aGlBsZ1XocfwxMFxbNnxwLvBj/TYs3J9u+dRjYOR/Mg+3qQkdfqWqcV/JA0Q3B8kVrIgy6rpI0QjJD6j1H7nGkUO1dXkuBFGgWoLIBBWCcL+JQMRl9FjjT/mXMiBrd5KCj3i9qpzhY3eVbIlLsvxCueYZZJhSJMLb8LvBE6a/i1bpBnEyOnltGpzbhQaYrGEfJd+9Lb9WmYrUz2Jsf/lsWcxNF/A8q7o0A0p3mVSj017EaZnJ6TATI715U/1NyOfE6vaT0I=
X-Spamd-Result: default: False [-0.86 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[goodmis.org : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2920-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[34];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,arm.com,linux.alibaba.com,gmail.com,rivosinc.com,microchip.com,suse.cz,suse.com,redhat.com,infradead.org,lists.infradead.org,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rostedt@goodmis.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.994];
	TAGGED_RCPT(0.00)[live-patching];
	R_DKIM_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[goodmis.org:email,alibaba.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 6ADCA5F2B56
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 28 May 2026 16:23:03 +0800
Wang Han <wanghan@linux.alibaba.com> wrote:

> RISC-V uses -fpatchable-function-entry=8,4 when the compressed ISA is
> enabled and -fpatchable-function-entry=4,2 otherwise. In both cases, the
> patchable NOP area starts 8 bytes before the function symbol address.
> The __mcount_loc entries therefore point at the patchable NOP area
> associated with a function, while nm reports the function symbol at the
> entry address used for the function range check.
> 
> After RISC-V selected HAVE_BUILDTIME_MCOUNT_SORT, sorttable started
> applying that range check at build time. Without allowing entries just
> before the reported function address, the mcount sorter treats valid
> RISC-V ftrace callsites as invalid weak-function entries and writes
> them back as zero. The resulting kernel boots with no ftrace entries,
> breaking dynamic ftrace and users such as livepatch.
> 
> The failure is silent during the final link because zeroing weak-function
> entries is an expected sorttable operation. At boot, those zero entries
> are skipped by ftrace_process_locs(), so the only obvious symptom is that
> the vmlinux ftrace table has lost valid callsites and ftrace users cannot
> attach to them.
> 
> CONFIG_FTRACE_SORT_STARTUP_TEST also reports the table as sorted in this
> state: it only checks that the __mcount_loc entries are in ascending
> order, which a fully zeroed table trivially satisfies. The original
> commit relied on this check and did not see the regression.
> 
> On an affected RISC-V QEMU boot with both CONFIG_FTRACE_SORT_STARTUP_TEST
> and CONFIG_FTRACE_STARTUP_TEST enabled, the sort check still passes
> while ftrace reports zero usable entries and the early selftests fail:
> 
>   [    0.000000] ftrace section at ffffffff8101da98 sorted properly
>   [    0.000000] ftrace: allocating 0 entries in 128 pages
>   [    0.054999] Testing tracer function: .. no entries found ..FAILED!
>   [    0.172407] tracer: function failed selftest, disabling
>   [    0.178186] Failed to init function_graph tracer, init returned -19
> 
> Handle RISC-V like arm64 for the function-range check and allow
> patchable entries up to 8 bytes before the function address.
> 
> With this fix, a RISC-V QEMU smoke boot with ftrace startup tests shows
> the vmlinux ftrace table is populated and dynamic ftrace still works:
> 
>   [    0.000000] ftrace: allocating 46749 entries in 184 pages
>   [    0.051115] Testing tracer function: PASSED
>   [    1.283782] Testing dynamic ftrace: PASSED
>   [    6.275456] Testing tracer function_graph: PASSED
> 
> Fixes: 0ca1724b56af ("riscv: ftrace: select HAVE_BUILDTIME_MCOUNT_SORT")
> Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Link: https://lore.kernel.org/all/20260527113028.4b21a5de@fedora/
> Signed-off-by: Wang Han <wanghan@linux.alibaba.com>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

