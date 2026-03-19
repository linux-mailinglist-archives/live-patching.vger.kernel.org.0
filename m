Return-Path: <live-patching+bounces-2236-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gMVPOJnyu2nkqQIAu9opvQ
	(envelope-from <live-patching+bounces-2236-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 13:56:57 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B0A2CB7F8
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 13:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7354930429A6
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 12:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B3A73D300D;
	Thu, 19 Mar 2026 12:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z22yfanD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YDN+O3Y4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z22yfanD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YDN+O3Y4"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84DF18FDBD
	for <live-patching@vger.kernel.org>; Thu, 19 Mar 2026 12:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773924873; cv=none; b=GOtPn6Acp8sz0t16ifdH1D24ugFhQIpvF6d7pc6x23sJBCnJfC9cQB3svH3WD47G5jC3Aha9IhBBOYvO+8dRlznMFj3twQgdsTS2uBgSy7hxOxugzDgBfPWx8e42mDlKiHnqCwaYpxIDTMkp3Jzwt62PR1DKlJ1UDQrD6wIVUbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773924873; c=relaxed/simple;
	bh=xjqceXl32Kt81eiXaEDHQtrRK+heCneUNYCg58PdPZY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ryv27BLR3wwgbYN5Lw9eLJUJu7WGnV7hf0R6A1vvN0RFAm0rwlmzkM1W1e2lmhwFdBXfauxB7Bc7a5h3KslX/89BUk7on0vsqWCNRPOsudOi2mSPAOG2lS2W5IZYhFvenMoTNtLn/S7X+MlGmyhN4iqdZI9oJpKQZgd92moDks8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z22yfanD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YDN+O3Y4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z22yfanD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YDN+O3Y4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3C7F54D216;
	Thu, 19 Mar 2026 12:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773924869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osU9e2YM8IeiN0Pg1d8RfN6FbqQsn4kj0ncarBgphdQ=;
	b=z22yfanDXh5f5wquXrxUOohcBtVFF/ItG2mxwrJrjJVGA1mAyJ7LK8vNPwZ32d9qAjziJU
	WZPTVUZV7cDhwztstZrzYgwtosrYHaasPlRQPLYWsWntUe76z+Cg55gnmizOOL/ReuVI7z
	w25x6bIoAaMRCAOe49haHHYNQbWCF+Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773924869;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osU9e2YM8IeiN0Pg1d8RfN6FbqQsn4kj0ncarBgphdQ=;
	b=YDN+O3Y4oBsYKfn8TA4upvJG4c3KxSBBlh9hLHxf25x4OpZPt7lvB/JyqNAyrQoBaU7kVV
	WoHxVt7l0oQ+f6DQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773924869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osU9e2YM8IeiN0Pg1d8RfN6FbqQsn4kj0ncarBgphdQ=;
	b=z22yfanDXh5f5wquXrxUOohcBtVFF/ItG2mxwrJrjJVGA1mAyJ7LK8vNPwZ32d9qAjziJU
	WZPTVUZV7cDhwztstZrzYgwtosrYHaasPlRQPLYWsWntUe76z+Cg55gnmizOOL/ReuVI7z
	w25x6bIoAaMRCAOe49haHHYNQbWCF+Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773924869;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osU9e2YM8IeiN0Pg1d8RfN6FbqQsn4kj0ncarBgphdQ=;
	b=YDN+O3Y4oBsYKfn8TA4upvJG4c3KxSBBlh9hLHxf25x4OpZPt7lvB/JyqNAyrQoBaU7kVV
	WoHxVt7l0oQ+f6DQ==
Date: Thu, 19 Mar 2026 13:54:29 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Joe Lawrence <joe.lawrence@redhat.com>
cc: Marcos Paulo de Souza <mpdesouza@suse.com>, 
    Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Shuah Khan <shuah@kernel.org>, 
    live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] selftests: livepatch: test-syscall: Check for
 ARCH_HAS_SYSCALL_WRAPPER
In-Reply-To: <abhjYtyveer4niGM@redhat.com>
Message-ID: <alpine.LSU.2.21.2603191349440.22987@pobox.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com> <20260313-lp-tests-old-fixes-v1-1-71ac6dfb3253@suse.com> <abhjYtyveer4niGM@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2236-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.998];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.cz:dkim,sashiko.dev:url,pobox.suse.cz:mid]
X-Rspamd-Queue-Id: 58B0A2CB7F8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 16 Mar 2026, Joe Lawrence wrote:

> On Fri, Mar 13, 2026 at 05:58:32PM -0300, Marcos Paulo de Souza wrote:
> > Instead of checking if the architecture running the test was powerpc,
> > check if CONF_ARCH_HAS_SYSCALL_WRAPPER is defined or not.

There is a typo... 
s/CONF_ARCH_HAS_SYSCALL_WRAPPER/CONFIG_ARCH_HAS_SYSCALL_WRAPPER/

> > 
> > No functional changes.
> > 
> > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > ---
> >  tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > index dd802783ea849..c01a586866304 100644
> > --- a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > +++ b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > @@ -12,15 +12,14 @@
> >  #include <linux/slab.h>
> >  #include <linux/livepatch.h>
> >  
> > -#if defined(__x86_64__)
> > +#if !defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER)
> > +#define FN_PREFIX
> > +#elif defined(__x86_64__)
> >  #define FN_PREFIX __x64_
> >  #elif defined(__s390x__)
> >  #define FN_PREFIX __s390x_
> >  #elif defined(__aarch64__)
> >  #define FN_PREFIX __arm64_
> > -#else
> > -/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER */
> > -#define FN_PREFIX
> 
> The patch does maintain the previous behavior, but I'm wondering if the
> original assertion about ARCH_HAS_SYSCALL_WRAPPER on Power was correct:
> 
>   $ grep ARCH_HAS_SYSCALL_WRAPPER arch/powerpc/Kconfig
>           select ARCH_HAS_SYSCALL_WRAPPER         if !SPU_BASE && !COMPAT
>           depends on PPC64 && ARCH_HAS_SYSCALL_WRAPPER
> 
> Perhaps I just forgot what that additional piece of information that
> explains the comment (highly probable these days), and if so, might be
> nice to add to this commit since I don't see it in 6a71770442b5
> ("selftests: livepatch: Test livepatching a heavily called syscall").

I would take a bit further. We would rely on 
CONFIG_ARCH_HAS_SYSCALL_WRAPPER being set/unset per listed architectures 
"correctly" for us. If it changes somehow (though I cannot imagine reasons 
for that but let's say we add new architecture. LoongArch also supports 
live patching.), the above might evaluate to something broken.

So I would perhaps prefer to stay with the logic that defines FN_PREFIX 
per architecture and has also #else branch for the rest. And more comments 
never hurt.

Btw, see also 
https://sashiko.dev/#/patchset/20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253%40suse.com 
for the Sashiko AI review. It also commented on this patch. Marcos, I 
guess that you will look there and I will just omit what Sashiko found in 
my review if I spot the same thing.

Miroslav

