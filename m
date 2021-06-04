Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3263A39BD09
	for <lists+live-patching@lfdr.de>; Fri,  4 Jun 2021 18:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFDQ0O (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Jun 2021 12:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhFDQ0N (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Jun 2021 12:26:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0163F613BF;
        Fri,  4 Jun 2021 16:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622823867;
        bh=NGB8rXa0uoRMdYpVi/8d63o1MFZR+oN9qStawJ0e010=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fdNnWhVEHUWkbXMDsrbZKBP9HPVkKy2jN3QLnKraKlfcmOT8gH7pxn9q1NghQq/wO
         R3vTjzgzfSoQBLevy2fkykoWSJTwvAxNgFtu6gEgczmyWQNjAL5Go1Bn5sagATwS4W
         lEYomuIEB/2udqHoeJPnhIkBSgFCGdXqs1hqMKgEOnYpi3M1u/SPAqb/IZVgh2dTZF
         s5r/qxd6K7skcnm++kIMMElqJ6klHFsw+cJDttbpz/PP27o6KFTCiYudpZuu1Wujrk
         gGMiH9N1hteua4tiifUldJymGZo9duSvxdNhld1kK41GvFCv8PJGNmft0mD5oOzQXP
         Ih9chHBZ7K8QA==
Date:   Fri, 4 Jun 2021 17:24:15 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v5 2/2] arm64: Create a list of SYM_CODE functions,
 check return PC against list
Message-ID: <20210604162415.GF4045@sirena.org.uk>
References: <20210526214917.20099-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ULyIDA2m8JTe+TiX"
Content-Disposition: inline
In-Reply-To: <20210526214917.20099-3-madvenka@linux.microsoft.com>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--ULyIDA2m8JTe+TiX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 26, 2021 at 04:49:17PM -0500, madvenka@linux.microsoft.com wrote:

> The unwinder should check if the return PC falls in any function that
> is considered unreliable from an unwinding perspective. If it does,
> mark the stack trace unreliable.

Reviwed-by: Mark Brown <broonie@kernel.org>

However it'd be good for someone else to double check this as it's
entirely possible that I've missed some case here.

> + * Some special cases covered by sym_code_functions[] deserve a mention here:

> + *	- All EL1 interrupt and exception stack traces will be considered
> + *	  unreliable. This is the correct behavior as interrupts and exceptions
> + *	  can happen on any instruction including ones in the frame pointer
> + *	  prolog and epilog. Unless stack metadata is available so the unwinder
> + *	  can unwind through these special cases, such stack traces will be
> + *	  considered unreliable.
> + *

If you're respinning this it's probably also worth noting that we only
ever perform reliable stack trace on either blocked tasks or the current
task which should if my reasoning is correct mean that the fact that
the exclusions here mean that we avoid having to worry about so many
race conditions when entering and leaving functions.  If we got
preempted at the wrong moment for one of them then we should observe the
preemption and mark the trace as unreliable due to that which means that
any confusion the race causes is a non-issue.

--ULyIDA2m8JTe+TiX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmC6U64ACgkQJNaLcl1U
h9C4QAf9HRBqFG+nZ5GixqyUqGGU9sr9f1Ymjd4s3kINKBCnuQtCpH5uA1qARlcT
xfpdyOCAroWlxaYytUlLNv26CkFEodFiu1+NI/fj4BIC56ACc8vB89tizCY2ZD3j
xN1PfXXFMD7xpH7O69RqgUlptgrGbCHeWijC9xIy88cnoviEri49h8q6MQvZnoOu
AYx1OQ+pCTOnno8YVfHghv5pHWHEFcyClHZ2HGXElWZx7/6uF+BhMFsfmm+dj+K0
8TffheBtjKX3qkRj4hFqr5L2FSS4+9EhBXXJEFsdTO8juhNkkPRYHdLfrwQCINss
/7O/GpYwALWDvyUiEka7PR7ybxMgqQ==
=eQAz
-----END PGP SIGNATURE-----

--ULyIDA2m8JTe+TiX--
