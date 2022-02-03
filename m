Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F294A8323
	for <lists+live-patching@lfdr.de>; Thu,  3 Feb 2022 12:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350214AbiBCL3h (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Feb 2022 06:29:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60446 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350228AbiBCL3g (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Feb 2022 06:29:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B72046160E;
        Thu,  3 Feb 2022 11:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2D1C340E4;
        Thu,  3 Feb 2022 11:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643887775;
        bh=ttuZQnymlSP0Rk38x/PATcIzVeuS0aqQ2kTNVCxAdL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jO3UlxPZ4uPAsTvuEZG3N+iTdxkcFeUS884nVuiN6AJwpvy8SkqFWtZNQ6c2LgbF5
         VxIzkOuEu1HrfkDwXuVVr0qxkNlfuKxIFVOQSgmGtCwmAj8TcMzoJjWRbfPbq5RhqO
         O3WIPXyBwR6TlT3AeHHtRHq3PnKvV/ZD5UYfPZ1Ny+5S0k4UWvWsjJnuf9SRRRGjtr
         b5NzK0/4L4eoOVIcTouIvQ7TU8D4hhz6ZwUTPSmsk2vOAZFCyVIqg6WMf0jI7K5vcc
         lB2LHGYvMETZijJwEpFBTDvGDWSTj9sbfyq7Hlo3L30gFmkHrBCzDcYGypuiMKbibV
         JxRNAAnu2FCdA==
Date:   Thu, 3 Feb 2022 11:29:29 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 04/11] arm64: Split unwind_init()
Message-ID: <Yfu8mXxCPv3rhwqF@sirena.org.uk>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-5-madvenka@linux.microsoft.com>
 <YfrQ80PE8Nhg8lx3@sirena.org.uk>
 <bb9c0f6f-7f80-9d76-8bfe-7a2a82fa3544@linux.microsoft.com>
 <e44dd796-8675-2dee-7ad1-65d01058d5aa@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rPwUY+WGXwzlnf9F"
Content-Disposition: inline
In-Reply-To: <e44dd796-8675-2dee-7ad1-65d01058d5aa@linux.microsoft.com>
X-Cookie: Prices higher in Alaska and Hawaii.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--rPwUY+WGXwzlnf9F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 02, 2022 at 06:39:29PM -0600, Madhavan T. Venkataraman wrote:

> If what I have suggested above for comments is good enough, can I get a
> Reviewed-by for this? I will fix the comments on the next send.

I would think so, I'll take a look at the new version.

--rPwUY+WGXwzlnf9F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmH7vJgACgkQJNaLcl1U
h9DJ8Qf/Rc2RchWg7NzdAz8FdFEmXD+o50FlF+S5CBsEuHRfJR79AGPSd3QwCqEO
4vMr0aHigD3tZJDbQqDwBhyb+dQqi9Y665+1BQjZ8T+S4OKSE3T410xkV9n1gx73
zN3zHDNZNdc4YUjybUjoRKYQrAeywnGwM7IBPV9RXpNyIdFgYGw2JR+mVd5FRqmz
oBFo/TCCyz6kONqBr7ELMoovfsUTzKgQGB6V9GiJ8BW2PW6rY0hEeUpNf3RTXkND
f4i8Iq3g8Ifm+X2m504FdTMkijPfA3bRTkLwVMsxtfvsbY+E6kJQxsPMzcvUwzFO
5u5tiEwFGjuN40c2XwcwVhSjamRP/g==
=dGbC
-----END PGP SIGNATURE-----

--rPwUY+WGXwzlnf9F--
