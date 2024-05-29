Return-Path: <live-patching+bounces-295-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 617AE8D38E7
	for <lists+live-patching@lfdr.de>; Wed, 29 May 2024 16:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 812851C20AAC
	for <lists+live-patching@lfdr.de>; Wed, 29 May 2024 14:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F034F14534D;
	Wed, 29 May 2024 14:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZHebotvB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ECZTtnEu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D261386A7;
	Wed, 29 May 2024 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716991998; cv=none; b=ESAQO5A0mIbTCZTCHBXOQRzsHtJiDsDXmx1y4aRqDCYJFXdNzmvT0mlZQqBm+3hrMvJytfONb87qYHOvtGaljwshx1cG4TE309q3+6a0566GbtSQ+WoeSCtOilWGkoQiQqPJTPG8X6kVRYuBI2yQv8WVPAKFWZciKF4KKqapN2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716991998; c=relaxed/simple;
	bh=vhrBHK1oYqyYTQQ2KrX7GUmYkG+lYSlCKJrAJ9ciRt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BG5DISSfZAOU8ITqywzwEVoghWypWyLRKroKGGqEtGRCc04cpoxtYZY3wRiDttO7423FuEoyqZU+cBsRPN7Mddv5MTVy0WwCK5oTEkR7w/jFUIXGrzYb8B+g227F66SWQI7YIE6WHBTxpbO8sHReC77KahZgguL/V1mDPt2qjxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZHebotvB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ECZTtnEu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EDF1B336BB;
	Wed, 29 May 2024 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1716991995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Obvm5kCvdEN1g3yJAksMyUYT29qKH1+PG1MggvgBEpc=;
	b=ZHebotvBjTBb6ucKA+ydBuXs+AggyZZDheBcGKeOeGjbyOGDXHBHGvrndF4ROJsPxI+3eT
	4iO7bs1BF8dSPGEA+N7ESs866pf70uQsDCUoD0b+Re0dPIysU9MzOmqmvxfqjWJWu/q1ol
	dlbpuNn/gcm1+lJxt2oAQSOnWdrzfgA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ECZTtnEu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1716991994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Obvm5kCvdEN1g3yJAksMyUYT29qKH1+PG1MggvgBEpc=;
	b=ECZTtnEunVD07ng06cHfL2A3+ArV5U2ynd6mv1GQ8i+fFkNtsWVaDKyKbi3O02mgiAodI5
	jGwiclY1fMCYP15PzmVppJeHVP2RpbarCa7RBQJJULondhpgQhCf7qRCOB1rddYH2L7MrX
	77+l+KC3zI2npr+B79ofBX4QoDb20js=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 89F461372E;
	Wed, 29 May 2024 14:13:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CP9UFvo3V2bvWgAAD6G6ig
	(envelope-from <mpdesouza@suse.com>); Wed, 29 May 2024 14:13:14 +0000
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: mpdesouza@suse.com,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nstange@suse.de
Subject: Re: [PATCH 1/2] docs/livepatch: Add new compiler considerations doc
Date: Wed, 29 May 2024 11:12:44 -0300
Message-ID: <20240529141309.18902-1-mpdesouza@suse.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <alpine.LSU.2.21.2009021452560.23200@pobox.suse.cz>
References: 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: EDF1B336BB
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:email,suse.cz:email];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]

From: mpdesouza@suse.com

On   Wed, 2 Sep 2020 15:45:33 +0200 (CEST)   Miroslav Benes <mbenes@suse.cz> wrote:

