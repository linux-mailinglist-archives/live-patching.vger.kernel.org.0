Return-Path: <live-patching+bounces-2388-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qIi1ALF34mnh6AAAu9opvQ
	(envelope-from <live-patching+bounces-2388-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 20:10:57 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E8AC641DD74
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 20:10:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 51131301076A
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 18:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7BD3B7B75;
	Fri, 17 Apr 2026 18:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gSxIbV71"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DF6388390
	for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 18:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776449433; cv=none; b=RMZwR6URk3GmjFTEs6WQiNTDgSLE95OVW8ewBCC0aGAp+eYAe8mutx0YBgDIhGUFXFzlPPN3kGh/fXF/10jbdq3CvlfEcvJaZWOb5PWcNvm7RwyPAZstoA5peu2qA4Q5Tyem9XYCTLcnrgkAzqiRx23+IVeZblWSEVwi+U23VHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776449433; c=relaxed/simple;
	bh=X6Pb1/2qLw+LnrK4sxSBFTN5qn/ioZ80l+kq/fKtAc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XYifkf2S0GDNQ+KSX135eAc5FijhwJGjdstysYHWRJXWE7RyKHWH2DjR1M2coaSb8kvyTcITc9lzCxpl2Nx5BC2rKUUzydqxUK+BPsEz5rXHF3oxyk0jN1DUSfyPgK1AlvHQyKW9TsoHU0QqGtpfBFgFt3hO5NSC8adIiSLFijg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gSxIbV71; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776449427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6kyborFkruSgvXIq68WA0o3wu4Kuyav6HoYwh7WM0s0=;
	b=gSxIbV71+4voqGv3bwNRO74QDuM0ZEqbxdazpi8VTXUsenOPZZTYrwWjhMVFM9qRt6OKV4
	AgCDjS8/UxCdgfUKsC5Bzn5+WjR4qh4W0HGtJGlOeTwgbZJ5KLPeWbK5Mn2QYQI7H0Zg8c
	jh1G6S4ZlpUB8r+9YDaZoouxq8BtiKY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-ZbyjFoCBMHGSMiexMPoOMg-1; Fri,
 17 Apr 2026 14:10:26 -0400
X-MC-Unique: ZbyjFoCBMHGSMiexMPoOMg-1
X-Mimecast-MFC-AGG-ID: ZbyjFoCBMHGSMiexMPoOMg_1776449425
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA52919560A6;
	Fri, 17 Apr 2026 18:10:24 +0000 (UTC)
Received: from redhat.com (unknown [10.22.88.10])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 403371800446;
	Fri, 17 Apr 2026 18:10:23 +0000 (UTC)
Date: Fri, 17 Apr 2026 14:10:20 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Shuah Khan <shuah@kernel.org>,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] selftests: livepatch: Check for
 ARCH_HAS_SYSCALL_WRAPPER config
Message-ID: <aeJ3jPszYCpte8SY@redhat.com>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
 <20260413-lp-tests-old-fixes-v2-1-367c7cb5006f@suse.com>
 <alpine.LSU.2.21.2604151154330.1967@pobox.suse.cz>
 <aeJNnFqLEdMgnHKh@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeJNnFqLEdMgnHKh@pathway.suse.cz>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2388-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E8AC641DD74
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 17, 2026 at 05:11:24PM +0200, Petr Mladek wrote:
> On Wed 2026-04-15 11:58:50, Miroslav Benes wrote:
> > On Mon, 13 Apr 2026, Marcos Paulo de Souza wrote:
> > 
> > > Older kernels that lack CONFIG_ARCH_HAS_SYSCALL_WRAPPER config don't
> > > have any prefixes for their syscalls. The same applies to current
> > > powerpc and loongarch, covering all currently supported architectures
> > > that support livepatch.
> > > 
> > > The other supported architectures have specific prefixes, so error out
> > > when a new architecture adds livepatch support with wrappes but didn't
> > > update the test to include it.
> > > 
> > > --- a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > > +++ b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > > @@ -12,15 +12,26 @@
> > >  #include <linux/slab.h>
> > >  #include <linux/livepatch.h>
> > >  
> > > -#if defined(__x86_64__)
> > > +/*
> > > + * Before CONFIG_ARCH_HAS_SYSCALL_WRAPPER was introduced there were no
> > > + * prefixes for system calls.
> > > + * Both ppc and loongarch does not set prefixes for their system calls either.
> > > + */
> > > +#if !defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER) ||  defined(__powerpc__) || \
> > > +	defined(__loongarch__)
> > > +#define FN_PREFIX
> > > +#elif defined(__x86_64__)
> > >  #define FN_PREFIX __x64_
> > >  #elif defined(__s390x__)
> > >  #define FN_PREFIX __s390x_
> > >  #elif defined(__aarch64__)
> > >  #define FN_PREFIX __arm64_
> > > -#else
> > > -/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER */
> > > +#elif defined(__powerpc__)
> > > +#define FN_PREFIX
> > > +#elif defined(__loongarch__)
> > >  #define FN_PREFIX
> > > +#else
> > > +#error "Missing syscall wrapper for the given architecture."
> > >  #endif
> > 
> > I know that Sashiko commented on that already but even with that I wonder 
> > if it was cleaner to structure it differently...
> > 
> > #if defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER)
> >   #if define(__x86_64__)
> >   ...
> >   #elif define(__powerpc__)
> >     #define FN_PREFIX
> >   #else
> >     #error
> >   #endif
> > #elif
> >   #define FN_PREFIX
> > #endif
> 
> Yeah, this looks better.
> 

Agreed, if there is v3, this would definitely be clearer.

--
Joe


