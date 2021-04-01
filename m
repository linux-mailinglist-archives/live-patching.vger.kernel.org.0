Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDAE351E43
	for <lists+live-patching@lfdr.de>; Thu,  1 Apr 2021 20:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbhDAShn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Apr 2021 14:37:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237391AbhDAS2Y (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Apr 2021 14:28:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B562D601FC;
        Thu,  1 Apr 2021 18:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617301704;
        bh=2iyVMk2LQHYUn0A73vvTr7YeNun8Ulm667R/SCyeFI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XLyfdbkchdgeFB2GljILpxrknvwknW54lZAUwkgQM9wyhVtSrnJBWNopYPag0fmIW
         RHilpluhnkYT9V4Jlin4lh04S3ZEg3cuuSrDZUlCGOA66X/a3AWuwigjhAuBLzJR43
         ogrZfbRPgaah6na89eUu8d2Yi64xD8Zia9Jvb4QpFJruM/uMzhSXpvSZLphnjbbFYK
         2yCAm3VhCwDHdoimkJTp+1JYpO0nKfee1oFJpU5gNmqGrlVZiQXHW0fjLhOxz0sbBC
         LEnJX+6wFh84H7p19HKJh+oCO5GCqO/at7v2r7pdjOCTmcSqs+flLL0nkxO/663OzQ
         xkHR6X41D6FmQ==
Date:   Thu, 1 Apr 2021 19:28:11 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/4] arm64: Detect FTRACE cases that make the
 stack trace unreliable
Message-ID: <20210401182810.GO4758@sirena.org.uk>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
 <20210330190955.13707-4-madvenka@linux.microsoft.com>
 <20210401142759.GJ4758@sirena.org.uk>
 <0bece48b-5fee-2bd1-752e-66d2b89cc5ad@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JfVplkuTfB13Rsg5"
Content-Disposition: inline
In-Reply-To: <0bece48b-5fee-2bd1-752e-66d2b89cc5ad@linux.microsoft.com>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--JfVplkuTfB13Rsg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 01, 2021 at 12:43:25PM -0500, Madhavan T. Venkataraman wrote:

> >> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
> >> +	{ (unsigned long) &ftrace_graph_call, 0 },
> >> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> >> +	{ (unsigned long) ftrace_graph_caller, 0 },

> > It's weird that we take the address of ftrace_graph_call but not the
> > other functions - we should be consistent or explain why.  It'd probably
> > also look nicer to not nest the ifdefs, the dependencies in Kconfig will
> > ensure we only get things when we should.

> I have explained it in the comment in the FTRACE trampoline right above
> ftrace_graph_call().

Ah, right - it's a result of it being an inner label.  I'd suggest
putting a brief note right at that line of code explaining this (eg,
"Inner label, not a function"), it wasn't confusing due to the use of
that symbol but rather due to it being different from everything else
in the list and that's kind of lost in the main comment.

> So, it is only defined if CONFIG_FUNCTION_GRAPH_TRACER is defined. I can address
> this as well as your comment by defining another label whose name is more meaningful
> to our use:

> +SYM_INNER_LABEL(ftrace_trampoline, SYM_L_GLOBAL) // checked by the unwinder
> #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL) // ftrace_graph_caller();
>         nop                             // If enabled, this will be replaced
>                                         // "b ftrace_graph_caller"
> #endif

I'm not sure we need to bother with that, you'd still need the & I think.

--JfVplkuTfB13Rsg5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBmELoACgkQJNaLcl1U
h9C93Qf/eFtaA9mswR2hJPLjgvWxUJT2Ojc2wjAhGJENXEqgUuNy8cZbDKA0+xHn
rCY/8FPBA5mUmRiS6RdkIXfsVyeRl4ASphssRdboKJLaC2vwbv+U3H0zuBk9HYbN
4Jx9C4j8uxsT3xD9vYnBoel5ffcI+zC3dVr7FPhpYODEArDEx5YAP835vCBXiUMq
8OsieIJtW3ymQBuSSyken77C8zUwTKgwk3NyRKoXx5Wd3kRpZEqKwf+PgSkA4TXo
6fbpOBwdwy/2wBHL+TK2Ij59zNGh5GJf4wUn8FIoApI7QL1J7KW+zfsVRXd42GjN
IV/i3AuBtZx5dC4hLW0as6MGqmpyiw==
=7FAu
-----END PGP SIGNATURE-----

--JfVplkuTfB13Rsg5--
