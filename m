Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB172F540D
	for <lists+live-patching@lfdr.de>; Wed, 13 Jan 2021 21:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbhAMUYc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Jan 2021 15:24:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbhAMUYb (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Jan 2021 15:24:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 895C92251F;
        Wed, 13 Jan 2021 20:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610569431;
        bh=o9LaKhm5VN+gTQHPE6NXpf952MBuYH3ScPuKWsqVyEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jP6FU9kt5cPvKnpO8sQEdkNqzuPVxDmgAKC1XaZMMYHdY0RkhJGHg7H2IT3gh4ESd
         SSGlSH5EAfoGH62fTTFnbvT/ZMk2+mWwwnn9KypFr1J+HWUV2taYIv1k814HGr0aQu
         5uY9BBMsR8Fm9lHIPyFnb4mMKJeC1F/J4cY8kLw3IlbSDC8v34Y7xHXhuUoOc4hIVy
         8pEcAMXKLN2kop6FdbB/xsngGKc20CPok94PQ2nTBCcWfS+ME1XIuo1Kmfz6yYTAT7
         ABiwQeTZnibFwdFFGWYZrmNVF03WhFlmDuausEQ7DVGpi7IGlRuYZO4gn57Qvsz201
         mwUdXiHzJ5QYA==
Date:   Wed, 13 Jan 2021 20:23:15 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210113202315.GI4641@sirena.org.uk>
References: <20210113165743.3385-1-broonie@kernel.org>
 <20210113192735.rg2fxwlfrzueinci@treble>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wZdghQXYJzyo6AGC"
Content-Disposition: inline
In-Reply-To: <20210113192735.rg2fxwlfrzueinci@treble>
X-Cookie: Ignore previous fortune.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--wZdghQXYJzyo6AGC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 13, 2021 at 01:33:13PM -0600, Josh Poimboeuf wrote:

> I think it's worth mentioning a little more about objtool.  There are a
> few passing mentions of objtool's generation of metadata (i.e. ORC), but
> objtool has another relevant purpose: stack validation.  That's
> particularly important when it comes to frame pointers.

> For some architectures like x86_64 and arm64 (but not powerpc/s390),
> it's far too easy for a human to write asm and/or inline asm which
> violates frame pointer protocol, silently causing the violater's callee
> to get skipped in the unwind.  Such architectures need objtool
> implemented for CONFIG_STACK_VALIDATION.

This basically boils down to just adding a statement saying "you may
need to depend on objtool" I think?

> > +There are several ways an architecture may identify kernel code which is deemed
> > +unreliable to unwind from, e.g.

> > +* Using metadata created by objtool, with such code annotated with
> > +  SYM_CODE_{START,END} or STACKFRAME_NON_STANDARD().

> I'm not sure why SYM_CODE_{START,END} is mentioned here, but it doesn't
> necessarily mean the code is unreliable, and objtool doesn't treat it as
> such.  Its mention can probably be removed unless there was some other
> point I'm missing.

I was reading that as being a thing that the architecture could possibly
do, especially as a first step - it does seem like a reasonable thing to
consider using anyway.  I guess you could also use it the other way
around and do additional checks for things that are supposed to be
regular functions that you relax for SYM_CODE() sections.

--wZdghQXYJzyo6AGC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl//VrMACgkQJNaLcl1U
h9AmYggAgubIJVPHRw3lCOS+tyJn7EtvD/kscPl99nqk2qJB3cMyewl4IzbKT2aW
rtpb5JWWFAXR4xBvkv6M2h7DUdrJwTJgd5ldh8DNojqoOAW3JnyTq9jI9VpCsxgu
BD0KHZ33FyjdpxEPDR0iJWgKJ8guSUAt1+Q9Rj/GH0w/fhtJCmaFZZGql3a1q+2w
U1qgxvNvVw2geTJuWx70DnaVQoiXrfasP6jd40FNWaAT0joElHYsfS/JhYyt34Rq
K6AQsswSgMvOpE+7bp1C008TmAW6H4MJ2e5i8rr0jkF2KBFYbV0SDrRy10+DWxSM
qyMtonaJw3qnuffJzlEsSStHaDjzTw==
=kjap
-----END PGP SIGNATURE-----

--wZdghQXYJzyo6AGC--
