Return-Path: <live-patching+bounces-2273-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AMXOL6PNzGlFWwYAu9opvQ
	(envelope-from <live-patching+bounces-2273-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 01 Apr 2026 09:47:47 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FC13763FA
	for <lists+live-patching@lfdr.de>; Wed, 01 Apr 2026 09:47:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A4F2D300877A
	for <lists+live-patching@lfdr.de>; Wed,  1 Apr 2026 07:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D4537F017;
	Wed,  1 Apr 2026 07:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CGHbsyHr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="141OuvNb";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z4eYEgF2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="z3XHhETI"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB0937E2E9
	for <live-patching@vger.kernel.org>; Wed,  1 Apr 2026 07:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775029269; cv=none; b=ezb/HiijsbwfUjSs0dtnd3jw/nzP4lfek7T9NrMlgc91MUzocCvbZuze5P7IzmcCZm6Ha4iwvlgBHgJ5BZqwWj7Vz9CDsi6Br0HZ+FIDwoQS8kzlqJju9Eq1rCnQPgckHIZaXr7EZKvJOJ/obfIfSGoMh8Ome/A4tQsyX1FBkcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775029269; c=relaxed/simple;
	bh=erEGmthLCCq5QaevIpQZZtKGYxx/zf3Sdg+6Wd/Uo3w=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=KenEqybo7elJAfcVmrza2NWxjjvBIqLPXrwewcRo5uonKuGuNmzWmSrg+DZktpnfl0sNQrTkkwQ+i1oiPo8KuV82Ztb8PXdr/Tgxr4eT0k6KUorEXuE2KK7g2wDJvJIbFd/G5KQUcG8vfzzgqHR5Pm96nklqAadIvApJ/kk0a30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CGHbsyHr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=141OuvNb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z4eYEgF2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=z3XHhETI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DDDC34D1E6;
	Wed,  1 Apr 2026 07:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775029266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b1pEdDeMovITLQfcEHCNx180y8KjPanNMnxJcqmlOt8=;
	b=CGHbsyHrfnSjT79FZ+5Va7hTUHGdbdtMvl/y8DyR7Y01ZVJfVTzCsCrxTJ9aQNxl2zFpHH
	x1NnapJ1m2gnVFKhRF4XxEdUJsHXx62VX9sOKolgrgAIwFqTcYY6rgZQNrA7rK8oFvo5y1
	O19uC0HtyPzV2KYEftUqiRoWcZw3m6U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775029266;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b1pEdDeMovITLQfcEHCNx180y8KjPanNMnxJcqmlOt8=;
	b=141OuvNbRIjjpUQ+nBpbbyldgmG3O0YE/HGK9es8fhAHS4y8Esy8coQdD1Pu5SGeazv77K
	efoZ85skoBid4jBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775029265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b1pEdDeMovITLQfcEHCNx180y8KjPanNMnxJcqmlOt8=;
	b=z4eYEgF2oBMO7xLy+jaGqL4OUSiqakxBduOipe6nXIoUT3OAId9dsBug+wg7l89gdltSMq
	mlVJ+X5nagDQw3GlbH3N5BPerqxfU9RotkWvD5chrRCYGD2ciuwzL3U7aP+pDdRd6+AraS
	OWwhyu+3A5ai5cAU4uvhsqGSweHIT9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775029265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b1pEdDeMovITLQfcEHCNx180y8KjPanNMnxJcqmlOt8=;
	b=z3XHhETIrT2fg6CmVJEE31EIFXqqCiMhE+B/gRp3gs5p68bhLiFv++YWA07d4AH4323YyO
	x+lbuU8ZTpSXrDAQ==
Date: Wed, 1 Apr 2026 09:41:05 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
cc: Joe Lawrence <joe.lawrence@redhat.com>, 
    Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Shuah Khan <shuah@kernel.org>, 
    live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] selftests: livepatch: test-syscall: Check for
 ARCH_HAS_SYSCALL_WRAPPER
