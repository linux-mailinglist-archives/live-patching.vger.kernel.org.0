Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D07937556E
	for <lists+live-patching@lfdr.de>; Thu,  6 May 2021 16:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbhEFONr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 May 2021 10:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233737AbhEFONq (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 May 2021 10:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E0C0610A6;
        Thu,  6 May 2021 14:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620310367;
        bh=Gtp++8OISnKlL7igW1jsmr8lSaw32BvY9v1KfWv5ncU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dvbWjFFU2pzS4gM2+/va2sQm/uvGhbrXjdWBmOorH903z16u8tbwh24qRUnzY0Ivf
         ZgBqPscl7PccHeK3TJh+2tYecsXbytQl+SXDXgjbdHXIcy26HuVPS/s8fi3C6XoPcS
         NZ+dzxu5VgZRaBBdtBrdF9JML0mUZZGuWD8uJt1qk3u76/qSX2KbP1qG6lCERAmwxN
         Z2/3ruLnSpWpvTFX91Dsm5bRQCMJwXrRUvr0BsxRtlwVZgW6ZX0tceSONXJ/yOrzYB
         0KRc70WlZMt9TzYjuHa/Jm4WwTTpVchtvqJ40zqtUqYiH1+rNL6FJw19oeeibyekZr
         M4EV3QrH9efRw==
Date:   Thu, 6 May 2021 15:12:11 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/4] arm64: Handle miscellaneous functions in
 .text and .init.text
Message-ID: <20210506141211.GE4642@sirena.org.uk>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-4-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9l24NVCWtSuIVIod"
Content-Disposition: inline
In-Reply-To: <20210503173615.21576-4-madvenka@linux.microsoft.com>
X-Cookie: If it ain't baroque, don't phiques it.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--9l24NVCWtSuIVIod
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 03, 2021 at 12:36:14PM -0500, madvenka@linux.microsoft.com wrote:

> There are some SYM_CODE functions that are currently in ".text" or
> ".init.text" sections. Some of these are functions that the unwinder
> does not care about as they are not "interesting" to livepatch. These
> will remain in their current sections. The rest I have moved into a
> new section called ".code.text".

I was thinking it'd be good to do this by modifying SYM_CODE_START() to
emit the section, that way nobody can forget to put any SYM_CODE into a
special section.  That does mean we'd have to first introduce a new
variant for specifying a section that lets us override things that need
to be in some specific section and convert everything that's in a
special section over to that first which is a bit annoying but feels
like it's worth it for the robustness.  It'd also put some of the don't
cares into .code.text but so long as they are actually don't cares that
should be fine!

> Don't care functions
> ====================

We also have a bunch of things like __cpu_soft_restart which don't seem
to be called out here but need to be in .idmap.text.

--9l24NVCWtSuIVIod
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCT+ToACgkQJNaLcl1U
h9ABFgf/Z5OheyVXijHxIjnaaC+SDZlNsGtc6XqdehcMncCJVr16obC0q5aBjRLy
i4VZOPM2GQ0pxk0Dx/xujpeeRhb6owdcraXotZDQNJNUy0IhFGXZ0hCKTei2ow/U
f8OTvJVvrGzSuC7YwvkkEOgwnj4ZwVK1hMn/fvcifC5qGbIeuUFDQmxiRAke2Hcf
zd0NzogA1c3RAyNx2HJTQVDF7O0LHeTwq31TPpS6sx94A9Jaadk/G/MtuZvWMiri
jQTp8nTuDuLBlN5ToSeV0Y1u5F5KVnddt+g0GqXsxelvhCcujmIesVPCePX3jXAE
3FIUnUQGQBv/iJYyjJ9v6h8oEp0obg==
=COOq
-----END PGP SIGNATURE-----

--9l24NVCWtSuIVIod--
