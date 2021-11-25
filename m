Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F5945DCC4
	for <lists+live-patching@lfdr.de>; Thu, 25 Nov 2021 15:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348797AbhKYPCB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Nov 2021 10:02:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351482AbhKYPAB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Nov 2021 10:00:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B78F960527;
        Thu, 25 Nov 2021 14:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637852210;
        bh=BxuGddqF62NHTgmF6zXHvMp3rqujzOr/SNnZL+sHDa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Puw16gLEuEJ8skCFKwO9fhNLCkU02IEThkI+Qa7q/wCqS0jaeD1HM3f8O/tEDhhfr
         /x3UhnrKptA2WPGU6LAMwS5t1VQxeLqofdzEySjFQXYvCILbuvWazFjq0VUWpioZOl
         rJb2VnuMjIhFSYtnNZioOqRvwmQGjDGJFH4qi9lBoopkXkKrsVBzrLRBVvGlNqPC7I
         5LfMShmr2RUZZhAsZMMWHLB935sKG152VdreWuWXmTLFE0NUEsoB3SDABPQM3VNcWy
         3+gfM7IbAVB/a1lGxxMjy2UtjV77goxrxpbp/fUBOBIxJAnFCjf8ZLr8POnTqOaOua
         6U/1H22NH4Jjw==
Date:   Thu, 25 Nov 2021 14:56:44 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 4/5] arm64: Introduce stack trace reliability checks
 in the unwinder
Message-ID: <YZ+kLPT+h6ZGw20p@sirena.org.uk>
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
 <20211123193723.12112-5-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qLWXUA94TwkS4msl"
Content-Disposition: inline
In-Reply-To: <20211123193723.12112-5-madvenka@linux.microsoft.com>
X-Cookie: This bag is recyclable.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--qLWXUA94TwkS4msl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 23, 2021 at 01:37:22PM -0600, madvenka@linux.microsoft.com wrote:

> Introduce arch_stack_walk_reliable() for ARM64. This works like
> arch_stack_walk() except that it returns -EINVAL if the stack trace is not
> reliable.

> Until all the reliability checks are in place, arch_stack_walk_reliable()
> may not be used by livepatch. But it may be used by debug and test code.

Probably also worth noting that this doesn't select
HAVE_RELIABLE_STACKTRACE which is what any actual users are going to use
to identify if the architecture has the feature.  I would have been
tempted to add arch_stack_walk() as a separate patch but equally having
the user code there (even if it itself can't yet be used...) helps with
reviewing the actual unwinder so I don't mind.

> +static void unwind_check_reliability(struct task_struct *task,
> +				     struct stackframe *frame)
> +{
> +	if (frame->fp == (unsigned long)task_pt_regs(task)->stackframe) {
> +		/* Final frame; no more unwind, no need to check reliability */
> +		return;
> +	}

If the unwinder carries on for some reason (the code for that is
elsewhere and may be updated separately...) then this will start
checking again.  I'm not sure if this is a *problem* as such but the
thing about this being the final frame coupled with not actually
explicitly stopping the unwind here makes me think this should at least
be clearer, the comment begs the question about what happens if
something decides it is not in fact the final frame.

--qLWXUA94TwkS4msl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGfpCsACgkQJNaLcl1U
h9AZ8gf/fIHx2Iw3Apm4D53bXBg2uCgPtniVqn3ga8gWCPuF427MGGbmbID856Fz
EsxOaARY4+0rjx82ksssl6P6H/FuRnCJV1xeC24aA01X/VIWbfCg45aIEjKE1YwB
cBImU2yYx6dp5Tjkb8zPCaoDUWqOElgj5EjzDm2N2vfspFOvigOdjW0JQdG6sBzE
8vxSgU9hXbddHpa5V4TYhzhTkIjMHrsaLwJoL8PqDlz+jWQcnjXjwUXJreQaGKQs
7GukGrxdHx3sFZHQrmnBv09FQMxL6lU1V0Gi2o3V+IzyX2DRxnGnsLy55NFVYZN5
tBD+LhpsJNNa0Q4uR1RvPfF6V+hRkQ==
=XMH9
-----END PGP SIGNATURE-----

--qLWXUA94TwkS4msl--
