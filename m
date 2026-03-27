Return-Path: <live-patching+bounces-2261-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uMdKJrJjxmm+JAUAu9opvQ
	(envelope-from <live-patching+bounces-2261-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 12:02:10 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C98E134305C
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 12:02:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4A85931410E3
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 10:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605ED329E49;
	Fri, 27 Mar 2026 10:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="esgTEk2A";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qO8Jv29R";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ELyChpfD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="q6tfU2aD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8721330650
	for <live-patching@vger.kernel.org>; Fri, 27 Mar 2026 10:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774608411; cv=none; b=AXVlgM96DdpG6L7PkGnPFeijb6qSUqFOrv60g1C5CZ6Lm+ReQBNUUcKZD9245cv7hhgm1oXU/kNnotn4XA3jQeEn/fYFb5Qz2wq+9U274x7Cn0R7IuTKFwDoIpVX9lEyMVDUIIzl5NgE3dvsVhbm3EHyJTtxadlyQhOVjbDsrOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774608411; c=relaxed/simple;
	bh=lcSYNW/uwUu3VeMG/a+Pz7DxjC1TSMaACR0ZqsRz2nc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TL410P9tTcJw4w8GPOOulT9mjQ8zH8jIA5Gf88gSKtKLluO/Fq69XGbHa+sEQuimYWIq7csQDm0nN4GpCrY0A43j5WD4CzQ7F3DWQbzENJDWzASHxDTUiJ0J06Eod0EDxvnOvUTK7e7m+iom/OAIJUVwzqTkQH+O7eS1M4c8kHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=esgTEk2A; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qO8Jv29R; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ELyChpfD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=q6tfU2aD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0498C4D1E1;
	Fri, 27 Mar 2026 10:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774608408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3dIUJZjjmmsd1tModYnbExJ4mU9pGlHtsHU4YXsTeU=;
	b=esgTEk2AEzAmYF9l8zrClML+/jzbWBX/ewoqcJYD81mb83uqOvdBioWRsXGbfiHr4b7DKz
	yKn4hlvrpZUncT0I03AR8Ab6ECZFKkULXR/prJ8haWgKHpFGIaHmGk+J45kx4CHnnzM9sJ
	+lnMFleLXYw9GOqCU5yqLTx93YkfJNg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774608408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3dIUJZjjmmsd1tModYnbExJ4mU9pGlHtsHU4YXsTeU=;
	b=qO8Jv29R11Id5j37chrQ1Iu7CZ5jtV66Rh/GpQiEexKSnEjaeru/h52qsg/e9rylTSF9fy
	GlI2nTGwrx2dW7Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774608407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3dIUJZjjmmsd1tModYnbExJ4mU9pGlHtsHU4YXsTeU=;
	b=ELyChpfDFNWwAprcmR326hSY64zlFWL5mPJeGicewjzji6BWe6e8DTRAVhrTUHVnpQwFoc
	RoE7wtxWla4UvLdvWjBUTpuiL2rgEiLN0zYRWcI5LtutZaY+qxKTRaub7AiIpob+AsPfei
	A2SiZn7G8ZGhy61BCdXAiFuS8NzzIKg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774608407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3dIUJZjjmmsd1tModYnbExJ4mU9pGlHtsHU4YXsTeU=;
	b=q6tfU2aDiN4kZqxI2WxTuuag5h6eTboTTM/aM5jcNaTAA0y4R693AoZK+d2e2l32TD5qgv
	YQWxP7DKU0d3DTAQ==
Date: Fri, 27 Mar 2026 11:46:46 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Joe Lawrence <joe.lawrence@redhat.com>
cc: Petr Mladek <pmladek@suse.com>, Pablo Hugen <phugen@redhat.com>, 
    live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    linux-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org, 
    shuah@kernel.org
Subject: Re: [PATCH] selftests/livepatch: add test for module function
 patching
In-Reply-To: <acWZ3r2CoSDy_NLf@redhat.com>
Message-ID: <alpine.LSU.2.21.2603271143310.31210@pobox.suse.cz>
References: <20260320201135.1203992-1-phugen@redhat.com> <acVD_NPu4JVRoaVK@pathway.suse.cz> <acWZ3r2CoSDy_NLf@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2261-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,functions.sh:url,pobox.suse.cz:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C98E134305C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

> > > +disable_lp $MOD_TARGET_PATCH
> > > +unload_lp $MOD_TARGET_PATCH
> > > +
> > > +if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET: original output" ]] ; then
> > > +	echo -e "FAIL\n\n"
> > > +	die "livepatch kselftest(s) failed"
> > > +fi
> > > +
> > > +unload_mod $MOD_TARGET
> > > +
> > > +check_result "% insmod test_modules/$MOD_TARGET.ko
> > > +$MOD_TARGET: test_klp_mod_target_init
> > > +% insmod test_modules/$MOD_TARGET_PATCH.ko
> > 
> 
> So following this technique, all the other tests with command sequences
> would need to be re-written as '&&' chains, e.g. the "patch getpid
> syscall while being heavily hammered" one like:
> 
>   pid_list=$(echo "${pids[@]}" | tr ' ' ',') && \
>     load_lp $MOD_SYSCALL klp_pids=$pid_list && \
>     loop_until "grep -q '^0$' $SYSFS_KERNEL_DIR/$MOD_SYSCALL/npids" && \
>     log "$MOD_SYSCALL: Remaining not livepatched processes: $(cat $SYSFS_KERNEL_DIR/$MOD_SYSCALL/npids)"
> 
> so that we only continue down a particular test for as long as it's
> successful, then the cleanup code is unconditional:
> 
>   pending_pids=$(cat $SYSFS_KERNEL_DIR/$MOD_SYSCALL/npids)
>   log "$MOD_SYSCALL: Remaining not livepatched processes: $pending_pids"
> 
>   for pid in ${pids[@]}; do
>           kill $pid || true
>   done
> 
>   disable_lp $MOD_SYSCALL
>   unload_lp $MOD_SYSCALL
> 
>   check_result  <- flags a problem
> 
> Yeah, may be that's not so bad.  The functions.sh helpers may need to be
> hardened a little (can they cancel / bust a transition?  it's been a
> while since I've looked.) 
> 
> Or maybe ... ugh, bash is not a programming language ... each test is
> split into its own script, the die calls can remain as they are, but we
> move the cleanup logic into a trap EXIT handler so it always runs?

We use this technique in OOT https://github.com/SUSE/qa_test_klp/ tests 
(slowly being upstreamed). See 
https://github.com/SUSE/qa_test_klp/blob/master/klp_tc_functions.sh. 
Mainly klp_tc_init(), klp_tc_exit() and klp_tc_abort(). Different tests 
then use what you proposed above... caching pids and modules to clean up.

Miroslav

