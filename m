Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF708351C6D
	for <lists+live-patching@lfdr.de>; Thu,  1 Apr 2021 20:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhDASRd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Apr 2021 14:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237318AbhDASIA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Apr 2021 14:08:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3367A6128D;
        Thu,  1 Apr 2021 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617287292;
        bh=JFXI2qgnmtA6r8bUMZZVX4N/87ZKt4iyLtk7U97B1mA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e44YahgV/pu/QzxCZRD5kRVq1pm7DfpJ8cNgBXXdhSBjV2JLqG6Pl1jyJccu+GWoU
         6qcFYsY+NjpeufBfEsp6ClTfQeqJSULxx+VCLPsHa6UpKG2kuh4s+nqlaRbOmwjwxX
         rKR8qyaIloYa2lss0bTec2F8DVJN5Pbb9ZSigvmMRyLWdVriqn8RG1+6+qpoBLE79S
         akT8KrCEztgiIgdMyD/bCd/92Gimi1FcJKh+3lgOifZMcGLk9yFaCXgJnK72cd9PXM
         uX/C4306GX5OtzJQyqVvBA7sdsmS2VmLsNqruEjp1kPwNJ3XEQdCcrISq/IavflRPc
         GZ7PasG9qcPag==
Date:   Thu, 1 Apr 2021 15:27:59 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/4] arm64: Detect FTRACE cases that make the
 stack trace unreliable
Message-ID: <20210401142759.GJ4758@sirena.org.uk>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
 <20210330190955.13707-4-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+Hr//EUsa8//ouuB"
Content-Disposition: inline
In-Reply-To: <20210330190955.13707-4-madvenka@linux.microsoft.com>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--+Hr//EUsa8//ouuB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 30, 2021 at 02:09:54PM -0500, madvenka@linux.microsoft.com wrote:

> +	 * FTRACE trampolines.
> +	 */
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
> +	{ (unsigned long) &ftrace_graph_call, 0 },
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	{ (unsigned long) ftrace_graph_caller, 0 },
> +	{ (unsigned long) return_to_handler, 0 },
> +#endif
> +#endif

It's weird that we take the address of ftrace_graph_call but not the
other functions - we should be consistent or explain why.  It'd probably
also look nicer to not nest the ifdefs, the dependencies in Kconfig will
ensure we only get things when we should.

--+Hr//EUsa8//ouuB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBl2G4ACgkQJNaLcl1U
h9ABmwgAgAbbz3JBh1WdmU/r9m09iztnpUa9NC1TIa5viOMygEFVM6vdmqTldrbC
ytq45f+kzx514+suKlEN2/1OP8eUMY+4Fr7gqbbbGlAiwVs4Bb+lhsubkCrNd2La
8pvdwuj2l4moEzM3Yhz+DnC64XJGsDHWpqoRsSq3udh6AqD/jqfjfoZs4u5ZlrGC
13+fC7Q1JlTvzfCNvUc/YCvp+r1qWDo0A7oXiS519MgqyXt00pYIQgWcyfYIua/i
vXVQvO7P3x6Kfwj2aCGIG8Sxekiqupra+sFgHX3gQrmu6lwtOIBlbcqnpZ839t6q
wNKbkMbAJF8qQ5XbpIXE5b+VDJW3tg==
=i44Z
-----END PGP SIGNATURE-----

--+Hr//EUsa8//ouuB--
