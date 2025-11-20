Return-Path: <live-patching+bounces-1874-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B5AC73ED2
	for <lists+live-patching@lfdr.de>; Thu, 20 Nov 2025 13:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id E837E3097E
	for <lists+live-patching@lfdr.de>; Thu, 20 Nov 2025 12:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5CC335080;
	Thu, 20 Nov 2025 12:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OUorkC/s";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9xLM7fGP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OUorkC/s";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9xLM7fGP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD5031ED7D
	for <live-patching@vger.kernel.org>; Thu, 20 Nov 2025 12:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763640915; cv=none; b=S2Wo2DIQXJaTdgsuhbgdfVXY84aAm4AdJvRdfImAEEMzpLSXIXrJ8puzR5ekK8MEtfOjPtI3+ZYmSD1nGvX2cyrSUcB6lE9aAg9fP0AL4x8imECQTtvrydvAbYBKrruNSOGMC5mHpASxW95JKrPbQmoDj9M46A1pr9Z/G1b6akY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763640915; c=relaxed/simple;
	bh=3WKbXsxMskDbBlAGJjJzra5j3U/rD2Fk5IYz4XYY+eE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Xs/EyaN9M/pLcGnMLifD8ucn+9oh77jIztoFh+00K813bE3Ky4A19nSzhehFUqbXO42gkoBuvCuXZCEpM3QajYSMGSkILa9pzRYp7fe1cJ7q50Mop0QYKeQS9c+RFxm9+K3xBbGkhBeI8b0o9+6UsGZdic/ii12Z2WjysKcFLDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OUorkC/s; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9xLM7fGP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OUorkC/s; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9xLM7fGP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2CD5A21751;
	Thu, 20 Nov 2025 12:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763640912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/tL5e0kPmgJpzvdPMIT86AAv/0JhJuJT+SS0avjqEE4=;
	b=OUorkC/sn2qKfhz995/c13viHyBU9Qv38lpnBy4iYVIkGddWvnCzuymsJh3HnjeVC6W7Qa
	KxY95LGMqctNMXJughsZU1z/Co11F7UipSCTYKUwm09wumbI4kMQtzCx5/tsU770hM0rt5
	IRWGquXxJTHFUQcPf9ak4bgydlnpNzk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763640912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/tL5e0kPmgJpzvdPMIT86AAv/0JhJuJT+SS0avjqEE4=;
	b=9xLM7fGPX5AcP7u1pCmNLZw4Q1RmSMV5p5fF2GeZRuNyZbuGn1c/ERVTKTv+rVaJIYqvkK
	qxF8JwyJowk/CHAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763640912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/tL5e0kPmgJpzvdPMIT86AAv/0JhJuJT+SS0avjqEE4=;
	b=OUorkC/sn2qKfhz995/c13viHyBU9Qv38lpnBy4iYVIkGddWvnCzuymsJh3HnjeVC6W7Qa
	KxY95LGMqctNMXJughsZU1z/Co11F7UipSCTYKUwm09wumbI4kMQtzCx5/tsU770hM0rt5
	IRWGquXxJTHFUQcPf9ak4bgydlnpNzk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763640912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/tL5e0kPmgJpzvdPMIT86AAv/0JhJuJT+SS0avjqEE4=;
	b=9xLM7fGPX5AcP7u1pCmNLZw4Q1RmSMV5p5fF2GeZRuNyZbuGn1c/ERVTKTv+rVaJIYqvkK
	qxF8JwyJowk/CHAw==
Date: Thu, 20 Nov 2025 13:15:12 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
cc: bpf@vger.kernel.org, live-patching@vger.kernel.org, 
    DL Linux Open Source Team <linux-open-source@crowdstrike.com>, 
    Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>, 
    andrii@kernel.org, Raja Khan <raja.khan@crowdstrike.com>
Subject: Re: BPF fentry/fexit trampolines stall livepatch stalls transition
 due to missing ORC unwind metadata
