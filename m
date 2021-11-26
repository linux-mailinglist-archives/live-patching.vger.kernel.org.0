Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB3145EF2F
	for <lists+live-patching@lfdr.de>; Fri, 26 Nov 2021 14:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351305AbhKZNfJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 26 Nov 2021 08:35:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50658 "EHLO mail.kernel.org"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S229555AbhKZNdJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 26 Nov 2021 08:33:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F172C61107;
        Fri, 26 Nov 2021 13:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637933396;
        bh=7LVogIZwhsg35iSlbAESooVl/rEgJvhublhLAw8x5yY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jl2xuLT/SIUcSOoPkjiuDgMJ0LRj5FMVWoazyGZClhuNuT2uefAnzouEW0RxM06JM
         yh5NkCVcclw/0Nu9oGkJWheDLMxU6ks9oBm7+WiJ9/Ce+gKhXkjbTImAZuEkF4ncz/
         EGEi4zYaFE4XuXzviOIvvoF9slE0RnWd1ODnesKpagcQD/jwjFKIDOcYFQj+HCeEDk
         lJ8TSUWSIXWjKmJEBtaNHZZVkXhC70mKS20o53YexkJIhdP1Atq/2ob+k6FuvBo0gr
         pHKqL+0TWzjnd0dbprmwgGAjhcI62Op3qi5rFOXdwjf17gyzhZz3SBr9NjRW0iFs0Y
         yiDeOQni8qfQA==
Date:   Fri, 26 Nov 2021 13:29:50 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 4/5] arm64: Introduce stack trace reliability checks
 in the unwinder
Message-ID: <YaDhThxyGhCTkJx9@sirena.org.uk>
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
 <20211123193723.12112-5-madvenka@linux.microsoft.com>
 <YZ+kLPT+h6ZGw20p@sirena.org.uk>
 <704d73f6-30e2-08e0-3a5c-d3639d8b2da1@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GALume5odCjIom1y"
Content-Disposition: inline
In-Reply-To: <704d73f6-30e2-08e0-3a5c-d3639d8b2da1@linux.microsoft.com>
X-Cookie: You fill a much-needed gap.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--GALume5odCjIom1y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 25, 2021 at 10:59:27AM -0600, Madhavan T. Venkataraman wrote:
> On 11/25/21 8:56 AM, Mark Brown wrote:
> > On Tue, Nov 23, 2021 at 01:37:22PM -0600, madvenka@linux.microsoft.com wrote:

> > Probably also worth noting that this doesn't select
> > HAVE_RELIABLE_STACKTRACE which is what any actual users are going to use
> > to identify if the architecture has the feature.  I would have been
> > tempted to add arch_stack_walk() as a separate patch but equally having
> > the user code there (even if it itself can't yet be used...) helps with
> > reviewing the actual unwinder so I don't mind.

> I did not select HAVE_RELIABLE_STACKTRACE just in case we think that some
> more reliability checks need to be added. But if reviewers agree
> that this patch series contains all the reliability checks we need, I
> will add a patch to select HAVE_RELIABLE_STACKTRACE to the series.

I agree that more checks probably need to be added, might be worth
throwing that patch into the end of the series though to provide a place
to discuss what exactly we need.  My main thought here was that it's
worth explicitly highlighting in this change that the Kconfig bit isn't
glued up here so reviewers notice that's what's happening.

> >> +static void unwind_check_reliability(struct task_struct *task,
> >> +				     struct stackframe *frame)
> >> +{
> >> +	if (frame->fp == (unsigned long)task_pt_regs(task)->stackframe) {
> >> +		/* Final frame; no more unwind, no need to check reliability */
> >> +		return;
> >> +	}

> > If the unwinder carries on for some reason (the code for that is
> > elsewhere and may be updated separately...) then this will start
> > checking again.  I'm not sure if this is a *problem* as such but the
> > thing about this being the final frame coupled with not actually
> > explicitly stopping the unwind here makes me think this should at least
> > be clearer, the comment begs the question about what happens if
> > something decides it is not in fact the final frame.

> I can address this by adding an explicit comment to that effect.
> For example, define a separate function to check for the final frame:

> /*
>  * Check if this is the final frame. Unwind must stop at the final
>  * frame.
>  */
> static inline bool unwind_is_final_frame(struct task_struct *task,
>                                          struct stackframe *frame)
> {
> 	return frame->fp == (unsigned long)task_pt_regs(task)->stackframe;
> }

> Then, use this function in unwind_check_reliability() and unwind_continue().

> Is this acceptable?

Yes, I think that should address the issue - I'd have to see it in
context to be sure but it does make it clear that the same check is
being done which was the main thing.

--GALume5odCjIom1y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGg4U4ACgkQJNaLcl1U
h9A3CQf+Pv6+laTsXfHU8UeBWpjGw+5W0+udkQAjC1q2rxTBX4pbUiXDKUEEKQQn
GJgs+b4M3a+1jdtmIXwG9OaBME/7ForpHlK9GutYqJB7cmqXF9OybvL8dAfMT8Cr
TRDgc8tAAmFn7MeQU6dnnexKn24c1RacsqvcxCc4ltrrZx4LU6SIHohtcpiH0FuN
bDrwDE3qCP37f72fKUzsRQIM6ZV3PjlDlnt3dumUGyBgM9gE/5vrEu+QH11av+Xn
iYJJr0HqIz/IyH8meAq6p+p1+LtLMFmJbw1K5A6te7kDYef2Rnpi6JmMAwX9rnKB
JHXMKuDM2EGjy2oZcz4iQaWFO+rBYQ==
=N8Bf
-----END PGP SIGNATURE-----

--GALume5odCjIom1y--