> Hi,
> 
> first, I'm sorry for the late reply. Thanks, Josh, for the reminder.
> 
> CCing Nicolai. Nicolai, could you take a look at the proposed 
> documentation too, please? You have more up-to-date experience.
> 
> On Tue, 21 Jul 2020, Joe Lawrence wrote:
> 
> > +Examples
> > +========
> > +
> > +Interprocedural optimization (IPA)
> > +----------------------------------
> > +
> > +Function inlining is probably the most common compiler optimization that
> > +affects livepatching.  In a simple example, inlining transforms the original
> > +code::
> > +
> > +	foo() { ... [ foo implementation ] ... }
> > +
> > +	bar() { ...  foo() ...  }
> > +
> > +to::
> > +
> > +	bar() { ...  [ foo implementation ] ...  }
> > +
> > +Inlining is comparable to macro expansion, however the compiler may inline
> > +cases which it determines worthwhile (while preserving original call/return
> > +semantics in others) or even partially inline pieces of functions (see cold
> > +functions in GCC function suffixes section below).
> > +
> > +To safely livepatch ``foo()`` from the previous example, all of its callers
> > +need to be taken into consideration.  For those callers that the compiler had
> > +inlined ``foo()``, a livepatch should include a new version of the calling
> > +function such that it:
> > +
> > +  1. Calls a new, patched version of the inlined function, or
> > +  2. Provides an updated version of the caller that contains its own inlined
> > +     and updated version of the inlined function
> 
> I'm afraid the above could cause a confusion...
> 
> "1. Calls a new, patched version of the inlined function, or". The 
> function is not inlined in this case. Would it be more understandable to 
> use function names?
> 
> 1. Calls a new, patched version of function foo(), or
> 2. Provides an updated version of bar() that contains its own inlined and 
>    updated version of foo() (as seen in the example above).
> 
> Not to say that it is again a call of the compiler to decide that, so one 
> usually prepares an updated version of foo() and updated version of bar() 
> calling to it. Updated foo() has to be there for non-inlined cases anyway.
> 
> > +
> > +Other interesting IPA examples include:
> > +
> > +- *IPA-SRA*: removal of unused parameters, replace parameters passed by
> > +  referenced by parameters passed by value.  This optimization basically
> 
> s/referenced/reference/
> 
> > +  violates ABI.
> > +
> > +  .. note::
> > +     GCC changes the name of function.  See GCC function suffixes
> > +     section below.
> > +
> > +- *IPA-CP*: find values passed to functions are constants and then optimizes
> > +  accordingly Several clones of a function are possible if a set is limited.
> 
> "...accordingly. Several..."
> 
> [...]
> 
> > +  	void cdev_put(struct cdev *p)
> > +  	{
> > +  		if (p) {
> > +  			struct module *owner = p->owner;
> > +  			kobject_put(&p->kobj);
> > +  			module_put(owner);
> > +  		}
> > +  	}
> 
> git am complained here about whitespace damage.
> 
> [...]
> 
> > +kgraft-analysis-tool
> > +--------------------
> > +
> > +With the -fdump-ipa-clones flag, GCC will dump IPA clones that were created
> > +by all inter-procedural optimizations in ``<source>.000i.ipa-clones`` files.
> > +
> > +kgraft-analysis-tool pretty-prints those IPA cloning decisions.  The full
> > +list of affected functions provides additional updates that the source-based
> > +livepatch author may need to consider.  For example, for the function
> > +``scatterwalk_unmap()``:
> > +
> > +::
> > +
> > +  $ ./kgraft-ipa-analysis.py --symbol=scatterwalk_unmap aesni-intel_glue.i.000i.ipa-clones
> > +  Function: scatterwalk_unmap/2930 (include/crypto/scatterwalk.h:81:60)
> > +    isra: scatterwalk_unmap.isra.2/3142 (include/crypto/scatterwalk.h:81:60)
> > +      inlining to: helper_rfc4106_decrypt/3007 (arch/x86/crypto/aesni-intel_glue.c:1016:12)
> > +      inlining to: helper_rfc4106_decrypt/3007 (arch/x86/crypto/aesni-intel_glue.c:1016:12)
> > +      inlining to: helper_rfc4106_encrypt/3006 (arch/x86/crypto/aesni-intel_glue.c:939:12)
> > +
> > +    Affected functions: 3
> > +      scatterwalk_unmap.isra.2/3142 (include/crypto/scatterwalk.h:81:60)
> > +      helper_rfc4106_decrypt/3007 (arch/x86/crypto/aesni-intel_glue.c:1016:12)
> > +      helper_rfc4106_encrypt/3006 (arch/x86/crypto/aesni-intel_glue.c:939:12)
> 
> The example for the github is not up-to-date. The tool now expects 
> file_list with *.ipa-clones files and the output is a bit different for 
> the recent kernel.
> 
> $ echo arch/x86/crypto/aesni-intel_glue.c.000i.ipa-clones | kgraft-ipa-analysis.py --symbol=scatterwalk_unmap /dev/stdin
> Parsing file (1/1): arch/x86/crypto/aesni-intel_glue.c.000i.ipa-clones
> Function: scatterwalk_unmap/3935 (./include/crypto/scatterwalk.h:59:20) [REMOVED] [object file: arch/x86/crypto/aesni-intel_glue.c.000i.ipa-clones]
>   isra: scatterwalk_unmap.isra.8/4117 (./include/crypto/scatterwalk.h:59:20) [REMOVED]
>     inlining to: gcmaes_crypt_by_sg/4019 (arch/x86/crypto/aesni-intel_glue.c:682:12) [REMOVED] [edges: 4]
>       constprop: gcmaes_crypt_by_sg.constprop.13/4182 (arch/x86/crypto/aesni-intel_glue.c:682:12)
> 
>   Affected functions: 3
>     scatterwalk_unmap.isra.8/4117 (./include/crypto/scatterwalk.h:59:20) [REMOVED]
>     gcmaes_crypt_by_sg/4019 (arch/x86/crypto/aesni-intel_glue.c:682:12) [REMOVED]
>     gcmaes_crypt_by_sg.constprop.13/4182 (arch/x86/crypto/aesni-intel_glue.c:682:12)
> 
> 
> 
> The rest looks great. Thanks a lot, Joe, for putting it together.

I think that we should start provinding a "Livepatch creation how-to", something
similar, but for now I believe that some documentation is better than no
documentation. This document can evolve to reach such point in the future, but
for now, with Miroslav suggestions applied:

Acked-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> 
> Miroslav