In-Reply-To: <0e555733-c670-4e84-b2e6-abb8b84ade38@crowdstrike.com>
Message-ID: <alpine.LSU.2.21.2511201311570.16226@pobox.suse.cz>
References: <0e555733-c670-4e84-b2e6-abb8b84ade38@crowdstrike.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1678380546-51846447-1763640912=:16226"
X-Spam-Level: 
X-Spamd-Result: default: False [-3.28 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	CTYPE_MIXED_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.18)[-0.897];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	MIME_TRACE(0.00)[0:+,1:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -3.28

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-51846447-1763640912=:16226
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hello Andrey,

On Wed, 19 Nov 2025, Andrey Grodzovsky wrote:

> Hello BPF and livepatch teams,
> 
> This is somewhat a followup on
> https://lists.ubuntu.com/archives/kernel-team/2025-October/163881.html as we
> continue encounter issues and conflicts between BPF and livepatch.
> 
> We've encountered an issue between BPF fentry/fexit trampolines and kernel
> livepatching (kpatch/livepatch) on x86_64 systems with ORC unwinder enabled.
> I'm reaching out to understand if this is a known limitation and to explore
> potential solutions. I assume it's known as I see information along this lines
> in https://www.kernel.org/doc/Documentation/livepatch/reliable-stacktrace.rst
> 
> Problem Summary
> 
> When BPF programs attach to kernel functions using fentry/fexit hooks, the
> resulting JIT-compiled trampolines lack ORC unwind metadata. This causes
> livepatch transition stall when threads are blocked in hooked functions, as
> the stack becomes unreliable for unwinding purposes.
> 
> In our case the environment is
> 
> - RHEL 9.6 (kernel 5.14.0-570.17.1.el9_6.x86_64)
> - CONFIG_UNWINDER_ORC=y
> - CONFIG_BPF_JIT_ALWAYS_ON=y
> - BPF fentry/fexit hooks on inet_recvmsg()
> 
> Scenario:
> 1. BPF program attached to inet_recvmsg via fentry/fexit (creates BPF
> trampoline)
> 2. CIFS filesystem mounted (creates cifsd kernel thread)
> 3. cifsd thread blocks in inet_recvmsg → BPF trampoline is on the stack
> 4. Attempt to load kpatch module
> 5. Livepatch transition stalls indefinitely
> 
> Error Message (repeated every ~1 second):
> livepatch: klp_try_switch_task: cifsd:2886 has an unreliable stack
> 
> Stack trace showing BPF trampoline:
> cifsd           D  0  2886
> Call Trace:
>  wait_woken+0x50/0x60
>  sk_wait_data+0x176/0x190
>  tcp_recvmsg_locked+0x234/0x920
>  tcp_recvmsg+0x78/0x210
>  inet_recvmsg+0x5c/0x140
>  bpf_trampoline_6442469985+0x89/0x130  ← NO ORC metadata
>  sock_recvmsg+0x95/0xa0
>  cifs_readv_from_socket+0x1ca/0x2d0 [cifs]
>  ...
> 
> As far as I understand and please correct me if it's wrong -
> 
> The failure occurs in arch/x86/kernel/unwind_orc.c
> 
> orc = orc_find(state->signal ? state->ip : state->ip - 1);
> if (!orc) {
>     /*
>      * As a fallback, try to assume this code uses a frame pointer.
>      * This is useful for generated code, like BPF, which ORC
>      * doesn't know about.  This is just a guess, so the rest of
>      * the unwind is no longer considered reliable.
>      */
>     orc = &orc_fp_entry;
>     state->error = true;  // ← Marks stack as unreliable
> }
> 
> When orc_find() returns NULL for the BPF trampoline address, the unwinder
> falls back to frame pointers and marks the stack unreliable. This causes
> arch_stack_walk_reliable() to fail, which in turn causes livepatch's
> klp_check_stack() to return -EINVAL before even checking if to-be-patched
> functions are on the stack.
> 
> Key observations:
> 1. The kernel comment explicitly mentions "generated code, like BPF"
> 2. Documentation/livepatch/reliable-stacktrace.rst lists "Dynamically
> generated code (e.g. eBPF)" as causing unreliable stacks
> 3. Native kernel functions have ORC metadata from objtool during build
> 4. Ftrace trampolines have special ORC handling via orc_ftrace_find()
> 5. BPF JIT trampolines have no such handling - Is this correct ?

Yes, all you findings are correct and the above explains the situation 
really well. Thank you for summing it up.

> Impact
> 
> This affects production systems where:
> - Security/observability tools use BPF fentry/fexit hooks
> - Live kernel patching is required for security updates
> - Kernel threads may be blocked in hooked network/storage functions
> 
> The livepatch transition can stall for 60+ seconds before failing, blocking
> critical security patches.

Unfortunately yes.

> Questions for the Community
> 
> 1. Is this a known limitation (I assume yes) ?

Yes.

> 2. Runtime ORC generation? Could the BPF JIT generate ORC unwind entries for
> trampolines, similar to how ftrace trampolines are handled?
> 3. Trampoline registration? Could BPF trampolines register their address
> ranges with the ORC unwinder to avoid the "unreliable" marking?
> 4. Alternative unwinding? Could livepatch use an alternative unwinding method
> when BPF trampolines are detected (e.g., frame pointers with validation)?
> 5. Workarounds? I mention one bellow and I would be happy to hear if anyone
> has a better idea to propose ?

There is a parallel discussion going on under sframe unwiding enablement 
for arm64. See this subthread 
https://lore.kernel.org/all/CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com/T/#u

I would really welcome if it is solved eventually because it seems we will 
meet the described issue more and more often (Josh, I think this email 
shows that it happens in practice with the existing monitoring services 
based on BPF).

Regards,
Miroslav
--1678380546-51846447-1763640912=:16226--

