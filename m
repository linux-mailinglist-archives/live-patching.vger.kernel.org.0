Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D5038CC8C
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 19:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbhEURs3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 13:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235764AbhEURs3 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 13:48:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 440E96135C;
        Fri, 21 May 2021 17:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621619226;
        bh=cWN0JGu1U5RmC5oI90b+qpmO91Xnj9OvS9/I5AtkfzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H8mP8SI5jLz8T9mM3hR84a5IiZvOJCpFHqIjlhGr29yQUwf9i9owT3p0AjyLKupcq
         igoFKglyVI01rI7+M3AWfTWGE2YtfrrXr6OIBub9cB2ydDK6olmgwnPz08eWIqF3xr
         6MHDFpV/FPLS4vjeE/7TP4k/Zsh1OWsN/1KffDA5qQakO3Asmt8iIDz9DSNCeg/Eqb
         Ci+/eTgpVjROD6J+sXgpe48Q2skktM+Cf8ZY2dtB2VAkY+q0hwrCBm4feqUeXrdIqs
         5DLHs8g8IY1LCVjg+e54ECHH0+QRuzBjrCOtab3KgMVukv0CpHz5n67516pwM8nI15
         vcl7BH6mrqnaA==
Date:   Fri, 21 May 2021 18:47:02 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/2] arm64: Stack trace reliability checks in the
 unwinder
Message-ID: <20210521174702.GE5825@sirena.org.uk>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210521171808.GC5825@sirena.org.uk>
 <654dde25-e6a2-a1e7-c2d7-e2692bc11528@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="y2zxS2PfCDLh6JVG"
Content-Disposition: inline
In-Reply-To: <654dde25-e6a2-a1e7-c2d7-e2692bc11528@linux.microsoft.com>
X-Cookie: Do not write below this line.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--y2zxS2PfCDLh6JVG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 21, 2021 at 12:32:52PM -0500, Madhavan T. Venkataraman wrote:

> I have followed the example in the Kprobe deny list. I place the section
> in initdata so it can be unloaded during boot. This means that I need to
> copy the information before that in early_initcall().

> If the initialization must be performed on first use, I probably have to
> move SYM_CODE_FUNCTIONS from initdata to some other place where it will
> be retained.

> If you prefer this, I could do it this way.

No, I think if people are fine with this for kprobes they should be fine
with it here too and if not we can always incrementally improve
performance - let's just keep things simple and easy to understand for
now.

--y2zxS2PfCDLh6JVG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCn8hUACgkQJNaLcl1U
h9CpOAf/Q4aP4/5mF9ljr9J5jNhisd1b45ubcxDK4BydV49CeeteBqjbHVZTrJ5i
uh6GaLMsIVW5vfPcuXaEoVG2lyk/de6/hgN6HPmRklu9YulwUoiCUbnuTQUkU9N6
xSyN6HSMJwBoAKazP6xzC3kPHDR4Mii7V6LdKzqNnTfZBD8HJ6P8J8TqQkf9Zo99
KySAfMtZfuM14vzoZiDDQlSiZC9/dt7P68bvVPWkRBjoJ41v+rFFqsmilNC9AsaF
XR6n0EDRA7wkhHROR7vCOy2+7r+PkmquVPsVTpl0LE/BJveX2I6DuCEy99qdbrR+
87ufTffS8iR0fYqpj6ylwV2cnqLVkA==
=oMaY
-----END PGP SIGNATURE-----

--y2zxS2PfCDLh6JVG--
