Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D835438CAA3
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 18:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhEUQMo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 12:12:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhEUQMn (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 12:12:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BC12613DB;
        Fri, 21 May 2021 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621613480;
        bh=FNm3jXDRWoCbHZUTEZ8FokhLVtkukv3XsTG0pBzmCNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pzjPEFKSOYGIVYk5X+06MjnSj+zbF9uPA3+xtNQf31RQJJqJ8JVI5nwbY4d+SYK9u
         nv/8OayJ21Sztmy0ci0rAku1MnBOHXrgzRHFn1v0yhUjLNSL5AU679ECBfG8VaqwlG
         l4/zpYHHvBW+CpXy/02qwPlf9EGtdftKNAaAEzxkPU8vQDpFW/m/i57FU3aXo2v2I5
         79ErOLvQQD7beWhlcZkMGbINB7Lx7W7B2NhG/iUXGJzZz6tOD0K/ZK+28PXppHqhls
         fNONnG/6uDG61qsBMapKZjVYjmrKh1jwavLZZ4Iim8rRPda8fyx8vVyyRLArwAmtuW
         aP7sf32GFf+cA==
Date:   Fri, 21 May 2021 17:11:17 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210521161117.GB5825@sirena.org.uk>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <20210516040018.128105-2-madvenka@linux.microsoft.com>
X-Cookie: Do not write below this line.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 15, 2021 at 11:00:17PM -0500, madvenka@linux.microsoft.com wrote:

> Other reliability checks will be added in the future.

...

> +	frame->reliable = true;
> +

All these checks are good checks but as you say there's more stuff that
we need to add (like your patch 2 here) so I'm slightly nervous about
actually setting the reliable flag here without even a comment.  Equally
well there's no actual use of this until arch_stack_walk_reliable() gets
implemented so it's not like it's causing any problems and it gives us
the structure to start building up the rest of the checks.

The other thing I guess is the question of if we want to bother flagging
frames as unrelaible when we return an error; I don't see an issue with
it and it may turn out to make it easier to do something in the future
so I'm fine with that.

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCn26QACgkQJNaLcl1U
h9BRjwf+NUkllMR4DUBzihQYZz8gFCBdrphJycb1capE54XA922TiNiSHdNs6Un2
og9xrHSmjkris4pNB4/EoZ8drNtDgp3x8Rwgg7RbRhA0xujYmOoWGJuhdEuUEjID
jlkGNpt3oRJgBtEl3evUCSmXW0GK5a3emGmYA1yzUtuCFNIU4IfwO6r0d9R4Vc0U
koUUak44PssXvqETo+iCX8BFh1dCVB8hTrPQJRpTjxHUcljYUxRK5/7aT1pj2L/R
viAnHaZVX5h7RHy4oc/kKUG5jEY4WWdZembkRUhVjbYy+tNc5SLGNi9Gd3G8BxJw
YGsb0HGPBSkXuoM3WVDdcHpNRe3/Hw==
=FYp0
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
