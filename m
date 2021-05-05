Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E34374217
	for <lists+live-patching@lfdr.de>; Wed,  5 May 2021 18:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbhEEQoA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 May 2021 12:44:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235394AbhEEQlr (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 May 2021 12:41:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 512C7616E8;
        Wed,  5 May 2021 16:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232482;
        bh=pN1MfxHin+caU+Dvsh+jFpWBcP0jideP3oH2EhjkwA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y1+jTj8Cky74YmZw8Mu0LvGLn8ieXNxZKR7s/9E9nhDzrvitPq5kn9c4GHbTMj0kg
         P4OKEZ9IcxaAS/OuIZ1zq+zwbyzvgaPmcf8+viprCDqERFju0YO/CwvKM7O7nx81No
         arI4ZEuztkIgsAiJ+/eLwQV8d0rNfkzJqwSBkZ7681IUcs0EkZzcXa+pvp2iTryZLn
         Ux0Gie+Ii4gKSLV7JrSuirBIuqQYJHuuS6cJ/Gsrggx4NTNkJW3/50BU3JylQs5fXc
         JdzPo8Ak/YNeKTdiMFuc8k/SRypyCUG46ekRf9m7CtZec9tugu5WisrGXCgSbn5l33
         1Nook+U/Gs/tA==
Date:   Wed, 5 May 2021 17:34:06 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/4] arm64: Check the return PC against unreliable
 code sections
Message-ID: <20210505163406.GB4541@sirena.org.uk>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-3-madvenka@linux.microsoft.com>
 <20210504160508.GC7094@sirena.org.uk>
 <1bd2b177-509a-21d9-e349-9b2388db45eb@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <1bd2b177-509a-21d9-e349-9b2388db45eb@linux.microsoft.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 04, 2021 at 02:03:14PM -0500, Madhavan T. Venkataraman wrote:
> On 5/4/21 11:05 AM, Mark Brown wrote:

> >> @@ -118,9 +160,21 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
> >>  			return -EINVAL;
> >>  		frame->pc = ret_stack->ret;
> >>  		frame->pc = ptrauth_strip_insn_pac(frame->pc);
> >> +		return 0;
> >>  	}

> > Do we not need to look up the range of the restored pc and validate
> > what's being pointed to here?  It's not immediately obvious why we do
> > the lookup before handling the function graph tracer, especially given
> > that we never look at the result and there's now a return added skipping
> > further reliability checks.  At the very least I think this needs some
> > additional comments so the code is more obvious.

> I want sym_code_ranges[] to contain both unwindable and non-unwindable ranges.
> Unwindable ranges will be special ranges such as the return_to_handler() and
> kretprobe_trampoline() functions for which the unwinder has (or will have)
> special code to unwind. So, the lookup_range() has to happen before the
> function graph code. Please look at the last patch in the series for
> the fix for the above function graph code.

That sounds reasonable but like I say should probably be called out in
the code so it's clear to people working with it.

> On the question of "should the original return address be checked against
> sym_code_ranges[]?" - I assumed that if there is a function graph trace on a
> function, it had to be an ftraceable function. It would not be a part
> of sym_code_ranges[]. Is that a wrong assumption on my part?

I can't think of any cases where it wouldn't be right now, but it seems
easier to just do a redundant check than to have the assumption in the
code and have to think about if it's missing.

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCSyP0ACgkQJNaLcl1U
h9AHXwf/dlSkWVc9S8GPIKnOPjZ4hMQvnKRX40iT/k9PrAM7y+5z3ear/Ur46dvD
DeVmFutp0xtG9sZZuOVvhvc1Ud8HJejQDzFkC5cuSA5qsfjsB8oSnIzcXXMnFe7W
HIC1GuRUZbS8tghRCYKlPAmJ07iIcM8TDiLY/sm54sHa2JPbIA9CeTK5U9VdgWKY
ezPNVRXs/mfA2BEEOMr9PCjBrUXTnywTjUDW2UBHn4556xYHfDYGlAuwNkB9S93j
yb5q32pFklKStG5NeMdFX31fNxRUpfmINEa+zaElVLChifuf2+BLilpzqf8j8uJQ
H+6W3qYdxBAa4XnfSoPDXIbwMXEWzw==
=tf0f
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
