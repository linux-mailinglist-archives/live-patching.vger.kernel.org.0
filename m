Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B8F4856F1
	for <lists+live-patching@lfdr.de>; Wed,  5 Jan 2022 17:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242073AbiAEQ6s (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 Jan 2022 11:58:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37550 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242066AbiAEQ6r (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 Jan 2022 11:58:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6815161808;
        Wed,  5 Jan 2022 16:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6C0C36AE3;
        Wed,  5 Jan 2022 16:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641401926;
        bh=nj0XYkQ6LnvHJBBs+nGm9cAYBsvZjDrq4Frx02B/Q6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hIJ1ce16UzKoUTauYMLag04th28bUIExEDCZHczAbEoIhf/zWJZRd1wVhTzU79FsA
         pJid14yq1KSey8Y64NLpwQMbvD2NrksQFWLJPFoh2zoV3GsyH+8nkEMGWwrYA0cFvW
         FbxnNmxnNx9awxToxhKPd9s3oTpQIQgWFA8E4hsV4qjfxB0FgMFtwXSI7T+NgN6mxD
         4moQDzBh5ODAmq1pMppIaIcYONiJzWu34OGkHWV7gN95/VDNM1w+OxM5KArO5Pa7SY
         C9tSAkM65X4CDZQ677WTsQk8nU7AK6m2umePFK+FHxbpPrBgY/Kqb4HsRRP1qUCICH
         C+aEiBo+/X91w==
Date:   Wed, 5 Jan 2022 16:58:41 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 07/10] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <YdXOQTXscVaVFMJ3@sirena.org.uk>
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
 <20220103165212.9303-8-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="WgogfJD6sza3trQd"
Content-Disposition: inline
In-Reply-To: <20220103165212.9303-8-madvenka@linux.microsoft.com>
X-Cookie: Byte your tongue.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--WgogfJD6sza3trQd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 03, 2022 at 10:52:09AM -0600, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> There are some kernel features and conditions that make a stack trace
> unreliable. Callers may require the unwinder to detect these cases.
> E.g., livepatch.

Reviwed-by: Mark Brown <broonie@kernel.org>

--WgogfJD6sza3trQd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHVzkAACgkQJNaLcl1U
h9AVKwgAgIqIcY2WT5vZQM2ns7ljRLW3rsnU+4Ed6gk1VAmondFc6isDNhiargxv
T5XYbxo859VHVp2D4mBIKsL9N9x0CRWi7bS7WoBZGiKlE9DV2D8IqYAJbLQnVGB7
uLCH574vq74JAKz9ADgZCu97MMYaWdo3WYBZM3iUFBkwa9wZEPObyxccStiuWfhs
/Mv2hfTkMbSH/nbw+2Y0TQ2zBgtQuGbdcx5IbcNeyM+H2V5vewMKSohc51SbOero
PS/02AuX9BlBzFICAdFHJFpAobO/ez1g/tcP+oYh6VJE+UAi5WhyEi0BYowv6F+G
Qyk9HqGbtWQ0T4M98jY5SROFVdAbPg==
=+EKF
-----END PGP SIGNATURE-----

--WgogfJD6sza3trQd--
