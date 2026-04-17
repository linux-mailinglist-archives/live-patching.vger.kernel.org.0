Return-Path: <live-patching+bounces-2382-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OLnWN3hO4mnx4QAAu9opvQ
	(envelope-from <live-patching+bounces-2382-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 17:15:04 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CDEF41C776
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 17:15:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D27B6309389C
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 15:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BA033C1977;
	Fri, 17 Apr 2026 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YvPrmU8Z"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6F63A63FE
	for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776438690; cv=none; b=fliCMnSQ/Rz+l6lLvlfZ3b1EXQJXVjKDttYKO0IzFzUOrj3Hur5j1zzbrvucgnIOeKy4FiD7PFcKx8UH6AOSEvnnPZbOSH2sPNnXm0HIj9nad3HX5yoBIPsyYiwp0niZ7N24/LAh4M8F8cR55lU4DFJd1eu+qWorwAdu/rty7kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776438690; c=relaxed/simple;
	bh=xxec1yHgJbPl8i5bLrRlB9bA5QiiLXD6oseWcH7kBdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D75SDNj6Sy8Yi6DCdBO1rGNEqPXc+1k7R8yWmbwZ79BQm7epC/OkRiyLCxF0Z7ABgE4QMAtNYdwd+8jCYc7gtRp2cCqQuO1+W/htBNkOQ0sUa+FDX7J2LDRrNIoJiH7az8v5gaBYZjVWUT86eQuM5JHjOxBELKQwxyujpZov6Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YvPrmU8Z; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488e1a8ac40so11111005e9.2
        for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 08:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776438687; x=1777043487; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gKQfwAZAy6UM0COAZ8ddWWHLIY/D6XGoxFUGJBdu8NE=;
        b=YvPrmU8Z8bNbPYNfgy+iMOwre+gGjTLzAEGFkdkKgeMpd0q6BDDsDgmTaUVGQF9znO
         o1iGGrOdthMZ06Tgev8NMO+ccbWRa0kkZt2D3l5hjMpmO19TkUOeBpHcKuKXCbfenN+v
         4yD1ZQGFSQbngDj72BqF6cwTO6yUKKOUuF0jObnF2yTNAElP5Lq92DRulyLfSsYlPL7C
         ySgxfy2BhGz7CahL+ZHWMBrHXwqXTYiDqpfSNjg+wYeC3tDamAD34lU554clKYfiLBy2
         d3/EZ/vpqxqJGRERE53Tkjn5tI1YAvtYC7Pu83lrZvHZyR55VP0tfpisFSGKDha7IcLz
         wCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776438687; x=1777043487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gKQfwAZAy6UM0COAZ8ddWWHLIY/D6XGoxFUGJBdu8NE=;
        b=An0uw/7sl2Sg52YwrGJti50YqD7WrJTl8/5s3FoTGxHPDEvUWlZSjFRDq+WtD6UqWX
         2ww8pHeB3qiFio54lx+1IHOpvSHgLZGg9YUmuX0r86gTWTWfqeZ1HoPa7y6Tegg+7lnk
         epopgJTLWhATA4GcxvDWmionVHdYBhK1Uz4XHfjxtFBBiKqv1lE/KPVGAQb3zK2XoStp
         6Q2s8X2GM93nox5+XwFABMFWKp7nJiCd/+XXqH+2JzZvSzCFZeNbSfv5NhQWdoVmcdUq
         /dGfWyP5xO2kZbmIzWaB130CbMHvaVzsBDkRyNDUa6gcbbXjfTbDLnDgXMI3WTfJrGBl
         9wFQ==
X-Forwarded-Encrypted: i=1; AFNElJ885G3DhbHZ+uUWaVwW5QLGQG5qrBC3+A2OegU0GZcHeiDYsVf3vcZq6PkSSZ2JwhECOIsNYo0XS/ziGI23@vger.kernel.org
X-Gm-Message-State: AOJu0YzSHeBFnTW0qt71sgQEmisCl8JvZuGRRTLLmFGhfnoUAUTH9FhM
	//Rz+w8S37EyLReNqBfgnYNcJVTs07uwyxiYJANRUXOo+DqtuozJ0js+JC61hSvYmeQ=
X-Gm-Gg: AeBDiestqKQXaDKbV5400WiiuyhDZy0XxwT0/fdSZmiaNEOKWTX/7lemiRVLaWR6sQb
	TK6yEapwaB4bQ06N3qGtZllOrz2h1wRAXsRa90HYETqW1Sd1/69l/yrCDcPJrcT6wYUkoc62DbF
	Um6wDn6sEkOGcN8LSevAlCkGjAz0asYnEra/j4Y2wZ25yxT9HELV2NT2Qzy3j1Ii8Tx2+dypqBT
	9F9Zveykv6ATws59giHjPJVWo9qXjMYUGjK+DgVq4wak7OFi/Jt4ADQ/fSEi2bAN7zbYRYsMce6
	jmUeh9SfMyBD9PaphNDpM7yWEIJcd8eGV0TlF0r1R0ejR0eG3IK4yLXfD+yfTdWuQLQc6xu8c17
	4ayQnx/5QOKr3CB6/xsjS9xsqoENhIlfP8bMcZ8xkbRJk+elxhFL3lf8KALR01NRqwmlkSZ4Td0
	Pf2vggDVnxE+y6inr1zz3rq/c9j7aFU3hdgou8JAUgahjaf3g=
X-Received: by 2002:a05:600c:c090:b0:488:9e54:94c0 with SMTP id 5b1f17b1804b1-488fb74e130mr34312005e9.8.1776438687044;
        Fri, 17 Apr 2026 08:11:27 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb794d2esm31681085e9.6.2026.04.17.08.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 08:11:26 -0700 (PDT)
Date: Fri, 17 Apr 2026 17:11:24 +0200
From: Petr Mladek <pmladek@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] selftests: livepatch: Check for
 ARCH_HAS_SYSCALL_WRAPPER config