In-Reply-To: <a23f00ad4a454cbb3379cdf512e8c61ce7499194.camel@suse.com>
Message-ID: <alpine.LSU.2.21.2604010937120.12688@pobox.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>  <20260313-lp-tests-old-fixes-v1-1-71ac6dfb3253@suse.com>  <abhjYtyveer4niGM@redhat.com> <a23f00ad4a454cbb3379cdf512e8c61ce7499194.camel@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-2146828000-2095840910-1775029265=:12688"
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	CTYPE_MIXED_BOGUS(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2273-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	MIME_TRACE(0.00)[0:+,1:+];
	DKIM_TRACE(0.00)[suse.cz:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pobox.suse.cz:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:dkim,suse.com:email]
X-Rspamd-Queue-Id: 20FC13763FA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---2146828000-2095840910-1775029265=:12688
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 31 Mar 2026, Marcos Paulo de Souza wrote:

> On Mon, 2026-03-16 at 16:12 -0400, Joe Lawrence wrote:
> > On Fri, Mar 13, 2026 at 05:58:32PM -0300, Marcos Paulo de Souza
> > wrote:
> > > Instead of checking if the architecture running the test was
> > > powerpc,
> > > check if CONF_ARCH_HAS_SYSCALL_WRAPPER is defined or not.
> > > 
> > > No functional changes.
> > > 
> > > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > > ---
> > >  tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > > | 7 +++----
> > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > 
> > > diff --git
> > > a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > > b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > > index dd802783ea849..c01a586866304 100644
> > > ---
> > > a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > > +++
> > > b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > > @@ -12,15 +12,14 @@
> > >  #include <linux/slab.h>
> > >  #include <linux/livepatch.h>
> > >  
> > > -#if defined(__x86_64__)
> > > +#if !defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER)
> > > +#define FN_PREFIX
> > > +#elif defined(__x86_64__)
> > >  #define FN_PREFIX __x64_
> > >  #elif defined(__s390x__)
> > >  #define FN_PREFIX __s390x_
> > >  #elif defined(__aarch64__)
> > >  #define FN_PREFIX __arm64_
> > > -#else
> > > -/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER */
> > > -#define FN_PREFIX
> > 
> > The patch does maintain the previous behavior, but I'm wondering if
> > the
> > original assertion about ARCH_HAS_SYSCALL_WRAPPER on Power was
> > correct:
> > 
> >   $ grep ARCH_HAS_SYSCALL_WRAPPER arch/powerpc/Kconfig
> >           select ARCH_HAS_SYSCALL_WRAPPER         if !SPU_BASE &&
> > !COMPAT
> >           depends on PPC64 && ARCH_HAS_SYSCALL_WRAPPER
> > 
> > Perhaps I just forgot what that additional piece of information that
> > explains the comment (highly probable these days), and if so, might
> > be
> > nice to add to this commit since I don't see it in 6a71770442b5
> > ("selftests: livepatch: Test livepatching a heavily called syscall").
> 
> Looking again at the code and at the symbols for SLE for ppc64le, I can
> say that, even with ARCH_HAS_SYSCALL_WRAPPER being set, the syscall
> names are not changed for ppc64le. Looking at
> arch/powerpc/kernel/systbl.c:
> 
> #ifdef CONFIG_ARCH_HAS_SYSCALL_WRAPPER
> #define __SYSCALL(nr, entry) [nr] = entry,
> #else
> /*
>  * Coerce syscall handlers with arbitrary parameters to common type
>  * requires cast to void* to avoid -Wcast-function-type.
>  */
> #define __SYSCALL(nr, entry) [nr] = (void *) entry,
> #endif

I think this is not the complete picture though. The definition of the 
syscall table did not change but the actual wrappers (or syscall functions 
naming before) did change a couple of times even on powerpc if I am 
reading the git history right. ARCH_HAS_SYSCALL_WRAPPER also changed how 
syscall parameters are consumed (from registers to stack frame (pt_regs)). 
It is not particularly relevant for getpid() which is SYSCALL_DEFINE0() 
but I wanted to point that out.

Miroslav
---2146828000-2095840910-1775029265=:12688--