Message-ID: <aeJNnFqLEdMgnHKh@pathway.suse.cz>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
 <20260413-lp-tests-old-fixes-v2-1-367c7cb5006f@suse.com>
 <alpine.LSU.2.21.2604151154330.1967@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2604151154330.1967@pobox.suse.cz>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2382-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6CDEF41C776
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed 2026-04-15 11:58:50, Miroslav Benes wrote:
> On Mon, 13 Apr 2026, Marcos Paulo de Souza wrote:
> 
> > Older kernels that lack CONFIG_ARCH_HAS_SYSCALL_WRAPPER config don't
> > have any prefixes for their syscalls. The same applies to current
> > powerpc and loongarch, covering all currently supported architectures
> > that support livepatch.
> > 
> > The other supported architectures have specific prefixes, so error out
> > when a new architecture adds livepatch support with wrappes but didn't
> > update the test to include it.
> > 
> > --- a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > +++ b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > @@ -12,15 +12,26 @@
> >  #include <linux/slab.h>
> >  #include <linux/livepatch.h>
> >  
> > -#if defined(__x86_64__)
> > +/*
> > + * Before CONFIG_ARCH_HAS_SYSCALL_WRAPPER was introduced there were no
> > + * prefixes for system calls.
> > + * Both ppc and loongarch does not set prefixes for their system calls either.
> > + */
> > +#if !defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER) ||  defined(__powerpc__) || \
> > +	defined(__loongarch__)
> > +#define FN_PREFIX
> > +#elif defined(__x86_64__)
> >  #define FN_PREFIX __x64_
> >  #elif defined(__s390x__)
> >  #define FN_PREFIX __s390x_
> >  #elif defined(__aarch64__)
> >  #define FN_PREFIX __arm64_
> > -#else
> > -/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER */
> > +#elif defined(__powerpc__)
> > +#define FN_PREFIX
> > +#elif defined(__loongarch__)
> >  #define FN_PREFIX
> > +#else
> > +#error "Missing syscall wrapper for the given architecture."
> >  #endif
> 
> I know that Sashiko commented on that already but even with that I wonder 
> if it was cleaner to structure it differently...
> 
> #if defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER)
>   #if define(__x86_64__)
>   ...
>   #elif define(__powerpc__)
>     #define FN_PREFIX
>   #else
>     #error
>   #endif
> #elif
>   #define FN_PREFIX
> #endif

Yeah, this looks better.

Best Regards,
Petr

